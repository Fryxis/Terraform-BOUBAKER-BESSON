terraform {
  backend "gcs" {
    bucket = "terraform-state-boubaker-besson"
    # Prefix par défaut (dev) – surchargé à l'init avec -backend-config="prefix=dev/terraform/state" ou prod
    prefix = "dev/terraform/state"
  }
}
