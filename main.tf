module "network" {
  source                      = "./terraform/modules/NETWORK"
  vpc_name                    = "Paula-MainVpc"
  vpc_cidr                    = "10.0.0.0/16"
  enable_dns_support          = true
  enable_dns_hostnames        = true
  subnets                     = var.subnets
  availability_zones          = "us-east-1a"
  auto_assign_public_ip_state = true
  cidr_from_anywhere          = "0.0.0.0/0"
  public_route_name           = "public-route"
  private_route_name          = "private-route"
  internet_gateway_name       = "paula-IGW"
  natgateway_name             = "paula-NGW"
  security_group_name         = "paula-SG"
  security_group_description  = "Allow HTTP traffic from anywhere"
  inport                      = ["80", "22", "3306", "9000", "3001"]
  in_protocol                 = "tcp"
  eg_port                     = 0
  eg_protocol                 = "-1"

}


module "load_balancer" {
  source                     = "./terraform/modules/LB"
  lb_name                    = "paulaLB"
  internal                   = false
  load_balancer_type         = "application"
  security_group_ids_LB      = [module.network.secgroup-id]
  subnet_ids_LB              = [module.network.public_subnet_id1, module.network.public_subnet_id2]
  enable_deletion_protection = false
  port                       = 80
  protocol                   = "HTTP"
  vpc_id                     = module.network.vpc_id
instance_ids                = module.ec2_instance.instance_ids
}

#----------------------- ------------------------------------#
module "ec2_instance" {
  source                      = "./terraform/modules/VMS"
  ec2_name                    = "paula_ansible-terraform"
  ec2_ami                     = "ami-04b70fa74e45c3917"
  ec2_type                    = "t3.micro"
  SG_id                       = [module.network.secgroup-id]
  ec2_subnet_ID               = module.network.public_subnet_id1
  associate_public_ip_address = true
  key_pair                    = "paula-key"
  instance_count              = 2
}


resource "null_resource" "ansible_inventory" {
  provisioner "local-exec" {
    command = "rm -f ansible/inventory* && echo '[webservers]' > ansible/inventory.yaml && echo '${module.ec2_instance.public_ips[0]}' >> ansible/inventory.yaml && echo '${module.ec2_instance.public_ips[1]}' >> ansible/inventory.yaml"
    working_dir = "${path.module}"
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [module.ec2_instance]
}



resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command     = "ansible-playbook -i inventory.yaml wordpress.yaml -e '@variables.yaml'"
    working_dir = "${path.module}/ansible"
  }
  
  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [null_resource.ansible_inventory,module.ec2_instance]
}




output "DNS_LINK" {
  value = module.load_balancer.lb_dns_name
}
