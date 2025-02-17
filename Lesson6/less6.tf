# Create Elasctic IP and add some tags
resource "aws_eip" "my_static_ip" {
  tags = {
    "key" = "test_static_ip"
  }
}

# Associate Elastic IP to our instance
resource "aws_eip_association" "my_eip_association" {
  instance_id   = aws_instance.my_web_server[0].id
  allocation_id = aws_eip.my_static_ip.id
}

# Create our instance with WebServer
resource "aws_instance" "my_web_server" {
  count                  = 1
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_web_server_sg.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Van"
    names  = ["Vlad", "Igor", "Andre", "Sofia"]
  })
  user_data_replace_on_change = true

  tags = {
    Name    = "my_web_server"
    Owner   = "Van"
    Project = "Terraform lesson"
  }

  # Prevent from destroy server
  #   lifecycle {
  #     prevent_destroy = true
  #   }

  # Prevent from change sensitive data
  #   lifecycle {
  #     ignore_changes = [ami, user_data]
  #   }

  # Create new instance before destroy old to prevent DownTime WebServer
  lifecycle {
    create_before_destroy = true
  }
}




resource "aws_security_group" "my_web_server_sg" {
  name = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "9092"]
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
    Name  = "Dynamic Security Group"
    Onwer = "Van"
  }
}
