resource "aws_key_pair" "keypair" {
  key_name   = "hibicode"
  public_key = "${file("key/beer_key.pub")}"
}

resource "aws_instance" "instances" {
  count = 3

  ami           = "${var.aws_linux_ami}"
  instance_type = "${var.instance_type}"

  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"

  key_name = "${aws_key_pair.keypair.key_name}"

  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]

  tags = {
    Name = "hibicode_instances"
  }

  depends_on = ["aws_internet_gateway.igw"]
}

output "public_ip" {
  value = "${join(", ", aws_instance.instances.*.public_ip)}"
}
