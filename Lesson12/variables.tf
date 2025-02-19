variable "instance_type" {
  default = "t3.micro"
  type    = string
}
variable "allow_ports" {
  default = ["80", "443"]
  type    = list(any)
}
variable "enable_instance_monitoring" {
  default = false
  type    = bool
}
variable "default_tags" {
  type = map(any)
  default = {
    Owner     = "Van"
    CreatedBy = "Terraform"
  }
}
