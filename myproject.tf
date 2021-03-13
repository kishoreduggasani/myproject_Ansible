# Configure the AWS Provider
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "credentials"
  profile                 = "terraform"
}

#vpc
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name = "myproject"
  }

}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "myproject-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.5.0/24"

  tags = {
    Name = "myproject-private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "myproject-igw"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "ibm-public-route"
  }
}
resource "aws_route_table_association" "pub-asc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rtb.id
}

#security group ssh
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "sonar from anywhere"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "sonar from anywhere"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
  ingress {
    description = "jenkins from 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
# launch instance for jenkins master
resource "aws_instance" "jen-m" {
  key_name               = "devapps"
  ami                    = "ami-05f51b3cc9eb95f49"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  private_ip             = "10.0.1.50"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  user_data              = file("install.sh")
  tags = {
    Name = "jenkins-m"
  }
}
# launch instance for jenkins slave
resource "aws_instance" "jen-s" {
  key_name               = "devapps"
  ami                    = "ami-0affd4508a5d2481b"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  private_ip             = "10.0.1.51"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "jenkins-s"
  }
}
# launch instance for tomcat
resource "aws_instance" "tomcat" {
  key_name               = "devapps"
  ami                    = "ami-0affd4508a5d2481b"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  private_ip             = "10.0.1.52"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "tomcat"
  }
}
# launch instance for sonar
resource "aws_instance" "sonar" {
  key_name               = "devapps"
  ami                    = "ami-0affd4508a5d2481b"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  private_ip             = "10.0.1.53"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "sonar"
  }
}
# launch instance for nexus 
resource "aws_instance" "nexus" {
  key_name               = "devapps"
  ami                    = "ami-0affd4508a5d2481b"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  private_ip             = "10.0.1.54"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "nexus"
  }

}
# launch instance for  ansible
resource "aws_instance" "ansible" {
  key_name               = "devapps"
  ami                    = "ami-0affd4508a5d2481b"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  private_ip             = "10.0.1.55"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "ansible"
  }

}
# launch instance for docker  
resource "aws_instance" "docker" {
  key_name               = "devapps"
  ami                    = "ami-0affd4508a5d2481b"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  private_ip             = "10.0.1.56"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "docker"
  }
}

