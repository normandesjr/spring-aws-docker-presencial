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

  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"
  , "${aws_security_group.allow_outbound.id}"
  , "${aws_security_group.cluster_communication.id}"
  , "${aws_security_group.allow_portainer_access.id}"
  , "${aws_security_group.allow_app.id}"]

  tags = {
    Name = "hibicode_instances"
  }

  depends_on = ["aws_internet_gateway.igw"]
}

output "public_ip" {
  value = "${join(", ", aws_instance.instances.*.public_ip)}"
}

data "template_file" "hosts" {
  template = "${file("./template/hosts.tpl")}"

  vars {
    PUBLIC_IP_0 = "${aws_instance.instances.*.public_ip[0]}"
    PUBLIC_IP_1 = "${aws_instance.instances.*.public_ip[1]}"
    PUBLIC_IP_2 = "${aws_instance.instances.*.public_ip[2]}"

    PRIVATE_IP_0 = "${aws_instance.instances.*.private_ip[0]}"
  }
}

resource "local_file" "hosts" {
  content  = "${data.template_file.hosts.rendered}"
  filename = "./template/hosts"
}