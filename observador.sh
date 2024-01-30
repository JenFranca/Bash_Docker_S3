#!/bin/bash

# variaveis 
cont_dist_cpv=1
cont_dist_sjc=1
cont_dist_sp_tbt=1
cont_dist_rj_tbt=1
cont_dist_vr=1
cont_dist_pt=1


while [ 1 ]; do
    # CPV
    # colocando a mensagem dentro da variavel
    dist_cpv=$(awslocal sqs receive-message --queue-url http://localhost:4566/000000000000/cpv --region sa-east-1 --output json | cat)
    # pegando tudo que é diferente de "vazio"
    if [ "$dist_cpv" != "" ]; then   
        # aplicando a variavel em um arquivo   
        echo $dist_cpv > msg_cpv_"$cont_dist_cpv".log
        # salvando o arquivo no s3
        awslocal s3 cp msg_cpv_"$cont_dist_cpv".log s3://mybucket/bucketsp/cpv/

        # filtrando da msg recebida e aplicando informação dentro da variavel
        del_cpv=$(echo $dist_cpv | grep -o '"ReceiptHandle": "[^"]*' | grep -o '[^"]*$')
        # apagando mensagem informando a variavel
        awslocal sqs delete-message --endpoint-url=http://localhost:4566 --queue-url http://localhost:4566/000000000000/cpv --region sa-east-1  --receipt-handle $del_cpv
        # apagando arquivo gerado fora da nuvem
        rm msg_cpv_"$cont_dist_cpv".log
        
        # aplicando contador
        cont_dist_cpv=$((cont_dist_cpv+1))        
    fi
    # SJC
    dist_sjc=$(awslocal sqs receive-message --queue-url http://localhost:4566/000000000000/sjc --region sa-east-1 --output json | cat)
    if [ "$dist_sjc" != "" ]; then     
        echo $dist_sjc > msg_sjc_"$cont_dist_sjc".log
        awslocal s3 cp msg_sjc_"$cont_dist_sjc".log s3://mybucket/bucketsp/sjc/

        del_sjc=$(echo $dist_sjc | grep -o '"ReceiptHandle": "[^"]*' | grep -o '[^"]*$')
        awslocal sqs delete-message --endpoint-url=http://localhost:4566 --queue-url http://localhost:4566/000000000000/sjc --region sa-east-1  --receipt-handle $del_sjc
        
        rm msg_sjc_"$cont_dist_sjc".log
        
        cont_dist_sjc=$((cont_dist_sjc+1))     
    fi
    # TBT
    dist_tbt=$(awslocal sqs receive-message --queue-url http://localhost:4566/000000000000/tbt --region sa-east-1 --output json | cat)
    if [ "$dist_tbt" != "" ]; then           
       
        topicarn=$(echo $dist_tbt | grep -o '"TopicArn\\": \\"arn:aws:sns:sa-east-1:000000000000:[^\\"]*' | grep -o '[^\\:]*$')

        if [ "$topicarn" = "sp" ]; then
            echo $dist_tbt > msg_tbt_"$cont_dist_sp_tbt".log
            awslocal s3 cp msg_tbt_"$cont_dist_sp_tbt".log s3://mybucket/bucketsp/tbt/
            # Apagando..
            rm msg_tbt_"$cont_dist_sp_tbt".log

            cont_dist_sp_tbt=$((cont_dist_sp_tbt+1))   
        
        elif [ "$topicarn" = "rj" ]; then
            echo $dist_tbt > msg_tbt_"$cont_dist_rj_tbt".log
            awslocal s3 cp msg_tbt_"$cont_dist_rj_tbt".log s3://mybucket/bucketrj/tbt/
            # Apagando..
            rm msg_tbt_"$cont_dist_rj_tbt".log

            cont_dist_rj_tbt=$((cont_dist_rj_tbt+1))
        fi    

        del_tbt=$(echo $dist_tbt | grep -o '"ReceiptHandle": "[^"]*' | grep -o '[^"]*$')
        awslocal sqs delete-message --endpoint-url=http://localhost:4566 --queue-url http://localhost:4566/000000000000/tbt --region sa-east-1  --receipt-handle $del_tbt
         
    fi
    # VR
    dist_vr=$(awslocal sqs receive-message --queue-url http://localhost:4566/000000000000/vr --region sa-east-1 --output json | cat)
    if [ "$dist_vr" != "" ]; then     
        echo $dist_vr > msg_vr_"$cont_dist_vr".log
        awslocal s3 cp msg_vr_"$cont_dist_vr".log s3://mybucket/bucketrj/vr/

        del_vr=$(echo $dist_vr | grep -o '"ReceiptHandle": "[^"]*' | grep -o '[^"]*$')
        awslocal sqs delete-message --endpoint-url=http://localhost:4566 --queue-url http://localhost:4566/000000000000/vr --region sa-east-1  --receipt-handle $del_vr
        
        rm msg_vr_"$cont_dist_vr".log
        
        cont_dist_vr=$((cont_dist_vr+1))     
    fi
    # PT
    dist_pt=$(awslocal sqs receive-message --queue-url http://localhost:4566/000000000000/pt --region sa-east-1 --output json | cat)
    if [ "$dist_pt" != "" ]; then     
        echo $dist_pt > msg_pt_"$cont_dist_pt".log
        awslocal s3 cp msg_pt_"$cont_dist_pt".log s3://mybucket/bucketrj/pt/

        del_pt=$(echo $dist_pt | grep -o '"ReceiptHandle": "[^"]*' | grep -o '[^"]*$')
        awslocal sqs delete-message --endpoint-url=http://localhost:4566 --queue-url http://localhost:4566/000000000000/pt --region sa-east-1  --receipt-handle $del_pt
        
        rm msg_pt_"$cont_dist_pt".log
        
        cont_dist_pt=$((cont_dist_pt+1))     
    fi
done
