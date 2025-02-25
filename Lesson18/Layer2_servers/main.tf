provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket = "van-project-terraform-state"
    key    = "dev/servers/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "van-project-terraform-state"
    key    = "dev/network/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }
}

# ----------------------------------------------------

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_server.id]
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  user_data              = filebase64("${path.module}/user_data.sh")
  tags = {
    Name = "WebServer"
  }
}


resource "aws_security_group" "web_server" {
  name   = "WebServer Securirt Group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}

output "web-server-sg_id" {
  value = aws_security_group.web_server.id
}

output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}
