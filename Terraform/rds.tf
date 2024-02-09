resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db subnets"
  subnet_ids = [aws_subnet.private_data_subnet_az1.id, aws_subnet.private_data_subnet_az2.id]

  tags = {
    Name = "My DB subnet group"
  }
}


data "aws_db_snapshot" "latest_db_snapshot" {
  db_snapshot_identifier = var.database_snapshot_identifier
  most_recent            = true
  snapshot_type = "manual"
}

resource "aws_db_instance" "db_instance" {
  instance_class       = var.database_instance_class
  skip_final_snapshot  = true
  availability_zone = "us-east-1b"
  identifier = var.database_instance_identifier
  snapshot_identifier = data.aws_db_snapshot.latest_db_snapshot.id
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  multi_az = var.multi_az_deployment
  vpc_security_group_ids = [aws_db_subnet_group.db_subnet_group.id]
}