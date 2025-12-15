terraform {
  backend "gcs" {
    bucket = "terraform-state-boubaker-besson"
    prefix = "terraform/state"
  }
}
