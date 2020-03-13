////////////////////////////////
// Azure Connection

variable "azure_region" {
  default = "West US"
  description = "The Azure region where we will build resources and instances"
}

variable "azure_sub_id" {
  default = "xxxxxxx-xxxx-xxxx-xxxxxxxxxx"
  description = "The Azure subscription ID for your account"
}

variable "azure_tenant_id" {
  default = "xxxxxxx-xxxx-xxxx-xxxxxxxxxx"
  description = "Azure tenant ID for your tenant"
}

variable "azure_client_id" {
  default = "xxxxxxx-xxxx-xxxx-xxxxxxxxxx"
  description = "Azure client ID for your client"
}

variable "azure_client_secret" {
  default = "xxxxxxx-xxxx-xxxx-xxxxxxxxxx"
  description = "Azure client secret for your client"
}

variable "azure_public_key_path" {
  default = "/path/to/ssh/key"
  description = "Public key for SSH configuration to instances"
}

variable "azure_private_key_path" {
  default = "/path/to/ssh/key"
  description = "Private key that corresponds to azure_public_key_path"
}

////////////////////////////////
// Required Tags

variable "tag_customer" {
  description = "tag_customer is the customer tag which will be added to AWS"
}

variable "tag_project" {
  description = "tag_project is the project tag which will be added to AWS"
}

variable "tag_dept" {
  description = "tag_dept is the department tag which will be added to AWS"
}

variable "tag_contact" {
  description = "tag_contact is the contact tag which will be added to AWS"
}

variable "tag_application" {
  default = "HabManagedAzure"
  description = "tag_application is the application tag which will be added to AWS"
}

variable "tag_ttl" {
  default = 4
  description = "Time, in hours, the environment should be allowed to live"
}

////////////////////////////////
// OS Variables

variable "azure_image_user" {
  default = "azureuser"
  description = "Usernamem to login to instances"
}

variable "azure_image_password" {
  default = "Azur3pa$$word"
  description = "Password for azurerm_image_user"
}

variable "origin" {
  default = ""
  description = "Habitat package origin"
}


////////////////////////////////
// Chef Automate

variable "channel" {
  default="current"
  description = "channel is the habitat channel which will be used for installing A2"
}

variable "automate_license" {
  default = "Contact Chef Sales at sales@chef.io to request a license."
  description = "automate_license is the license key for your A2 installation"
}

variable "automate_hostname" {
  description = "automate_hostname is the hostname which will be given to your A2 instance.  Must be DNS-compliant."
}

variable "automate_app_gateway_dns_zone" {
  default = "azure.chef-demo.com"
  description = "Matcher to find the Azure DNS zone"
}

variable "acme_provider_url" {
  default = "https://acme-staging-v02.api.letsencrypt.org/directory"
  description = <<EOF
An API endpoint URL for an ACME-compliant CA.  We default to LetsEncrypt staging endpoint.
This will issue certs, but the certs will not be valid.

For valid certs from LetsEncrypt, use https://acme-v02.api.letsencrypt.org/directory
EOF
}

variable "automate_custom_ssl" {
  default = "false"
  description = "Enable to configure automate with the below certificate"
}

variable "automate_custom_ssl_private_key" {
  default="Paste private key here"
  description = "automate_private_key is the SSL private key that will be used to congfigure HTTPS for A2"
}

variable "automate_custom_ssl_cert_chain" {
  default="Paste certificate chain here"
  description = "automate_cert_chain is the SSL certificate chain that will be used to congfigure HTTPS for A2"
}

variable "automate_server_instance_type" {
 default = "Standard_D4s_v3"
 description = "automate_server_instance_type is the AWS instance type to be used for A2"
}
