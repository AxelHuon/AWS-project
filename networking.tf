resource "aws_vpc" "default" {
  cidr_block = var.VPC_CIDR
  tags = {
    Name = "${var.BASE_NAME}-VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.PUBLIC_SUBNET_CIDR
  tags = {
    Name = "${var.BASE_NAME}-subnet-public"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = var.BASE_NAME
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
  tags = {
    Name = "${var.BASE_NAME}-route-table-public"
  }
}


resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
