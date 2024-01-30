#!/bin/bash

echo ENVIAR EVENTO PARA O TOPICO
# SP
awslocal sns publish --endpoint-url=http://localhost:4566 --topic-arn arn:aws:sns:sa-east-1:000000000000:sp --message "$texto" --region sa-east-1 --output json | cat
# RJ
awslocal sns publish --endpoint-url=http://localhost:4566 --topic-arn arn:aws:sns:sa-east-1:000000000000:rj --message "$texto" --region sa-east-1 --output json | cat


echo RECEBER MENSAGEM
# CPV
watch "aws --endpoint-url=http://localhost:4566 sqs receive-message --queue-url http://localhost:4566/000000000000/cpv --region sa-east-1 --output json | cat"
# SJC
watch "aws --endpoint-url=http://localhost:4566 sqs receive-message --queue-url http://localhost:4566/000000000000/sjc --region sa-east-1 --output json | cat"

# Listar bucket
# awslocal s3 ls s3://mybucket/bucketsp/cpv/
# awslocal s3 ls s3://mybucket/bucketsp/sjc/
# awslocal s3 ls s3://mybucket/bucketsp/tbt/
# awslocal s3 ls s3://mybucket/bucketrj/tbt/
# awslocal s3 ls s3://mybucket/bucketrj/vr/
# awslocal s3 ls s3://mybucket/bucketrj/pt/

# Apagar arquivo bucket
# awslocal s3 rm s3://mybucket/bucketsp/cpv/

# Listando o bucket (S3)
# awslocal s3 ls s3://mybucket --recursive