provider "aws" {}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }
}

output "latest_aws_ami_ununtu_name" {
  value = data.aws_ami.latest_ubuntu.name
}
output "latest_aws_ami_ununtu_id" {
  value = data.aws_ami.latest_ubuntu.id
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t3.micro"
}
