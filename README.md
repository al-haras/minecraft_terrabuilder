# Minecraft_Terrabuilder

Minecraft_Terrabuilder provides an easy solution to deploy a vanilla Minecraft server using Terraform to deploy into AWS.

## Getting Started

#### Disclaimer

This builder will be provisioning an EC2 instance that is not within the "free-tier." The resources required to run this server are more than a t2.micro will allow for. You will be charged accordingly (it is a relatively small amount). I will not be responsible for any fees.

I will also try to keep this as current as possible when new Terraform and Minecraft versions are released.

#### Preparing

Before starting, this will require you to have a AWS account. It is recommended that you create a user separate from your own that will be only used for provisioning. That account will ideally have administrator permissions and console access disabled.

You will need to configure your shell session to export your AWS Access Key and Secret or pass environment variables to the terraform command.

Minecraft_Terrabuilder requires git to clone the repository and will install Terraform on the host you will be running from.

```
$ git clone https://github.com/al-haras/minecraft_terrabuilder
```

You will also need to provide the AWS region in vars.tf.

#### Linux

This project is designed to be run specifically on Ubuntu. Feel free to modify the scripts to fit whatever your preferred distro is.

Assuming you have correctly entered your variables you should be ready to start.

```bash
terraform init && terraform apply
```

## Post-Terraform

After Terraform has applied your infrastructure to AWS, you can SSH to the server using the following command:

```bash
ssh -i your_ssh_key <ec2_instance_public_ip> -l ubuntu
```

```/var/log/cloud-init-output``` to see if the server build is complete.

## Connecting to Server
When the server is complete, all you need to do is connect to either the Public DNS name or the Public IP address from Minecraft.

The Public DNS and IP is included in the outputs for Terraform. Alternatively, you can access them via the AWS Console

## Cleanup

#### Linux

To stop remove all AWS resources, you can either run the following:

```bash
terraform destroy -auto-approve
```
