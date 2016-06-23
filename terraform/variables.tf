variable "aws_access_key" {
  description = "The AWS access key."
}

variable "aws_secret_key" {
  description = "The AWS secret key."
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-1"
}

variable "availability_zones" {
  description = "The availability zones"
  default = "us-east-1b,us-east-1c"
}

variable "app_name" {
  description = "The name of the Application."
  default = "Elasticsearch"
}

variable "ecr_repository_name" {
  description = "The name of the Amazon ECR repository."
  default = "elasticsearch-image"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default = "elasticsearch-cluster"
}

# ECS optimized AMIs per region
variable "amis" {
  default = {
    us-east-1 = "ami-a1fa1acc"
  }
}

variable "coordinator_instance_type" {
  default = "t2.micro"
}
variable "workhorse_instance_type" {
  default = "c4.large"
}
variable "slb_instance_type" {
  default = "t2.micro"
}
variable "workhorse_ebs_block_device" {
  default = {
    device_name = "/dev/xvdcz"
    volume_type = "gp2"
    volume_size = 40
    delete_on_termination = true
  }
}

variable "key_name" {
  description = "The aws ssh key name."
  default = "id_rsa"
}

variable "key_file" {
  description = "The ssh public key for using with the cloud provider."
  default = "id_rsa.pub"
}

variable "coordinator_instance_size" {
  default = {
    max_size = 4
    min_size = 1
    desired_capacity = 2
  }
}
variable "workhorse_instance_size" {
  default = {
    max_size = 20
    min_size = 6
    desired_capacity = 10
  }
}
variable "searchLoadBalancer_instance_size" {
  default = {
    max_size = 4
    min_size = 1
    desired_capacity = 2
  }
}
