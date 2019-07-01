provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

# VPC creation
resource "aws_vpc" "minecraft_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Define Subnet to be used in your VPC
resource "aws_subnet" "main" {
  vpc_id = "${aws_vpc.minecraft_vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"
  map_public_ip_on_launch = true
}

# Create IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.minecraft_vpc.id}"
}

# Create Route Table for VPC
resource "aws_route_table" "route" {
  vpc_id = "${aws_vpc.minecraft_vpc.id}"
  route {
    cidr_block = "${var.vpc_gateway_route}"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

# Route Table Association
resource "aws_route_table_association" "route" {
  subnet_id = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.route.id}"
}

# Creation of Security Group to allow traffic on 25565 (Minecraft) and 22 (SSH, configured to your known public IP address. Alternatively, you can set to 0.0.0.0/0 or specifiy a range)
resource "aws_security_group" "minecraft_sg" {
  vpc_id = "${aws_vpc.minecraft_vpc.id}"
  name = "minecraft_sg"
  description = "Set Traffic to allow 25565 (everywhere) and SSH from single public IP address"
  ingress {
    from_port = 25565
    to_port = 25565
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.ssh_lock}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Keypair
resource "aws_key_pair" "minecraftpublickey" {
  key_name = "minecraftpublickey"
  public_key = "${file("${var.key_path_public}")}"
}

# EC2 Instance Creation
resource "aws_instance" "minecraft" {
  ami = "${var.ami}"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.minecraft_sg.id}"]
  user_data = "${file("bootstrap.sh")}"
  key_name = "minecraftpublickey"
  depends_on = ["aws_internet_gateway.gw"]
  subnet_id = "${aws_subnet.main.id}"  
}

# EIP creation and association with EC2 instance
resource "aws_eip" "eip" {
  instance = "${aws_instance.minecraft.id}"
  vpc = true
}

# Outputs for what to connect to. 
output	"public_ip" {
  value = aws_eip.eip.public_ip
}

output "public_dns" {
  value = aws_eip.eip.public_dns
}
