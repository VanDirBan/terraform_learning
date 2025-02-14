resource "aws_instance" "my_web_server" {
  count                  = 1
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_web_server_sg.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Van"
    names  = ["Vlad", "Igor", "Andre"]
  })
  user_data_replace_on_change = true

  tags = {
    Name    = "my_web_server"
    Owner   = "Van"
    Project = "Terraform lesson"
  }
}

resource "aws_security_group" "my_web_server_sg" {
  name        = "WebServer Security Group"
  description = "My first security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
