#!/bin/bash

echo "Está na mesma pasta do objeto a fazer upload? (Y/N)"
read ANSWER
UPPER_ANSWER=`echo "$ANSWER" | tr '[:lower:]' '[:upper:]'`

if [[ $UPPER_ANSWER = 'N' ]]
then
    echo "Certifique-se de estar na mesma pasta do objeto a fazer upload e tente novamente."
    exit
fi

echo "1. Nome do bucket: "
read BUCKET_NAME

echo "2. Nome do objeto: "
read OBJECT_NAME

if [[ -d $PWD/$OBJECT_NAME ]]
then
    RECURSIVE_PARAM="--recursive"
    FOLDER_PARAM=$OBJECT_NAME
elif [[ -f $PWD/$OBJECT_NAME ]]
then
    RECURSIVE_PARAM=""
    FOLDER_PARAM=""
else
    echo "$OBJECT_NAME não é válido"
    exit
fi

aws s3 cp $OBJECT_NAME s3://$BUCKET_NAME/$FOLDER_PARAM $RECURSIVE_PARAM

if [[ ${?} -eq 0 ]]
then
    echo "Objeto subido no bucket $BUCKET_NAME com sucesso!"
else
    echo "Erro no envio do objeto."
fi

