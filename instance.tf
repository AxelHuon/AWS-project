/*
** Create security group
*/
resource "aws_security_group" "security_group_1" {
  name        = "IIM-sg-1"
  description = "IIM-sg-1"
  vpc_id      = aws_vpc.default.id

  // Allow inbound traffic for SSH
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow SSH"
  }
  // Allow inbound traffic for HTTP
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow HTTP"
  }

  // Allow inbound traffic for HTTPS
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*
** Create an EC2 instance
*/
resource "aws_instance" "IIM-ec2" {
  ami = "ami-0f960c8194f5d8df5"
  instance_type = "t3.micro"
  tags = {
    Name = "${var.BASE_NAME}-public"
  }
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [
    aws_security_group.security_group_1.id
  ]
  associate_public_ip_address = true
}





/*
** Create security group
*/
resource "aws_security_group" "private_security_group_1" {
  name        = "IIM-private-sg-1"
  description = "IIM-private-sg-1"
  vpc_id      = aws_vpc.default.id

  // Allow inbound traffic for SSH
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow SSH"
  }
  // Allow inbound traffic for HTTP
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow HTTP"
  }

  // Allow inbound traffic for HTTPS
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*
** Create an EC2 instance
*/
resource "aws_instance" "IIM-private-ec2" {
  ami = "ami-0f960c8194f5d8df5"
  instance_type = "t3.micro"
  tags = {
    Name = "${var.BASE_NAME}-private"
  }
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [
    aws_security_group.private_security_group_1.id
  ]
  associate_public_ip_address = false
}



resource "aws_instance" "IIM-ec2-project-node" {
  ami = "ami-0f960c8194f5d8df5"
  instance_type = "t3.micro"
  tags = {
    Name = "${var.BASE_NAME}-public-project-node"
  }
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [
    aws_security_group.security_group_1.id
  ]
  associate_public_ip_address = true
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install git -y
    sudo yum install docker -y
    sudo rm -f /etc/docker/daemon.json
    sudo systemctl start docker
    sudo usermod -a -G docker ec2-user
    sudo chkconfig docker on
    sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
    sudo chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    su - ec2-user -c "git clone https://github.com/AxelHuon/project-node /home/ec2-user/project-node"
    su - ec2-user -c "cd /home/ec2-user/project-node && docker-compose up --build"
  EOF
}