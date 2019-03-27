resource "google_compute_instance" "nagios_host" {
  name = "nagios"
  hostname = "nagios.rchain-dev.tk"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1810"
      size = 60
      type = "pd-standard"
    }
  }

  tags = [ "nagios-api-in" ]

  network_interface {
    network = "default"
    access_config {}
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
