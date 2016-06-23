output "ec2_describe_instances_aws_iam_access_key_id" {
  value = "${aws_iam_access_key.ec2_describe_instances.id}"
}
output "ec2_describe_instances_aws_iam_access_key_secret" {
  value = "${aws_iam_access_key.ec2_describe_instances.secret}"
}
output "security_group_1_id" {
  value = "${aws_security_group.allow_all.id}"
}
output "subnet_private_1_id" {
  value = "${aws_subnet.private-us-east-1b.id}"
}
output "subnet_private_2_id" {
  value = "${aws_subnet.private-us-east-1c.id}"
}
