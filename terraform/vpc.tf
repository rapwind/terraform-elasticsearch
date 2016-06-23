#
# VPC resources
#
resource "aws_vpc" "es" {
  cidr_block = "10.0.0.0/16"

  # public
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "es" {
  vpc_id = "${aws_vpc.es.id}"
}

#
# Subnet
#

# Public us-east-1b
resource "aws_subnet" "public-us-east-1b" {
  vpc_id = "${aws_vpc.es.id}"
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags {
    Name = "Public Subnet us-east-1b"
  }
}
resource "aws_route_table" "public-us-east-1b" {
  vpc_id = "${aws_vpc.es.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.es.id}"
  }
  tags {
    Name = "public-us-east-1b"
  }
}
resource "aws_route_table_association" "public-us-east-1b" {
  subnet_id = "${aws_subnet.public-us-east-1b.id}"
  route_table_id = "${aws_route_table.public-us-east-1b.id}"
}
resource "aws_eip" "us-east-1b-nat" {
  vpc = true
}
resource "aws_nat_gateway" "us-east-1b" {
  allocation_id = "${aws_eip.us-east-1b-nat.id}"
  subnet_id = "${aws_subnet.public-us-east-1b.id}"
}

# Public us-east-1c
resource "aws_subnet" "public-us-east-1c" {
  vpc_id = "${aws_vpc.es.id}"
  cidr_block = "10.0.20.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags {
    Name = "Public Subnet us-east-1c"
  }
}
resource "aws_route_table" "public-us-east-1c" {
  vpc_id = "${aws_vpc.es.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.es.id}"
  }
  tags {
    Name = "public-us-east-1c"
  }
}
resource "aws_route_table_association" "public-us-east-1c" {
  subnet_id = "${aws_subnet.public-us-east-1c.id}"
  route_table_id = "${aws_route_table.public-us-east-1c.id}"
}
resource "aws_eip" "us-east-1c-nat" {
  vpc = true
}
resource "aws_nat_gateway" "us-east-1c" {
  allocation_id = "${aws_eip.us-east-1c-nat.id}"
  subnet_id = "${aws_subnet.public-us-east-1c.id}"
}

# Private us-east-1b
resource "aws_subnet" "private-us-east-1b" {
  vpc_id = "${aws_vpc.es.id}"
  cidr_block = "10.0.15.0/24"
  availability_zone = "us-east-1b"
  tags {
    Name = "Private Subnet us-east-1b"
  }
}
resource "aws_route_table" "private-us-east-1b" {
  vpc_id = "${aws_vpc.es.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.us-east-1b.id}"
  }
  tags {
    Name = "private-us-east-1b"
  }
}
resource "aws_route_table_association" "private-us-east-1b" {
  subnet_id = "${aws_subnet.private-us-east-1b.id}"
  route_table_id = "${aws_route_table.private-us-east-1b.id}"
}

# Private us-east-1c
resource "aws_subnet" "private-us-east-1c" {
  vpc_id = "${aws_vpc.es.id}"
  cidr_block = "10.0.25.0/24"
  availability_zone = "us-east-1c"
  tags {
    Name = "Private Subnet us-east-1c"
  }
}
resource "aws_route_table" "private-us-east-1c" {
  vpc_id = "${aws_vpc.es.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.us-east-1c.id}"
  }
  tags {
    Name = "private-us-east-1c"
  }
}
resource "aws_route_table_association" "private-us-east-1c" {
  subnet_id = "${aws_subnet.private-us-east-1c.id}"
  route_table_id = "${aws_route_table.private-us-east-1c.id}"
}

#
# Launch container instance
#
resource "aws_security_group" "allow_all" {
  name = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id = "${aws_vpc.es.id}"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_all"
  }
}
