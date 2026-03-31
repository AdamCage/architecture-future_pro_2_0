resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  platform_id = var.platform_id
  zone        = var.zone

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 20
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_key}"
  }

  labels = var.labels
}

resource "yandex_compute_disk" "additional_disk" {
  name   = "${var.vm_name}-disk"
  type   = var.disk_type
  zone   = var.zone
  size   = var.disk_size
  labels = var.labels
}

resource "yandex_compute_instance_attachment" "disk_attachment" {
  instance_id = yandex_compute_instance.vm.id
  disk_id     = yandex_compute_disk.additional_disk.id
}
