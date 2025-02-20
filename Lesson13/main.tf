provider "aws" {}

locals {
  full_project_name = "${var.environment}-${var.project_name}"
}

resource "aws_eip" "my_static_ip" {
  tags = {
    Name    = "Static IP"
    Owner   = var.owner
    Project = local.full_project_name
  }
}
