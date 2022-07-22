#!/bin/bash

echo "1. Nome do bucket para apagar: "
read BUCKET_NAME

aws s3 rb s3://$BUCKET_NAME --force

if [[ ${?} -eq 0 ]]
then
    echo "Bucket $BUCKET_NAME apagado com sucesso!"
else
    echo "Erro ao apagar o bucket."
fi

