resource "google_service_account" "default" {
  account_id   = "service_account_id"
  display_name = "Service Account"
}

resource "google_compute_disk" "data" {
  env       = "{var.env}"
  zone      = "${var.zone}"
  name      = "${var.name}-data"
  size      = "${var.disk_size}"
  type      = "pd-ssd"
}


resource "google_compute_instance" "default" {
  name         = "${var.name}"
  machine_type = "${machine_type}"
  zone         = "${var.zone}"

  tags = ["env", "${var.env}"]

  boot_disk {
    auto_dlete = false
    initialize_params {
      size = "20G"
      image = "debian-cloud/debian-9"
    }
  }

  attached_disk {
    source      = "${google_compute_disk.data.*.self_link[count.index]}"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    env = ${.var.env}
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}