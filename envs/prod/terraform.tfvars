environment    = "prod"
student_name   = "lenny"
gcp_project_id = "terraform-cours-481313"
gcp_region     = "europe-west1"
gcp_zone       = "europe-west1-b"
machine_type   = "e2-micro"
subnet_cidr    = "10.1.0.0/24"

# Liste des IPs pour les VMs
vm_ips = [
  "35.195.200.10",
  "35.195.200.11"
]
