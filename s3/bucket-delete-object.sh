#!/bin/bash

echo "1. Nome do bucket: "
read BUCKET_NAME

echo "2. Caminho do objeto a apagar: "
read OBJECT_PATH

echo "3. O objeto é uma pasta? (Y/N) "
read ANSWER
UPPER_ANSWER=`echo "$ANSWER" | tr '[:lower:]' '[:upper:]'`

if [[ $UPPER_ANSWER = 'Y' ]]
then
    RECURSIVE_PARAM="--recursive"
else
    RECURSIVE_PARAM=""
fi

aws s3 rm s3://$BUCKET_NAME/$OBJECT_PATH $RECURSIVE_PARAM

if [[ ${?} -eq 0 ]]
then
    echo "Objeto $OBJECT_PATH apagado com sucesso!"
else
    echo "Erro ao apagar o objeto."
fi

