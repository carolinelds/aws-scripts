#!/bin/bash

echo "1. Nome do bucket: "
read BUCKET_NAME

aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --create-bucket-configuration LocationConstraint="sa-east-1" \
&& \
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration \
        "BlockPublicAcls=true, \
        IgnorePublicAcls=true, \
        BlockPublicPolicy=true, \
        RestrictPublicBuckets=true"

if [[ ${?} -eq 0 ]]
then
    echo "Bucket $BUCKET_NAME criado com sucesso!"
else
    echo "Erro no deploy do bucket."
fi

