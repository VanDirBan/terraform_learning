provider "aws" {
  default_tags {
    tags = {
      Owner = "Van"
    }
  }
}

variable "aws_users" {
  description = "List of IAM users to create"
  default     = ["Olya", "Vania", "Optimus", "Lesha", "Dima"]
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

output "created_iam_users" {
  value = aws_iam_user.users
}

output "created_iam_user_ids" {
  value = aws_iam_user.users[*].id
}

output "created_iam_users_custom" {
  value = [
    for user in aws_iam_user.users :
    "Username: ${user.id} has ARN: ${user.arn}"
  ]
}

output "created_iam_users_map" {
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id
  }
}

output "created_iam_user_short_names" {
  value = [
    for user in aws_iam_user.users :
    user.name
    if length(user.name) <= 4
  ]
}

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-09a9858973b288bdd"
  instance_type = "t3.micro"
  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}


