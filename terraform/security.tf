resource "aws_security_group" "allow_ssh" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "hibicode_allow_ssh"
  description = "Security Group that allows ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_public_cidr}"]
  }

  tags {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_db_connection" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "hibicode_allow_db_connection"
  description = "Security Group that allows app network connect to database"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = ["${flatten(
      chunklist(aws_subnet.public_subnet.*.cidr_block, 1)
      )}"]
  }

  tags {
    Name = "allow_db_connection"
  }
}

resource "aws_security_group" "allow_outbound" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "hibicode_allow_outbound"
  description = "Security Group that allows instance connect to internet"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_outbound"
  }
}

resource "aws_security_group" "cluster_communication" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "hibicode_cluster_communication"
  description = "Allow Cluster Swarm traffic"

  ingress {
    from_port = 2377
    to_port   = 2377
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 7946
    to_port   = 7946
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 7946
    to_port   = 7946
    protocol  = "udp"
    self      = true
  }

  ingress {
    from_port = 4789
    to_port   = 4789
    protocol  = "udp"
    self      = true
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  tags {
    Name = "allow_cluster_communication"
  }
}

resource "aws_security_group" "allow_portainer_access" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "hibicode_allow_portainer_access"
  description = "Security Group that allows access to portainer"

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["${var.my_public_cidr}"]
  }

  tags {
    Name = "allow_portainer"
  }
}

resource "aws_security_group" "allow_load_balancer" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "hibicode_allow_load_balancer"
  description = "Security Group that allows load balancer communication"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${flatten(chunklist(aws_subnet.public_subnet.*.cidr_block, 1))}"]
  }

  tags {
    Name = "allow_load_balancer"
  }
}

resource "aws_security_group" "allow_app" {
  vpc_id      = "${aws_vpc.main.id}"
  name        = "hibicode_allow_app_access"
  description = "Security Group that allows access to app"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = 
      ["${flatten(chunklist(aws_subnet.public_subnet.*.cidr_block, 1))}"]
  }

  tags {
    Name = "allow_app"
  }
}
