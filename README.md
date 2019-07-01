# Minecraft_Terrabuilder

Minecraft_Terrabuilder provides an easy solution to build a vanilla Bukkit Minecraft server using Terraform and AWS.

## Tech

Minecraft_Terrabuilder uses a few pieces of software and AWS to build the server:

* [Terraform] - A tool used for building, changing, and versioning infrastructure - Version 0.12.3
* [AWS] - The world's most popular cloud infrastructure
* [Bukkit] - Reliable and secure Minecraft Server Mirror - Minecraft Server 1.4.3
* [Debian]

## Getting Started

#### Disclaimer

This builder will be building an EC2 instance that is not within the "free-tier." The resources needed are more than a t2.micro will allow for. You will be charged accordingly (it is a relatively small amount). I will not be responsible for any fees.

I will also try to keep this as current as possible when new Terraform and Minecraft versions are released.

#### Preparing

Before starting, this will require you to have a AWS account. It is recommended that you create a user separate from your own that will be only used for provisioning. That account will ideally have administrator permissions and console access disabled. You will need to save the Access Key ID and Secret Key ID for the variable section.


Minecraft_Terrabuilder requires git to clone the repository and will install Terraform on the host you will be running from.

```
$ git clone https://github.com/al-haras/minecraft_terrabuilder
```

Using your text editor of choice, you will want to modify the bootstrap.sh to include your desired password for the EC2 instance. SSH using username/password and root logins will be disabled by default and if you configure it as designed will only be accessible from a single IP address, however it is recommended to change it anyways.

You will also need to provide some variables in vars.tf:

- Access Key ID
- Secret Key ID
- Your Public IP address
- Region
- AMI

To get the AMI you want, [https://wiki.debian.org/Cloud/AmazonEC2Image/Stretch] will provide you with the correct AMI for your region. Please be sure to select the AMD64 option rather than ARM64.

There is a variable in vars.tf "ssh_lock" which is intended to allow you to only allow SSH access from your Public IP address. This requires you to add your Public IP address/32 (Example - 8.8.4.4/32). You can find it a number of different ways but ```curl https://ipinfo.io/ip``` will display it in a terminal for you. Alternatively, you can use 0.0.0.0/0, but it would open up your VPC to allow anyone to try to connect via SSH which is not recommended.

#### Linux

This project is designed to be run specifically on Debian however feel free to modify the scripts to fit whatever your preferred distro is. Assuming you have correctly entered your variables you should be ready to start.

```
$ cd /minecraft_terrabuilder
```

```
$ ./buildserver.sh
```

This will start the install of Terraform which will provision your AWS infrastructure and pass the bootstrap.sh to your EC2 instance to provision the server.

I have also added a buildserverarm.sh which can be used to run Terraform from something like a RaspberryPi.

```
$ ./buildserverarm.sh
```

#### Windows

For people on Windows, this also contains a PowerShell script that will also install Terraform. It works the same as the Linux version and will provision your AWS infrastructure and pass the bootstrap to your EC2 instance to setup the server. You will need to have ssh-keygen installed on your PC as well as being logged into an account that is in the Local Administrator group (or have an Administrator run the windowsbuild.ps1)

```
cd /minecraft_terrabuilder
```

```
./buildserverwindows.ps1
```

Alternatively, you can browse to the cloned repository and right click to run in PowerShell.

## Post-Terraform

After Terraform has applied your infrastructure to AWS, it may take some time for the server to build. It does take anywhere from 5-15 minutes. You can SSH to the server to check its progress.

```
ssh -i minecraftkey admin@yourPublicDNSName(or yourPublicIPAddress)
```

If you are missing the directory /home/admin/server check /var/log/cloud-init-output to see if the server build is complete.

## Connecting to Server
When the server is complete, all you need to do is connect to either the Public DNS name or the Public IP address from Minecraft.

The Public DNS and IP is included in the outputs for Terraform. Alternatively, you can access them via the AWS Console

## Stopping Server/VPC and Removal

#### Linux 

To stop remove all AWS resources, you can either run the following:
```./destroy.sh``` or ```terraform destroy -auto-approve```. This method will keep your minecraft ssh keys, and .tfstate files.

If you want to remove everything from the  system, you can run ```./destroyall.sh```. This will stop Terraform and remove AWS resources, as well as remove Terraform from /usr/local/bin, delete ssh keys, and .tfstate files.

#### Windows 
To stop remove all AWS resources run the windowsremove.ps1 script. This will act essentially the same as the destroyall.sh which removes the resources from AWS, as well as deleting ssh keys, and .tfstate. 


[Terraform]: <https://www.terraform.io/>
[AWS]: <https://aws.amazon.com/>
[Debian]: <https://www.debian.org/>
[Bukkit]: <https://getbukkit.org/>
[https://wiki.debian.org/Cloud/AmazonEC2Image/Stretch]: <https://wiki.debian.org/Cloud/AmazonEC2Image/Stretch>
