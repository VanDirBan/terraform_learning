output "WebServer_instance_id" {
  value = aws_instance.my_web_server[0].id
}

output "WebServer_publick_ip" {
  value       = aws_eip.my_static_ip.public_ip
  description = "This is public Elastic IP"
}
