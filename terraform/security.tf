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
