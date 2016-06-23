export ES_CLUSTER_AWS_KEYS=\
"cloud.aws.access_key: $(terraform output -state="../terraform/terraform.tfstate" ec2_describe_instances_aws_iam_access_key_id)
cloud.aws.secret_key: $(terraform output -state="../terraform/terraform.tfstate" ec2_describe_instances_aws_iam_access_key_secret)"

rm -f elasticsearch.yml
cp elasticsearch-templete.yml elasticsearch.yml
cat elasticsearch-coordinator.yml >> elasticsearch.yml
cat elasticsearch-aws.yml >> elasticsearch.yml
echo $ES_CLUSTER_AWS_KEYS >> elasticsearch.yml
docker build -t coordinator .

rm -f elasticsearch.yml
cp elasticsearch-templete.yml elasticsearch.yml
cat elasticsearch-workhorse.yml >> elasticsearch.yml
cat elasticsearch-aws.yml >> elasticsearch.yml
echo $ES_CLUSTER_AWS_KEYS >> elasticsearch.yml
docker build -t workhorse .

rm -f elasticsearch.yml
cp elasticsearch-templete.yml elasticsearch.yml
cat elasticsearch-search-load-barancer.yml >> elasticsearch.yml
cat elasticsearch-aws.yml >> elasticsearch.yml
echo $ES_CLUSTER_AWS_KEYS >> elasticsearch.yml
docker build -t searchloadbalancer .

$(aws ecr get-login --region us-east-1)
docker tag coordinator:latest 408959182472.dkr.ecr.us-east-1.amazonaws.com/elasticsearch-image:coordinator
docker push 408959182472.dkr.ecr.us-east-1.amazonaws.com/elasticsearch-image:coordinator
docker tag workhorse:latest 408959182472.dkr.ecr.us-east-1.amazonaws.com/elasticsearch-image:workhorse
docker push 408959182472.dkr.ecr.us-east-1.amazonaws.com/elasticsearch-image:workhorse
docker tag searchloadbalancer:latest 408959182472.dkr.ecr.us-east-1.amazonaws.com/elasticsearch-image:searchLoadBalancer
docker push 408959182472.dkr.ecr.us-east-1.amazonaws.com/elasticsearch-image:searchLoadBalancer

rm -f elasticsearch.yml

cd kibana
docker build -t kibana .
docker tag kibana:latest 408959182472.dkr.ecr.us-east-1.amazonaws.com/elasticsearch-image:kibana
docker push 408959182472.dkr.ecr.us-east-1.amazonaws.com/elasticsearch-image:kibana

rm -f elasticsearch.yml
cp elasticsearch-templete.yml elasticsearch.yml
docker build -t local-elasticsearch .


