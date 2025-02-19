output "web_url" {
  value = aws_eip.my_static_ip.public_ip
}
