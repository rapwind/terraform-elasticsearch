# Usage on Mac
## Install Docker
```
$ brew install virtualbox
$ brew install docker
$ brew install docker-machine
$ docker-machine create --driver virtualbox dev
$ eval $(docker-machine env dev)
```
append the line to your `.bash_profile`
```
eval $(docker-machine env dev)
```

## Port Forwarding
```
$ VBoxManage controlvm "dev" natpf1 "elasticsearch,tcp,127.0.0.1,9200,,9200"
$ VBoxManage controlvm "dev" natpf1 "elasticsearch-cluster,tcp,127.0.0.1,9300,,9300"
```

## Clone Dockerfile
```
$ git clone git@github.com:rapwind/terraform-elasticsearch.git
$ cd google-e-ops/elasticsearch
```

## Create Docker Image
```
$ docker build -t google/elasticsearch .
```

## Run
```
$ docker run -d -p 9200:9200 google/elasticsearch
```
