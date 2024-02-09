#creating ALB security group
resource "aws_security_group" "alb_sg"{
  name        = "alb_sg"
  description = "enable http/https access on port 80/443"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description  = "HTTP to VPC"
    protocol      = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description  = "HTTPS to VPC"
    protocol      = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#creating SSH security group(Port 22 and Source Your IP Address)
resource "aws_security_group" "SSH_sg"{
  name        = "SSH_sg"
  description = "enable ssh access on port 22"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description  = "ssh access"
    protocol      = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = [var.ssh_location]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
#create Webserver Security Group(Port 80, 443 and Source ALB Security Group ,Port 22 and Source SSH Security Group)

resource "aws_security_group" "webserver_sg"{
  name        = "webserver_sg"
  description = "enable http/https access on port 80/443 via alb sg and access on port 22 via ssh sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description  = "HTTP access"
    protocol      = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = [aws_security_group.alb_sg]
  }

  ingress {
    description  = "HTTPS access"
    protocol      = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = [aws_security_group.alb_sg]
  }

    ingress {
    description  = "SSH access"
    protocol      = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = [aws_security_group.SSH_sg]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#create  database security group (port 3306)

resource "aws_security_group" "db_sg"{
  name        = "db_sg"
  description = "enable mysql/aurora access on port 3306 via webserver"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description  = "mysql/aurora access"
    protocol      = "tcp"
    from_port = 3306
    to_port   = 3306
    cidr_blocks = [aws_security_group.webserver_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}