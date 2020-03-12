# Windows Habitat Workstation
This repo contains both a packer template to build a Windows workstation for Habitat Development, and terraform to launch the instances based off of that template for Windows Habitat workshops. There is also a repo for building Linux workstations and that can be found here:

https://github.com/chef-cft/habitat_workstation

## Prereqs
In order to run this you will need the following:

- AWS API keys
- Packer
- Terraform

## Packer Template
The included Packer template pulls the latest Windows 2016 Server with Containers image for the base tempate. The Habitat training materials rely on Docker for the Windows Habitat studio, and for running multiple applications packaged by Habitat on the same box.

### Installed Applications
Once an instance is provisioned, Packer will perform the followin configurations:

- Run the `templates/windows_bootstrap.txt` that sets up WinRM and create a local `hab` user with a password of `ch3fh@b1!` then adds that user to the `Administrators` group
- Installs Software
  - Chocolatey
  - Git 
  - Google Chrome
  - Visual Studio Code
- Pulls the Windows Habitat studio from Docker hub
- Opens Windows Firewall rules for Habitat
- Initializes the instance
- SysPreps the instance

The image does not install Habitat intentionally because installing it is part of the workshop

### Running a packer build
Should you need to update the ami, cd to `packer/aws` then run `packer build windows-2016.json`

NOTE: this AMI is very large and takes a long time to finish copying. You will likely need to set environment variables for `AWS_MAX_ATTEMPTS=60` and `AWS_POLL_DELAY_SECONDS=60` to allow the AMI copy to finish. With this packer will check every minute for one hour

## Terraform
The terraform will create a VPC, subnet, security groups, and then launch `n` number of workstations. The output will give you the public ips of the instances to distribute to students.

## Usage
`cd terraform/aws`    
create a `terraform.tfvars` you can use `example.tfvars` as an example   
`terraform apply`
