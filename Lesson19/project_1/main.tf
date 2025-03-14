provider "aws" {
  region = "eu-north-1"
}


module "vpc-dev" {
  source = "../modules/aws_network"
}

module "vpc-prod" {
  source               = "../modules/aws_network"
  env                  = "prod"
  vpc_cidr             = "10.100.0.0/16"
  private_subnet_cidrs = ["10.100.1.0/24"]
  public_subnet_cidrs  = ["10.100.11.0/24"]
}


output "prod_public_subnet_ids" {
  value = module.vpc-prod.public_subnet_ids
}
