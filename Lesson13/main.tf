provider "aws" {}

locals {
  full_project_name = "${var.environment}-${var.project_name}"
}

# resource "aws_eip" "my_static_ip" {
#   tags = {
#     Name    = "Static IP"
#     Owner   = var.owner
#     Project = local.full_project_name
#   }
# }


resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "ping -c 5 www.google.com >> ping.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command     = "print('Hello World!')"
    interpreter = ["python3", "-c"]
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command = "echo $NAME1 love $NAME2 >> names.txt"
    environment = {
      NAME1 = "Vasya"
      NAME2 = "Vika"
    }
  }
}

resource "aws_instance" "fast_server" {
  ami           = "ami-09a9858973b288bdd"
  instance_type = "t3.micro"
  provisioner "local-exec" {
    command = "echo Hello from aws instance"
  }
}

resource "null_resource" "command5" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(date) >> log.txt"
  }
  depends_on = [null_resource.command1, null_resource.command2, null_resource.command3, aws_instance.fast_server]
}
