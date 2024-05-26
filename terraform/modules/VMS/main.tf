resource "aws_instance" "public-ec2" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_type
  vpc_security_group_ids      = var.SG_id
  subnet_id                   = var.ec2_subnet_ID
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_pair
  # user_data                   = var.user_data
  count = var.instance_count
  tags = {
    Name = var.ec2_name
  }


}

resource "aws_key_pair" "my_key_pair" {
  key_name   = var.key_pair
  public_key = file("~/.ssh/id_rsa.pub") 
}

