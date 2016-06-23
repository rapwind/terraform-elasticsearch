#
# Instance configuration
#
resource "aws_key_pair" "deployer" {
  key_name = "${var.key_name}"
  public_key = "${file("keys/id_rsa.pub")}"
}

resource "aws_launch_configuration" "es-config-coordinator" {
  name = "es-config-coordinator"
  instance_type = "${var.coordinator_instance_type}"
  image_id = "${lookup(var.amis, var.region)}"
  security_groups = ["${aws_security_group.allow_all.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs_iam_role.name}"
  key_name = "${aws_key_pair.deployer.key_name}"
  user_data = "#!/bin/bash\necho ECS_CLUSTER='${aws_ecs_cluster.es-coordinator.name}' > /etc/ecs/ecs.config"
}
resource "aws_launch_configuration" "es-config-workhorse" {
  name = "es-config-workhorse"
  instance_type = "${var.workhorse_instance_type}"
  image_id = "${lookup(var.amis, var.region)}"
  security_groups = ["${aws_security_group.allow_all.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs_iam_role.name}"
  key_name = "${aws_key_pair.deployer.key_name}"
  user_data = "#!/bin/bash\necho ECS_CLUSTER='${aws_ecs_cluster.es-workhorse.name}' > /etc/ecs/ecs.config"
  # ebs_block_device {
  #   device_name = "${var.workhorse_ebs_block_device.device_name}"
  #   volume_type = "${var.workhorse_ebs_block_device.volume_type}"
  #   volume_size = "${var.workhorse_ebs_block_device.volume_size}"
  #   delete_on_termination = "${var.workhorse_ebs_block_device.delete_on_termination}"
  # }
}
resource "aws_launch_configuration" "es-config-searchLoadBalancer" {
  name = "es-config-searchLoadBalancer"
  instance_type = "${var.slb_instance_type}"
  image_id = "${lookup(var.amis, var.region)}"
  security_groups = ["${aws_security_group.allow_all.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs_iam_role.name}"
  key_name = "${aws_key_pair.deployer.key_name}"
  user_data = "#!/bin/bash\necho ECS_CLUSTER='${aws_ecs_cluster.es-searchLoadBalancer.name}' > /etc/ecs/ecs.config"
}
resource "aws_launch_configuration" "es-config-kibana" {
  name = "es-config-kibana"
  instance_type = "t2.micro"
  image_id = "${lookup(var.amis, var.region)}"
  security_groups = ["${aws_security_group.allow_all.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs_iam_role.name}"
  key_name = "${aws_key_pair.deployer.key_name}"
  user_data = "#!/bin/bash\necho ECS_CLUSTER='${aws_ecs_cluster.es-kibana.name}' > /etc/ecs/ecs.config"
}

#
# AutoScaling group resource
#
resource "aws_autoscaling_group" "es-coordinator" {
  availability_zones = ["${split(",", var.availability_zones)}"]
  vpc_zone_identifier = ["${aws_subnet.private-us-east-1b.id}", "${aws_subnet.private-us-east-1c.id}"]
  name = "${var.app_name}-coordinator AutoScaling Group"
  max_size = "${var.coordinator_instance_size.max_size}"
  min_size = "${var.coordinator_instance_size.min_size}"
  health_check_grace_period = 300
  health_check_type = "EC2"
  desired_capacity = "${var.coordinator_instance_size.desired_capacity}"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.es-config-coordinator.name}"

  tag {
    key = "es_cluster"
    value = "coordinator"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_group" "es-workhorse" {
  availability_zones = ["${split(",", var.availability_zones)}"]
  vpc_zone_identifier = ["${aws_subnet.private-us-east-1b.id}", "${aws_subnet.private-us-east-1c.id}"]
  name = "${var.app_name}-workhorse AutoScaling Group"
  max_size = "${var.workhorse_instance_size.max_size}"
  min_size = "${var.workhorse_instance_size.min_size}"
  health_check_grace_period = 300
  health_check_type = "EC2"
  desired_capacity = "${var.workhorse_instance_size.desired_capacity}"
  launch_configuration = "${aws_launch_configuration.es-config-workhorse.name}"

  tag {
    key = "es_cluster"
    value = "workhorse"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_group" "es-searchLoadBalancer" {
  availability_zones = ["${split(",", var.availability_zones)}"]
  vpc_zone_identifier = ["${aws_subnet.private-us-east-1b.id}", "${aws_subnet.private-us-east-1c.id}"]
  name = "${var.app_name}-searchLoadBalancer AutoScaling Group"
  max_size = "${var.searchLoadBalancer_instance_size.max_size}"
  min_size = "${var.searchLoadBalancer_instance_size.min_size}"
  health_check_grace_period = 300
  health_check_type = "EC2"
  desired_capacity = "${var.searchLoadBalancer_instance_size.desired_capacity}"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.es-config-searchLoadBalancer.name}"

  tag {
    key = "es_cluster"
    value = "searchLoadBalancer"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_group" "es-kibana" {
  availability_zones = ["us-east-1b"]
  vpc_zone_identifier = ["${aws_subnet.public-us-east-1b.id}"]
  name = "${var.app_name}-kibana AutoScaling Group"
  max_size = 1
  min_size = 1
  health_check_grace_period = 300
  health_check_type = "EC2"
  desired_capacity = 1
  force_delete = true
  launch_configuration = "${aws_launch_configuration.es-config-kibana.name}"

  tag {
    key = "es_cluster"
    value = "kibana"
    propagate_at_launch = true
  }
}
