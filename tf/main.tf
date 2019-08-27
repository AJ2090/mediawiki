data "google_compute_subnetwork" "default" {
  name   = "default"
  region = "${var.region}"
}

resource "google_compute_instance" "kube_master" {
  count        = 1
  name         = "${var.master_prefix}-0"
  machine_type = "n1-standard-2"
  zone         = "${element(var.azs, 0)}"

  tags = ["allow-svcs"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
      size  = "60"
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = "${var.metadata}"

  metadata_startup_script = "${file("${format("%s/startup.sh", path.module)}")}"

  provisioner "remote-exec" {
    script = "${format("%s/apps/appdeploy.sh", path.module)}"
    connection {
          type     = "ssh"
          user     = "${var.ssh_user}"
          private_key = "${file(var.ssh_private_key)}"
          agent    = true
    }
  }

}

resource "google_compute_firewall" "ssh_fw_rule" {
  name    = "${data.google_compute_subnetwork.default.name}-allow-svcs"
  network = "${data.google_compute_subnetwork.default.name}"
  allow {
    protocol = "tcp"
    ports = ["22","80", "30000-32767"]
  }
  source_ranges = "${var.ssh_ip_ranges}"
  target_tags = ["allow-svcs"]
}
