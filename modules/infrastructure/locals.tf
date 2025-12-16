locals {
  # Stockage nom en minuscules
  storage_name = lower("STORAGE-${var.student_name}-${var.environment}")
  
  # Nombre de VMs fixe
  vm_count = 2
  
  # Tags
  common_tags = {
    environment = var.environment
    student     = var.student_name
    managed_by  = "terraform"
  }
}