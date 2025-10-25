variable "location" {
  description = "The Azure region to deploy resources in."
  type        = string
  default = "Central India"
}

variable "admin_username" {
  description = "Administrator username for the VM."
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_key_path" {
  description = "Path to the public SSH key for VM authentication."
  type        = string
  default     = "C:/Users/flora/.ssh/id_rsa.pub"
}
