provider "aws" {
  region = "eu-north-1"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "EU-WEST"
}

provider "aws" {
  region = "us-east-1"
  alias  = "USA"
}

data "aws_ami" "usa_latest_ubuntu" {
  provider    = aws.USA
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }
}

data "aws_ami" "eu_west_latest_ubuntu" {
  provider    = aws.EU-WEST
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }
}

resource "aws_instance" "north_server" {
  instance_type = "t3.micro"
  ami           = "ami-09a9858973b288bdd"
  tags = {
    Name = "North server"
  }
}

resource "aws_instance" "EU-WEST_server" {
  provider      = aws.EU-WEST
  instance_type = "t3.micro"
  ami           = data.aws_ami.eu_west_latest_ubuntu.id
  tags = {
    Name = "EU-WEST server"
  }
}

resource "aws_instance" "usa_server" {
  provider      = aws.USA
  instance_type = "t3.micro"
  ami           = data.aws_ami.usa_latest_ubuntu.id
  tags = {
    Name = "USA server"
  }
}
