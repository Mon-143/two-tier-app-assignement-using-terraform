##NAT Gateway creation

#elastic ip allocation to the nat gateway present in az1 public subnet

resource "aws_eip" "eip_for_nat_gateway_az1" {
   domain = "vpc"

   tags = {
    Name = "eip for nat ez1"
   }
}


resource "aws_eip" "eip_for_nat_gateway_az2" {
   domain = "vpc"

   tags = {
    Name = "eip for nat az2"
   }
}

#create nat gateway for public subnet az1

resource "aws_nat_gateway" "nat_gateway_az1" {
 allocation_id = aws_eip.eip_for_nat_gateway_az1.id
 subnet_id = aws_subnet.public_subnet_az1.id

 tags = {
   Name = "nat gateway az1"
 }

depends_on = [ aws_internet_gateway.internet_gateway ]
}


#create nat gateway for public subnet az2
resource "aws_nat_gateway" "nat_gateway_az2" {
 allocation_id = aws_eip.eip_for_nat_gateway_az2.id
 subnet_id = aws_subnet.public_subnet_az2.id

 tags = {
   Name = "nat gateway az2"
 }

depends_on = [ aws_internet_gateway.internet_gateway ]
}


#create a route table for private subnets in az1 and add route through nat gateway az1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id            = aws_vpc.vpc.id

  route = {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az1.id
  }

  tags = {
    Name = "private route table az1"

  }
}

resource "aws_route_table_association" "private_app_subnet_az1_route_table_az1_assosciation" {
    subnet_id = aws_subnet.private_app_subnet_az1.id
    route_table_id = aws_route_table.private_route_table_az1.id
  
}

resource "aws_route_table_association" "private_data_subnet_az1_route_table_az1_association" {
    subnet_id = aws_subnet.private_data_subnet_az1.id
    route_table_id = aws_route_table.private_route_table_az1.id
  
}

#create a route table for private subnets in az2 and add route through nat gateway az2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id            = aws_vpc.vpc.id

  route = {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az2.id
  }

  tags = {
    Name = "private route table az2"

  }
}

resource "aws_route_table_association" "private_app_subnet_az1_route_table_az1_assosciation" {
    subnet_id = aws_subnet.private_app_subnet_az2.id
    route_table_id = aws_route_table.private_route_table_az2.id
  
}

resource "aws_route_table_association" "private_data_subnet_az1_route_table_az1_association" {
    subnet_id = aws_subnet.private_data_subnet_az2.id
    route_table_id = aws_route_table.private_route_table_az2.id
  
}



