resource "aws_instance" "my_web_server" {
  count                  = 2
  ami                    = "ami-09a9858973b288bdd"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_web_server_sg.id]
  user_data              = <<EOF
#!/bin/bash
apt -y update
apt -y install nginx
myip='curl http://169.254.169.254/latest/meta-data/'
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!" > /var/www/html/index.html
sudo systemctl start nginx
sudo systemctl  enable nginx
EOF

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
