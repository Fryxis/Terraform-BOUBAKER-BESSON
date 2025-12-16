locals {
  # Slug étudiant: minuscule, caractères autorisés, sans tirets en bord
  student_slug = trim(regexreplace(lower(var.student_name), "[^a-z0-9-]", "-"), "-")

  # Nommages conformes aux regex GCP
  vpc_name     = "vpc-${local.student_slug}-${var.environment}"
  subnet_name  = "subnet-${local.student_slug}-${var.environment}"
  vm_prefix    = "vm-${local.student_slug}-${var.environment}"
  storage_name = "storage-${local.student_slug}-${var.environment}"

  # Nombre de VMs fixe
  vm_count = 2

  # Tags
  common_tags = {
    environment = var.environment
    student     = var.student_name
    managed_by  = "terraform"
  }
}
