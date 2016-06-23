resource "template_file" "coordinator_registry_task" {
  template = "${file("task-definitions/registry.json")}"

  vars {
    registry_docker_repository = "${aws_ecr_repository.es.registry_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository_name}:coordinator"
  }
}
resource "template_file" "workhorse_registry_task" {
  template = "${file("task-definitions/workhorse_registry.json")}"

  vars {
    registry_docker_repository = "${aws_ecr_repository.es.registry_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository_name}:workhorse"
  }
}
resource "template_file" "searchLoadBalancer_registry_task" {
  template = "${file("task-definitions/registry.json")}"

  vars {
    registry_docker_repository = "${aws_ecr_repository.es.registry_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository_name}:searchLoadBalancer"
  }
}
resource "template_file" "kibana_registry_task" {
  template = "${file("task-definitions/kibana_registry.json")}"

  vars {
    registry_docker_repository = "${aws_ecr_repository.es.registry_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository_name}:kibana"
  }
}
