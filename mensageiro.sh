#!/bin/bash

while [ 1 ]; do
    echo SP ou RJ?
    read lugar
    echo Insira sua mensagem:
    read texto
    if [ "$lugar" = "SP" ] | [ "$lugar" = "sp" ]; then
        awslocal sns publish --endpoint-url=http://localhost:4566 --topic-arn arn:aws:sns:sa-east-1:000000000000:sp --message "$texto" --region sa-east-1 --output json | cat
    elif [ "$lugar" = "RJ" ]| [ "$lugar" = "rj" ]; then
        awslocal sns publish --endpoint-url=http://localhost:4566 --topic-arn arn:aws:sns:sa-east-1:000000000000:rj --message "$texto" --region sa-east-1 --output json | cat
    fi
done
