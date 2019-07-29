resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }
  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"
    # использовать ephemeral IP для доступа из Интернет
    access_config {
		nat_ip = "${google_compute_address.app_ip.address}"
	}
  }
  connection {
    type  = "ssh"
    host  = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
    user  = "makalexs"
    agent = false
    # путь до приватного ключа
    private_key = "${file(var.private_key)}"
  }
  provisioner "file" {
    source      = "../modules/app/setup_app.sh"
    destination = "/home/makalexs/setup_app.sh"

        connection {
      type        = "ssh"
      user        = "makalexs"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/makalexs/setup_app.sh",
      "home/makalexs/setup_app.sh ${var.db_internal_ip}",
    ]

    connection {
      type        = "ssh"
      user        = "makalexs"
    }
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}

resource "google_compute_address" "app_ip" {
	name 	= "reddit-app-ip"
	region 	= "${var.region}"
}
