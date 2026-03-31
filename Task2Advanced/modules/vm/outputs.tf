output "vm_id" {
  description = "ID виртуальной машины"
  value       = yandex_compute_instance.vm.id
}

output "vm_name" {
  description = "Имя виртуальной машины"
  value       = yandex_compute_instance.vm.name
}

output "vm_external_ip" {
  description = "Внешний IP-адрес ВМ"
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "vm_internal_ip" {
  description = "Внутренний IP-адрес ВМ"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "disk_id" {
  description = "ID подключаемого диска"
  value       = yandex_compute_disk.additional_disk.id
}

output "disk_name" {
  description = "Имя подключаемого диска"
  value       = yandex_compute_disk.additional_disk.name
}

output "disk_size" {
  description = "Размер подключаемого диска в ГБ"
  value       = yandex_compute_disk.additional_disk.size
}

output "zone" {
  description = "Зона доступности"
  value       = yandex_compute_instance.vm.zone
}
