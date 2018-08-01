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
