variable "gcp_project_id" {
	type        = string
	description = "ID du projet GCP cible"
}

variable "gcp_region" {
	type        = string
	description = "Region par defaut"
	default     = "europe-west1"
}

variable "gcp_zone" {
	type        = string
	description = "Zone par defaut"
	default     = "europe-west1-b"
}

variable "network_name" {
	type        = string
	description = "Nom du VPC"
	default     = "lab-vpc"
}

variable "subnet_name" {
	type        = string
	description = "Nom du sous-reseau"
	default     = "lab-subnet"
}

variable "subnet_cidr" {
	type        = string
	description = "Plage CIDR du sous-reseau"
	default     = "10.10.0.0/24"
}

variable "instance_name" {
	type        = string
	description = "Nom de l'instance VM"
	default     = "lab-vm"
}

variable "machine_type" {
	type        = string
	description = "Type de machine GCE"
	default     = "e2-micro"
}

variable "boot_disk_size_gb" {
	type        = number
	description = "Taille du disque de boot en Go"
	default     = 20
}

variable "instance_image" {
	type        = string
	description = "Image utilisee pour la VM"
	default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "instance_tags" {
	type        = list(string)
	description = "Tags reseau appliques a la VM"
	default     = ["http-server"]
}

#variable "instance_sa_name" {
#	type        = string
#	description = "Identifiant du service account pour la VM"
#	default     = "tf-lab-vm"
#}

variable "bucket_name_prefix" {
	type        = string
	description = "Prefixe du bucket GCS (suffixe aleatoire ajoute)"
	default     = "tf-lab-bucket"
}

variable "gcs_location" {
	type        = string
	description = "Localisation du bucket GCS"
	default     = "EU"
}

variable "gcs_storage_class" {
	type        = string
	description = "Classe de stockage du bucket"
	default     = "STANDARD"
}
