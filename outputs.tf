output "vpc_name" {
  description = "Nom du VPC créé"
  value       = module.infrastructure.vpc_name
}

output "vm_names" {
  description = "Noms des VMs créées"
  value       = module.infrastructure.vm_names
}

output "vm_ips" {
  description = "IPs externes des VMs"
  value       = module.infrastructure.vm_ips
}

output "storage_name" {
  description = "Nom du bucket storage"
  value       = module.infrastructure.storage_name
}

output "vm_count" {
  description = "Nombre de VMs créées"
  value       = module.infrastructure.vm_count
}
