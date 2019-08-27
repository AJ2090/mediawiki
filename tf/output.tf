output "kube_masters_interal_ip" {
  value = "${google_compute_instance.kube_master.*.network_interface.0.network_ip}"
}

output "kube_masters_public_ip" {
  value = "${google_compute_instance.kube_master.*.network_interface.0.access_config.0.nat_ip}"
}

output "kube_masters_names" {
  value = "${google_compute_instance.kube_master.*.name}"
}
