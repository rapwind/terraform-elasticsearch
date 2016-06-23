resource "aws_elasticache_subnet_group" "suggest" {
  name = "cache-subnet"
  description = "Suggest Redis Cache Subnet Gruop"
  subnet_ids = ["${aws_subnet.private-us-east-1b.id}", "${aws_subnet.private-us-east-1c.id}"]
}
resource "aws_elasticache_cluster" "suggest" {
  cluster_id = "suggest-cluster"
  engine = "redis"
  node_type = "cache.t2.micro"
  port = 6379
  num_cache_nodes = 1
  parameter_group_name = "default.redis2.8"
  subnet_group_name = "${aws_elasticache_subnet_group.suggest.name}"
  security_group_ids = ["${aws_security_group.allow_all.id}"]
}
