# Access Key - AWS User "terraform"
variable "access_key" {
description = "AWS access key"
default = "Your Access Key"
}

# Secret Key - AWS User "terraform"
variable "secret_key" {
description = "AWS secret key"
default = "Your Secret Key"
}

# Define Region
variable "region" {
description = "AWS region you want the infrastructure to be created in"
default = "us-east-1"
}

# Private Key
variable "key_path_private" {
description = "Private SSH key"
default = "minecraftkey"
}

# Public Key
variable "key_path_public" {
description = "Public SSH key"
default = "minecraftkey.pub"
}

# Define VPC CIDR Range
variable "vpc_cidr" {
description = "CIDR range for VPC"
default = "10.0.0.0/16"
}

# Define Subnet CIDR
variable "public_subnet_cidr" {
description = "CIDR for Public Subnet"
default = "10.0.1.0/24"
}

# Define Gateway Route to internet
variable "vpc_gateway_route" {
description = "Gateway Route"
default = "0.0.0.0/0"
}

# Your Public IP address, used for locking down SSH to a single public IP address (which may be set to 0.0.0.0/0 if you don't want to limit this)
variable "ssh_lock" {
description = "Used to lock down ssh to single Public IP address"
default = "Your Public IP/32"
}

# AMI selection (Debian, however you can modify the bootstrap to use which ever distro you prefer)
variable "ami" {
description = "Base AMI to launch the instances"
default = "ami-0cac821e8b3cd5318"
}
