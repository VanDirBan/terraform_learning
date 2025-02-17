# Create our instance with WebServer
resource "aws_instance" "my_server_web" {
  count                  = 1
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_web_server_sg.id]
  # wait until my_server_db is up
  depends_on = [aws_instance.my_server_db]

  tags = {
    Name    = "Server_Web"
    Owner   = "Van"
    Project = "Terraform lesson"
  }

}

resource "aws_instance" "my_server_db" {
  count                  = 1
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_web_server_sg.id]

  tags = {
    Name = "Server_DataBase"
  }

}




resource "aws_security_group" "my_web_server_sg" {
  name = "My Security Group"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
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
    Name  = "My Security Group"
    Onwer = "Van"
  }
}
