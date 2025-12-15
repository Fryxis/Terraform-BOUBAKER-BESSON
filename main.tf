resource "google_compute_network" "vpc" {
	name                    = var.network_name
	auto_create_subnetworks = false
	description             = "VPC for lab infrastructure"
}

resource "google_compute_subnetwork" "subnet" {
	name          = var.subnet_name
	ip_cidr_range = var.subnet_cidr
	region        = var.gcp_region
	network       = google_compute_network.vpc.id
}

#resource "google_service_account" "vm" {
#	account_id   = var.instance_sa_name
#	display_name = "Terraform demo VM"
#}

resource "google_compute_address" "vm" {
	name   = "${var.instance_name}-ip"
	region = var.gcp_region
}

resource "google_compute_instance" "vm" {
	name         = var.instance_name
	machine_type = var.machine_type
	zone         = var.gcp_zone
	tags         = var.instance_tags

	boot_disk {
		initialize_params {
			image = var.instance_image
			size  = var.boot_disk_size_gb
		}
	}

	network_interface {
		subnetwork = google_compute_subnetwork.subnet.id

		access_config {
			nat_ip = google_compute_address.vm.address
		}
	}

	#service_account {
	#	email  = google_service_account.vm.email
	#	scopes = ["https://www.googleapis.com/auth/cloud-platform"]
	#}

	shielded_instance_config {
		enable_secure_boot          = true
		enable_vtpm                 = true
		enable_integrity_monitoring = true
	}
}

resource "random_id" "bucket_suffix" {
	byte_length = 4
}

resource "google_storage_bucket" "assets" {
	name                        = format("%s-%s", var.bucket_name_prefix, random_id.bucket_suffix.hex)
	location                    = var.gcs_location
	storage_class               = var.gcs_storage_class
	force_destroy               = false
	uniform_bucket_level_access = true

	versioning {
		enabled = true
	}
}

output "instance_public_ip" {
	value       = google_compute_address.vm.address
	description = "External IP for the VM"
}

output "bucket_name" {
	value       = google_storage_bucket.assets.name
	description = "Name of the storage bucket"
}
