provider "aws" {
  region = var.region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "minecraft"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-1a", "us-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.103.0/24"]

  public_subnet_tags = {
    Name = "minecraft-public"
  }

  private_subnet_tags = {
    Name = "minecraft-private"
  }

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform = "true"
    Name      = "minecraft"
  }
}

# Creation of Security Group to allow traffic on 25565 (Minecraft) and 22 (SSH, configured to your known public IP address).
# Alternatively, you can set to 0.0.0.0/0 or specifiy a range)
module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.0.1"

  name                = "minecraft"
  description         = "Set Traffic to allow 25565 (everywhere) and SSH from single public IP address"
  vpc_id              = module.vpc.vpc_id
  egress_rules        = ["all-all"]
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = [join("", [chomp(data.http.icanhazip.body), "/32"])]

  ingress_with_cidr_blocks = [
    {
      from_port   = 25565
      to_port     = 25565
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

# EIP creation and association with EC2 instance
resource "aws_eip" "default" {
  instance = aws_instance.default.id
  vpc      = true
}

resource "aws_instance" "default" {
  ami             = data.aws_ami.default.image_id
  instance_type   = "t2.medium"
  security_groups = [module.sg.this_security_group_id]
  user_data       = file("${path.module}/bootstrap.sh")
  key_name        = aws_key_pair.default.key_name
  subnet_id       = module.vpc.public_subnets[0]
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "default" {
  key_name   = "server"
  public_key = tls_private_key.default.public_key_openssh
}

resource "local_file" "ssh_private_key" {
  content  = tls_private_key.default.private_key_pem
  filename = "server.pem"
}

resource "null_resource" "chmod" {
  depends_on = [local_file.ssh_private_key]

  provisioner "local-exec" {
    command = format("chmod 600 %s", local_file.ssh_private_key.filename)
  }
}

data "http" "icanhazip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_ami" "default" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

output "minecraft_public_ip" {
  value = aws_eip.default.public_ip
}