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

variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "image_id" {
  description = "ID образа для ВМ"
  type        = string
  default     = "fd8kdq6d0p8sij7h5qe3" # Ubuntu 22.04 LTS
}

variable "platform_id" {
  description = "Платформа (standard-v1, standard-v2, etc.)"
  type        = string
  default     = "standard-v1"
}

variable "disk_type" {
  description = "Тип диска (network-ssd, network-hdd)"
  type        = string
  default     = "network-ssd"
}

variable "labels" {
  description = "Метки для ресурсов"
  type        = map(string)
  default     = {}
}
