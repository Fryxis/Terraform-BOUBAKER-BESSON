variable "environment" {
  type        = string
  description = "Environnement (dev ou prod)"
}

variable "student_name" {
  type        = string
  description = "Nom de l'étudiant"
}

variable "gcp_project_id" {
  type        = string
  description = "ID du projet GCP"
}

variable "gcp_region" {
  type        = string
  description = "Région GCP"
  default     = "europe-west1"
}

variable "gcp_zone" {
  type        = string
  description = "Zone GCP"
  default     = "europe-west1-b"
}

variable "machine_type" {
  type        = string
  description = "Type de machine"
  default     = "e2-micro"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR du subnet"
  default     = "10.0.0.0/24"
}

variable "vm_ips" {
  type        = list(string)
  description = "Liste des IPs externes pour les VMs"
}

variable "ssh_public_key" {
  type        = string
  description = "Clé publique SSH pour l'accès Ansible"
}
