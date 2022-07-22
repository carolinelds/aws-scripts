#!/bin/bash

echo "1. Nome do bucket para associar à distribuição CloudFront: "
echo "(certifique-se de que ele possui um index.html na raiz)"
read BUCKET_NAME

BUCKET_REGION=$(echo `aws s3api get-bucket-location --bucket $BUCKET_NAME` | jq -r '.LocationConstraint')

OAI_ID=$(echo `aws cloudfront list-cloud-front-origin-access-identities --max-items 1 --no-paginate` | jq -r '.CloudFrontOriginAccessIdentityList.Items[0].Id')

PATH_ID=$BUCKET_NAME.s3.$BUCKET_REGION.amazonaws.com-cli

PATH_DOMAIN=$BUCKET_NAME.s3.$BUCKET_REGION.amazonaws.com

cat distconfig-template.json \
| jq --arg oai "origin-access-identity/cloudfront/$OAI_ID" --arg id "$PATH_ID" --arg domain "$PATH_DOMAIN" '.Origins.Items[0] |= ( .S3OriginConfig.OriginAccessIdentity = $oai | .Id = $id | .DomainName = $domain )' \
| jq --arg id "$PATH_ID" '.DefaultCacheBehavior.TargetOriginId = $id' \
> distconfig.json

cat bucketpolicy-template.json \
| jq --arg oai "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity $OAI_ID" '.Statement[0].Principal.AWS = $oai' \
| jq --arg resource "arn:aws:s3:::$BUCKET_NAME/*" '.Statement[0].Resource = $resource' \
> bucketpolicy.json

aws cloudfront create-distribution \
    --distribution-config file://distconfig.json

aws s3api put-bucket-policy --bucket $BUCKET_NAME \
    --policy file://bucketpolicy.json

rm -rf bucketpolicy.json
rm -rf distconfig.json

if [[ ${?} -eq 0 ]]
then
    echo "Distribuição CloudFront criada com sucesso!"
else
    echo "Erro na criação da distribuição."
fi