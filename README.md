# Windows Habitat Workstation
This repo contains both a packer template to build a Windows workstation for Habitat Development, and terraform to launch the instances based off of that template for Habitat workshops.

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
 - Habitat
 - Git 
 - Google Chrome
 - Visual Studio Code
- Pulls the Windows Habitat studio from Docker hub
- Opens Windows Firewall rules for Habitat
- Initializes the instance
- SysPreps the instance

### Running a packer build
Should you need to update the ami, cd to `packer/aws` then run `packer build windows-2016.json`

Terraform has been configured to pull the latest ami published.

## Terraform
