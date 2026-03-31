# Task1Advanced — Модульная инфраструктура для нескольких сред

## Описание

Переиспользуемый Terraform-модуль для создания виртуальных машин в Yandex Cloud с подключаемым диском. Модуль параметризован и используется в трёх окружениях: dev, stage, prod.

## Структура

```
Task1Advanced/
├── modules/
│   └── vm/
│       ├── main.tf        # Ресурсы ВМ, диск, подключение диска
│       ├── variables.tf   # Входные параметры модуля
│       └── outputs.tf     # Выходные значения
└── envs/
    ├── dev/
    │   ├── main.tf                   # Provider + module call
    │   ├── variables.tf              # Переменные окружения
    │   └── terraform.tfvars.example  # Пример значений: 2 ядра, 4 ГБ RAM, 20 ГБ диск
    ├── stage/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── terraform.tfvars.example  # Пример значений: 4 ядра, 8 ГБ RAM, 50 ГБ диск
    └── prod/
        ├── main.tf
        ├── variables.tf
        └── terraform.tfvars.example  # Пример значений: 8 ядер, 16 ГБ RAM, 100 ГБ диск
```

## Параметры модуля (`modules/vm`)

| Параметр     | Тип          | Обязательный | Описание                                      |
|--------------|--------------|:------------:|-----------------------------------------------|
| `vm_name`    | `string`     | Да           | Имя виртуальной машины                        |
| `cores`      | `number`     | Да           | Количество ядер процессора                    |
| `memory`     | `number`     | Да           | Объём RAM в ГБ                                |
| `disk_size`  | `number`     | Да           | Размер подключаемого диска в ГБ               |
| `subnet_id`  | `string`     | Да           | ID подсети                                    |
| `ssh_key`    | `string`     | Да           | SSH-ключ для доступа к ВМ (sensitive)         |
| `zone`       | `string`     | Нет          | Зона доступности (default: `ru-central1-a`)   |
| `image_id`   | `string`     | Нет          | ID образа (default: Ubuntu 22.04 LTS)         |
| `platform_id`| `string`     | Нет          | Платформа (default: `standard-v1`)            |
| `disk_type`  | `string`     | Нет          | Тип диска (default: `network-ssd`)            |
| `labels`     | `map(string)`| Нет          | Метки для ресурсов (default: `{}`)            |

## Выходы модуля

| Выход           | Описание                          |
|-----------------|-----------------------------------|
| `vm_id`         | ID виртуальной машины             |
| `vm_name`       | Имя виртуальной машины            |
| `vm_external_ip`| Внешний IP-адрес ВМ               |
| `vm_internal_ip`| Внутренний IP-адрес ВМ            |
| `disk_id`       | ID подключаемого диска            |
| `disk_name`     | Имя подключаемого диска           |
| `disk_size`     | Размер подключаемого диска в ГБ   |
| `zone`          | Зона доступности                  |

## Конфигурация окружений

| Параметр    | dev  | stage | prod  |
|-------------|------|-------|-------|
| `cores`     | 2    | 4     | 8     |
| `memory`    | 4    | 8     | 16    |
| `disk_size` | 20   | 50    | 100   |

## Запуск

### Подготовка

1. Скопируйте файл `.tfvars.example` в `terraform.tfvars` в нужном окружении:

```bash
cp envs/dev/terraform.tfvars.example envs/dev/terraform.tfvars
```

2. Заполните реальными значениями `cloud_id`, `folder_id`, `subnet_id`, `ssh_key`.

### Инициализация и применение

```bash
# dev-окружение
cd envs/dev
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars

# stage-окружение
cd envs/stage
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars

# prod-окружение
cd envs/prod
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

### Уничтожение ресурсов

```bash
terraform destroy -var-file=terraform.tfvars
```

## Принципы модуля

- Внутри модуля нет захардкоженных значений окружений — всё через переменные
- Каждое окружение использует свой `.tfvars` с различными параметрами
- Модуль создаёт: ВМ (`yandex_compute_instance`), дополнительный диск (`yandex_compute_disk`) и подключает его к ВМ (`yandex_compute_instance_attachment`)
- Метки (`labels`) позволяют идентифицировать ресурсы по окружению и проекту
