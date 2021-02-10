locals {
  region = "us-central1"
  env = "production"
  project = "PROJECT_NAME_HERE"
}

provider "google" {
  project = "${local.project}"
  region = "${local.region}"
  version = "~> 2.20"
}



module "machines" {
  source = "../modules/machines"
  env = "${local.env}"
  region = "${local.region}"
  zone = "us-central-1-a"
  name = "swvl"
  disk_size = "100G"
  machine_type = "n2-standard-48"
}

