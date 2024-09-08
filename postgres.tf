resource "aws_db_instance" "postgres" {
  engine                 = "postgres"
  engine_version         = "16.4"
  instance_class        = "db.t3.micro"
  db_name                = "mydb"
  username               = "myuser"
  password               = "mypassword"
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
  allocated_storage      = 10
  storage_type           = "gp2"
}

resource "aws_security_group" "postgres_sg" {
  name_prefix = "postgres-"
  vpc_id      = "vpc-0ab91873"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}