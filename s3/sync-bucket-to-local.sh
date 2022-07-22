#!/bin/bash

echo "Está na pasta que deseja sincronizar com o bucket? (Y/N)"
read ANSWER
UPPER_ANSWER=`echo "$ANSWER" | tr '[:lower:]' '[:upper:]'`

if [[ $UPPER_ANSWER = 'N' ]]
then
    echo "Certifique-se de estar na pasta que deseja sincronizar com o bucket e tente novamente."
    exit
fi

echo "1. Nome do bucket: "
read BUCKET_NAME

aws s3 sync . s3://$BUCKET_NAME

if [[ ${?} -eq 0 ]]
then
    echo "Bucket $BUCKET_NAME sincronizado com sucesso!"
else
    echo "Erro na sincronização do bucket."
fi

