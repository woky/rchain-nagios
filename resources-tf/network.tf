data "google_compute_network" "default_network" {
  name = "default"
}

resource "google_compute_firewall" "fw_nagios_api" {
  name = "nagios-api"
  network = "${data.google_compute_network.default_network.self_link}"
  priority = 500
  source_tags = [ "nagios-api-out" ]
  target_tags = [ "nagios-api-in" ]
  allow {
    protocol = "tcp"
    ports = [ 6315 ]
  }
}
