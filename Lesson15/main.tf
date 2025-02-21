provider "aws" {
  default_tags {
    tags = {
      Owner = "Van"
    }
  }
}

variable "env" {
  default = "dev"
}

variable "ec2_size" {
  default = {
    "prod" = "t3.micro"
    "dev"  = "t2.micro"
  }
}
variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "22", "8080"]
  }
}

resource "aws_instance" "my_prod_server" {
  count         = var.env == "prod" ? 1 : 0
  ami           = "ami-09a9858973b288bdd"
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size[var.env]
  tags = {
    Name = "${var.env}-server"
  }
}

resource "aws_instance" "my_dev_server" {
  count         = var.env == "dev" ? 1 : 0
  ami           = "ami-09a9858973b288bdd"
  instance_type = lookup(var.ec2_size, var.env)
  tags = {
    Name = "${var.env}-server"
  }
}


resource "aws_security_group" "my_web_server_sg" {
  name = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dynamic Security Group"
  }
}
