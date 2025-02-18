provider "aws" {}

data "aws_availability_zones" "avaiblible" {}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }
}

resource "aws_security_group" "web" {
  name = "My Security Group"

  dynamic "ingress" {
    for_each = ["80"]
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

resource "aws_launch_template" "as_lt" {
  name_prefix   = "web-server-lt-"
  image_id      = data.aws_ami.latest_ubuntu.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = filebase64("user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name  = "WebServer-instance"
      Owner = "Van"
    }
  }
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}



resource "aws_autoscaling_group" "web" {
  name = "ASG-${aws_launch_template.as_lt.latest_version}"
  # launch_configuration = aws_launch_configuration.as_conf.name
  launch_template {
    id      = aws_launch_template.as_lt.id
    version = "$Latest"
  }
  min_size            = 2
  max_size            = 4
  min_elb_capacity    = 2
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  health_check_type   = "ELB"
  load_balancers      = [aws_elb.web.name]

  # Dynamic tags
  dynamic "tag" {
    for_each = {
      Name  = "WebServer-in-ASG"
      Owner = "Van"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  # Manual tags
  #   tag {
  #     key                 = "Name"
  #     value               = "WebServer-in-ASG"
  #     propagate_at_launch = true
  #   }
  #   tag {
  #     key                 = "Owner"
  #     value               = "Van"
  #     propagate_at_launch = true
  #   }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"
  availability_zones = [data.aws_availability_zones.avaiblible.names[0], data.aws_availability_zones.avaiblible.names[1]]
  security_groups    = [aws_security_group.web.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "Web_server_Highly_Availible_ELB"
  }
}


resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.avaiblible.names[0]
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.avaiblible.names[1]
}

output "web_loadbalabcer_url" {
  value = aws_elb.web.dns_name
}
