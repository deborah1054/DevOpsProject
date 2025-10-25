output "vm_public_ip" {
  description = "The public IP address of the Virtual Machine."
  value       = azurerm_public_ip.pip.ip_address
}

output "ssh_command" {
  description = "Command to SSH into the VM."
  value = "ssh ${var.admin_username}@${azurerm_public_ip.pip.ip_address}"
}