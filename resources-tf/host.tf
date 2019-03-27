resource "google_compute_address" "ext_addr" {
  name = "nagios"
  address_type = "EXTERNAL"
}

resource "google_dns_record_set" "dns_record" {
  name = "nagios.rchain-dev.tk."
  managed_zone = "rchain-dev"
  type = "A"
  ttl = 300
  rrdatas = ["${google_compute_address.ext_addr.*.address[count.index]}"]
}

resource "google_compute_instance" "nagios_host" {
  name = "nagios"
  hostname = "nagios.rchain-dev.tk"
  machine_type = "n1-highcpu-4"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1810"
      size = 60
      type = "pd-standard"
    }
  }

  tags = [ "nagios", "nagios-api-in", "http" ]

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.ext_addr.*.address[count.index]}"
    }
  }

  connection {
    type = "ssh"
    user = "root"
    private_key = "${file("~/.ssh/google_compute_engine")}"
  }

  provisioner "file" {
    source = "${var.rchain_sre_git_crypt_key_file}"
    destination = "/root/rchain-sre-git-crypt-key"
  }

  provisioner "remote-exec" {
    script = "../bootstrap"
  }
}
