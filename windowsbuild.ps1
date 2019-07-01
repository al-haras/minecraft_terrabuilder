# Download Terraform
Invoke-WebRequest https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_windows_amd64.zip -OutFile C:\temp\terraform.zip

# Unzip Terraform to C:\Terraform
Expand-Archive -Path 'C:\temp\terraform.zip' -DestinationPath 'C:\Terraform'

# Remove .zip from C:\temp
Remove-Item -Path C:\temp\terraform.zip

# Add C:\Terraform to run terraform
$env:Path += ";C:\Terraform"

# Set variable $path to correct working directory
Set-Variable -Name "path" -Value (Get-Item -Path ".\").FullName

# SSH Keygen
ssh-keygen -f $path\minecraftkey -N '""'

# Terraform Initialize Directory
terraform init

# Plan Infra
terraform plan

# Apply
terraform apply -auto-approve

# Pause for Key Press to view Public DNS and IP
Pause
