variable "cloud_id" {
  description = "ID облака Yandex Cloud"
  type        = string
}

variable "folder_id" {
  description = "ID каталога Yandex Cloud"
  type        = string
}

variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
  default     = "stage-vm"
}

variable "cores" {
  description = "Количество ядер процессора"
  type        = number
}

variable "memory" {
  description = "Объём RAM в ГБ"
  type        = number
}

variable "disk_size" {
  description = "Размер подключаемого диска в ГБ"
  type        = number
}

variable "subnet_id" {
  description = "ID подсети"
  type        = string
}

variable "ssh_key" {
  description = "SSH-ключ для доступа к ВМ"
  type        = string
  sensitive   = true
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "labels" {
  description = "Метки для ресурсов"
  type        = map(string)
  default = {
    environment = "stage"
  }
}
