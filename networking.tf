#Create VPC 
resource "aws_vpc" "hofVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "hofVPC"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.hofVPC.id

  tags = {
    Name = "main"
  }
}

#Create Subnets
resource "aws_subnet" "publicSubnet" {
  vpc_id            = aws_vpc.hofVPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet 1"
  }
}

#Create Route Table
resource "aws_route_table" "routeTable" {
  vpc_id = aws_vpc.hofVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "hofRoute Table"
  }
}


#Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.publicSubnet.id
  route_table_id = aws_route_table.routeTable.id
}


#Create network interface for private IP of EC2
resource "aws_network_interface" "eni" {
  subnet_id       = aws_subnet.publicSubnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.eni.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [
    aws_internet_gateway.gw
  ]
}
