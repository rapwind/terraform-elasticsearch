#
# Create ECR repository
#
resource "aws_ecr_repository" "es" {
  name = "${var.ecr_repository_name}"
}

resource "aws_ecr_repository_policy" "es" {
  repository = "${aws_ecr_repository.es.name}"
  policy = "${file("policies/ecr_repository-policy.json")}"
}

#
# ECS Define task
#
resource "aws_ecs_task_definition" "es-coordinator" {
  family = "${var.app_name}-coordinator"
  container_definitions = "${template_file.coordinator_registry_task.rendered}"

  volume {
    name = "data"
    host_path = "/var/elasticsearch/data"
  }
}
resource "aws_ecs_task_definition" "es-workhorse" {
  family = "${var.app_name}-workhorse"
  container_definitions = "${template_file.workhorse_registry_task.rendered}"

  volume {
    name = "data"
    host_path = "/var/elasticsearch/data"
  }
}
resource "aws_ecs_task_definition" "es-searchLoadBalancer" {
  family = "${var.app_name}-searchLoadBalancer"
  container_definitions = "${template_file.searchLoadBalancer_registry_task.rendered}"

  volume {
    name = "data"
    host_path = "/var/elasticsearch/data"
  }
}
resource "aws_ecs_task_definition" "es-kibana" {
  family = "${var.app_name}-kibana"
  container_definitions = "${template_file.kibana_registry_task.rendered}"
}

#
# Create ECS cluster
#
resource "aws_ecs_cluster" "es-coordinator" {
  name = "${var.ecs_cluster_name}-coordinator"
}
resource "aws_ecs_cluster" "es-workhorse" {
  name = "${var.ecs_cluster_name}-workhorse"
}
resource "aws_ecs_cluster" "es-searchLoadBalancer" {
  name = "${var.ecs_cluster_name}-searchLoadBalancer"
}
resource "aws_ecs_cluster" "es-kibana" {
  name = "${var.ecs_cluster_name}-kibana"
}

#
# ECS Define services
#
resource "aws_ecs_service" "es-coordinator" {
  name = "${var.app_name}-coordinator"
  cluster = "${aws_ecs_cluster.es-coordinator.id}"
  task_definition = "${aws_ecs_task_definition.es-coordinator.arn}"
  desired_count = "${var.coordinator_instance_size.desired_capacity}"
}
resource "aws_ecs_service" "es-workhorse" {
  name = "${var.app_name}"
  cluster = "${aws_ecs_cluster.es-workhorse.id}"
  task_definition = "${aws_ecs_task_definition.es-workhorse.arn}"
  desired_count = "${var.workhorse_instance_size.desired_capacity}"
}
resource "aws_ecs_service" "es-searchLoadBalancer" {
  name = "${var.app_name}"
  cluster = "${aws_ecs_cluster.es-searchLoadBalancer.id}"
  task_definition = "${aws_ecs_task_definition.es-searchLoadBalancer.arn}"
  desired_count = "${var.searchLoadBalancer_instance_size.desired_capacity}"
}
resource "aws_ecs_service" "es-kibana" {
  name = "${var.app_name}"
  cluster = "${aws_ecs_cluster.es-kibana.id}"
  task_definition = "${aws_ecs_task_definition.es-kibana.arn}"
  desired_count = "${var.searchLoadBalancer_instance_size.desired_capacity}"
}
