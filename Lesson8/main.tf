provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "test_vpc" {
  tags = {
    "Name" = "test-vpc"
  }
}


resource "aws_subnet" "test_subnet_3" {
  vpc_id            = data.aws_vpc.test_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.0.6.0/24"
  tags = {
    "Name"    = "Subnet-3 in ${data.aws_availability_zones.working.names[0]}"
    "Account" = "Subnet in account ${data.aws_caller_identity.current.account_id}"
    "Region"  = data.aws_region.current.description
  }
}

output "data_availability_zones" {
  value = data.aws_availability_zones.working.names[1]
}
output "data_caller_id" {
  value = data.aws_caller_identity.current.account_id
}
output "data_aws_current_region" {
  value = data.aws_region.current.name
}
output "data_my_aws_vpcs_ids" {
  value = data.aws_vpcs.my_vpcs.ids
}

output "data_my_test_vpc_id" {
  value = data.aws_vpc.test_vpc.id
}
