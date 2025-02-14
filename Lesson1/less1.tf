resource "aws_instance" "terra_ubuntu" {
  count         = 2
  ami           = "ami-09a9858973b288bdd"
  instance_type = "t3.micro"
  tags = {
    Name    = "terra_ubutu"
    Owner   = "Van"
    Project = "Terraform lesson"
  }
}
