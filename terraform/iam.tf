#
# ECS iam role and policies
#
resource "aws_iam_role" "ecs_iam_role" {
  name = "ecs_iam_role"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

#
# IAM profile to be used in auto-scaling launch configuration.
#
resource "aws_iam_instance_profile" "ecs_iam_role" {
  name = "ecs-iam-instance-profile"
  path = "/"
  roles = ["${aws_iam_role.ecs_iam_role.name}"]
}

#
# Create IAM role Policy
#
resource "aws_iam_role_policy" "ecs_iam_role" {
  name = "ecs_iam_role"
  role = "${aws_iam_role.ecs_iam_role.id}"
  policy = "${file("policies/ecs-role-policy.json")}"
}

#
# Create IAM user
#
resource "aws_iam_user" "ec2_describe_instances" {
  name = "ec2-describe-instances"
}

resource "aws_iam_access_key" "ec2_describe_instances" {
  user = "${aws_iam_user.ec2_describe_instances.name}"
}

resource "aws_iam_user_policy" "ec2_describe_instances_role" {
  name = "ec2-describe-instances-role"
  user = "${aws_iam_user.ec2_describe_instances.name}"
  policy = "${file("policies/ec2_describe-instances-role.json")}"
}
