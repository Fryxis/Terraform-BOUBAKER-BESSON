locals {
  # Slug étudiant: minuscule, remplacements simples, max 63 chars
  student_slug = substr(
    trim(
      replace(
        replace(
          replace(
            lower(var.student_name),
          " ", "-"),
        "_", "-"),
      ".", "-"),
    "-"),
    0,
  63)

  # Nommages conformes GCP
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