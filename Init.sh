#!/bin/bash

echo INICIAR LOCALSTACK
localstack start -d

echo CRIADO TOPICOS
awslocal sns create-topic --name sp --region sa-east-1 --output table | cat
awslocal sns create-topic --name rj --region sa-east-1 --output table | cat

echo CRIADO FILAS
awslocal sqs create-queue --queue-name cpv --region sa-east-1 --output table | cat
awslocal sqs create-queue --queue-name sjc --region sa-east-1 --output table | cat
awslocal sqs create-queue --queue-name tbt --region sa-east-1 --output table | cat
awslocal sqs create-queue --queue-name vr --region sa-east-1 --output table | cat
awslocal sqs create-queue --queue-name pt --region sa-east-1 --output table | cat

echo ASSINATURA
awslocal sns subscribe --topic-arn arn:aws:sns:sa-east-1:000000000000:sp --protocol sqs --notification-endpoint arn:aws:sns:sa-east-1:000000000000:cpv --region sa-east-1 --output table | cat
awslocal sns subscribe --topic-arn arn:aws:sns:sa-east-1:000000000000:sp --protocol sqs --notification-endpoint arn:aws:sns:sa-east-1:000000000000:sjc --region sa-east-1 --output table | cat
awslocal sns subscribe --topic-arn arn:aws:sns:sa-east-1:000000000000:sp --protocol sqs --notification-endpoint arn:aws:sns:sa-east-1:000000000000:tbt --region sa-east-1 --output table | cat
awslocal sns subscribe --topic-arn arn:aws:sns:sa-east-1:000000000000:rj --protocol sqs --notification-endpoint arn:aws:sns:sa-east-1:000000000000:tbt --region sa-east-1 --output table | cat
awslocal sns subscribe --topic-arn arn:aws:sns:sa-east-1:000000000000:rj --protocol sqs --notification-endpoint arn:aws:sns:sa-east-1:000000000000:vr --region sa-east-1 --output table | cat
awslocal sns subscribe --topic-arn arn:aws:sns:sa-east-1:000000000000:rj --protocol sqs --notification-endpoint arn:aws:sns:sa-east-1:000000000000:pt --region sa-east-1 --output table | cat

echo CRIAR BUCKET
awslocal s3api create-bucket --bucket mybucket
