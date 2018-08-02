module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "hibicode-rds"

  engine            = "postgres"
  engine_version    = "10.3"
  instance_class    = "db.t2.micro"
  allocated_storage = "100"

  name     = "beerstore"
  username = "beerstore"
  password = "${var.db_password}"
  port     = "5432"

  vpc_security_group_ids = ["${aws_security_group.allow_db_connection.id}"]

  maintenance_window = "Thu:03:30-Thu:05:30"
  backup_window      = "05:30-06:30"
  storage_type       = "gp2"
  multi_az           = "false"
  subnet_ids         = "${flatten(chunklist(aws_subnet.private_subnet.*.id, 1))}"

  family = "postgres10"

  tags = {
    Name = "hibicode_db"
  }
}
