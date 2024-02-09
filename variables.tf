variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_az1_cidr" {
  default = "10.0.0.0/24"
}

variable "public_subnet_az2_cidr" {
  default = "10.0.1.0/24"
}

variable "private_app_subnet_az1_cidr" {
  default = "10.0.2.0/24"
}

variable "private_app_subnet_az2_cidr" {
  default = "10.0.3.0/24"
}

variable "private_data_subnet_az1_cidr" {
  default = "10.0.4.0/24"
}

variable "private_data_subnet_az2_cidr" {
  default = "10.0.5.0/24"
}

# security group variables

variable "ssh_location" {
  default = "0.0.0.0/0"
  description = "the IP address that can ssh into the EC2 instances"
  type = string
}

#rds variable

variable "database_snapshot_identifier" {
    default = "paste the fleetcart-final-snapshot under rds from aws console"
    description = "database snapshot arn"
    type = string
  
}

#variable for database instance

variable "database_instance_class" {
  default = "db.t2.micro"
  description = "database instance type"
  type = string
}

variable "database_instance_identifier" {
  default = "dev-rds-db"
  description = "database instance identifier"
  type = string
}

variable "multi_az_deployment" {
    default = false
    description = "create a standby db instance"
    type = bool
  
}

#application load balancer variables

variable "ssl_certificate_arn" {
  default = "arn:aws:acm:us-east-1:891377041422:certificate/8c5f3867-cd6c-4ee6-af46-eb03676e601f"
  description = "ssl certificate arn"
  type = string
}

variable "operator_email" {
  default = "monishapattanayak1@gmail.com"
  description = "a valid email address"
  type = string
}

#variable for auto scailing group

variable "launch_template_name" {
    default = "dev-launch-template"
    description = "name of the launch template"
    type = string
  
}

variable "EC2_image_id" {
  default = "ami-04f5097681773b989"
  description = "id of the ami"
  type = string
}

variable "EC2_instance" {
  default = "t2_micro"
  description = "ec2 instance type"
  type = string
}

variable "EC2_key_pair_name" {
  default = "assignment"
  description = "name of the ec2 keypair"
  type = string

}

#route 53 variables

variable "domain_name" {
  default = "example.com"
  description = "domain name"
  type = string
}

variable "record_name" {
  default = "test.example.com"
  description = "sub domain name"
  type = string
}