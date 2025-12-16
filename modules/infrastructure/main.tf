# VPC
resource "google_compute_network" "vpc" {
  name                    = local.vpc_name
  auto_create_subnetworks = false
  description             = "VPC pour ${var.environment}"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = local.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.gcp_region
  network       = google_compute_network.vpc.id
}

# Règle firewall SSH
resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh-${var.environment}"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# IPs statiques (map index -> IP pour garantir l'ordre)
resource "google_compute_address" "vm_ips" {
  for_each = { for idx, ip in var.vm_ips : tostring(idx) => ip }

  name    = "ip-${local.vm_prefix}-${tonumber(each.key) + 1}"
  region  = var.gcp_region
  address = each.value
}

# VMs (count = 2 VMs)
resource "google_compute_instance" "vms" {
  count = local.vm_count

  name         = "${local.vm_prefix}-${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      nat_ip = google_compute_address.vm_ips[tostring(count.index)].address
    }
  }

  # Bouclier VM GCP
  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}

# Stockage 
resource "google_storage_bucket" "storage" {
  name          = local.storage_name
  location      = var.gcp_region
  force_destroy = true

  uniform_bucket_level_access = true
}
