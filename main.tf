module "infrastructure" {
  source = "./modules/infrastructure"

  ssh_public_key = var.ssh_public_key
  environment    = var.environment
  student_name   = var.student_name
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone
  machine_type   = var.machine_type
  subnet_cidr    = var.subnet_cidr
  vm_ips         = var.vm_ips
}