output "public_ips" {
  value = aws_instance.public-ec2[*].public_ip
}

output "instance_ids" {
  value = aws_instance.public-ec2[*].id
}