# Add C:\Terraform to run terraform
$env:Path += ";C:\Terraform"

# Set variable $path to correct working directory
Set-Variable -Name "path" -Value (Get-Item -Path ".\").FullName

#Remove AWS Infrastructure
terraform destroy -auto-approve

#Delete Files Off Host
Get-ChildItem $path -Filter terraform* | Remove-Item
Get-ChildItem $path -Filter minecraftkey* | Remove-Item
Remove-Item -Path $path\.terraform -Force -Recurse
Remove-Item -Path C:\Terraform -Force -Recurse

Pause