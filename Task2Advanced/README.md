# Task2Advanced — CI/CD и удалённое хранение состояния

## Описание

Расширение Task1Advanced: добавлено удалённое хранение состояния Terraform в Yandex Object Storage (S3-совместимое хранилище) и автоматизация развёртывания через GitHub Actions.

## Структура

```
Task2Advanced/
├── modules/
│   └── vm/
│       ├── main.tf        # Ресурсы ВМ, диск, подключение диска
│       ├── variables.tf   # Входные параметры модуля
│       └── outputs.tf     # Выходные значения
├── envs/
│   ├── dev/
│   │   ├── main.tf                   # Provider + S3 backend + module call
│   │   ├── variables.tf              # Переменные окружения
│   │   └── terraform.tfvars.example  # Пример значений: 2 ядра, 4 ГБ RAM, 20 ГБ диск
│   ├── stage/
│   │   ├── main.tf                   # S3 key: stage/terraform.tfstate
│   │   ├── variables.tf
│   │   └── terraform.tfvars.example  # Пример значений: 4 ядра, 8 ГБ RAM, 50 ГБ диск
│   └── prod/
│       ├── main.tf                   # S3 key: prod/terraform.tfstate
│       ├── variables.tf
│       └── terraform.tfvars.example  # Пример значений: 8 ядер, 16 ГБ RAM, 100 ГБ диск
├── .github/
│   └── workflows/
│       └── terraform.yml             # GitHub Actions pipeline
└── backend.hcl.example               # Пример конфигурации backend для локального использования
```

## Удалённое хранение состояния (S3 Backend)

Состояние Terraform хранится в Yandex Object Storage. Каждое окружение имеет отдельный ключ:

| Окружение | Ключ состояния              |
|-----------|-----------------------------|
| dev       | `dev/terraform.tfstate`     |
| stage     | `stage/terraform.tfstate`   |
| prod      | `prod/terraform.tfstate`    |

### Создание бакета

Создайте бакет в Yandex Object Storage через консоль или CLI:

```bash
yc storage bucket create --name terraform-state-bucket
```

### Создание сервисного аккаунта и ключей

```bash
# Создать сервисный аккаунт
yc iam service-account create --name terraform-sa

# Назначить роль
yc resource-manager folder add-access-binding <FOLDER_ID> \
  --role editor \
  --subject serviceAccount:<SA_ID>

# Создать статический ключ для S3
yc iam access-key create --service-account-name terraform-sa
```

## GitHub Actions CI/CD

### Триггеры

| Событие          | Условие                                    | Действие         |
|------------------|--------------------------------------------|------------------|
| `push`           | Ветки `main`, `develop`; изменения в `Task2Advanced/` | `terraform plan` для всех окружений |
| `pull_request`   | Ветки `main`, `develop`; изменения в `Task2Advanced/` | `terraform plan` + комментарий в PR |
| `workflow_dispatch` | Ручной запуск с выбором окружения и действия | `plan` или `apply` |

### Пайплайн

**Job: terraform-plan**
1. Checkout кода
2. Установка Terraform 1.6.0
3. Настройка Yandex Cloud credentials
4. `terraform init` с `-backend-config` для S3
5. `terraform fmt -check` — проверка форматирования
6. `terraform validate` — валидация конфигурации
7. `terraform plan` — планирование изменений
8. Комментарий в PR с результатом (при PR)

**Job: terraform-apply** (только при `workflow_dispatch action=apply`)
1. Checkout кода
2. Установка Terraform 1.6.0
3. Настройка Yandex Cloud credentials
4. `terraform init` с `-backend-config` для S3
5. `terraform apply -auto-approve`

### Требуемые секреты GitHub

| Секрет                  | Описание                                        |
|-------------------------|-------------------------------------------------|
| `YC_SERVICE_ACCOUNT_KEY`| JSON-ключ сервисного аккаунта Yandex Cloud     |
| `S3_ACCESS_KEY`         | Access Key для Yandex Object Storage            |
| `S3_SECRET_KEY`         | Secret Key для Yandex Object Storage            |
| `YC_CLOUD_ID`           | ID облака Yandex Cloud                          |
| `YC_FOLDER_ID`          | ID каталога Yandex Cloud                        |
| `SSH_KEY`               | SSH-ключ для доступа к ВМ                       |

### Переменные GitHub (Variables)

| Переменная   | Описание                           | По умолчанию         |
|--------------|------------------------------------|----------------------|
| `VM_NAME`    | Имя ВМ                             | `{env}-vm`           |
| `VM_CORES`   | Количество ядер                    | `2`                  |
| `VM_MEMORY`  | Объём RAM в ГБ                     | `4`                  |
| `VM_DISK_SIZE`| Размер диска в ГБ                 | `20`                 |
| `SUBNET_ID`  | ID подсети                         | —                    |

## Локальный запуск с remote state

```bash
# Скопировать пример backend конфигурации
cp backend.hcl.example envs/dev/backend.hcl
# Заполнить реальными ключами

# Инициализировать с remote backend
cd envs/dev
terraform init -backend-config=backend.hcl

# Планировать и применять
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## Безопасность

- Секреты (`S3_ACCESS_KEY`, `S3_SECRET_KEY`, `YC_SERVICE_ACCOUNT_KEY`) передаются только через GitHub Secrets — никогда не хранятся в коде
- Файл `backend.hcl` добавлен в `.gitignore` — ключи не попадают в репозиторий
- Файлы `*.tfvars` добавлены в `.gitignore` — реальные значения не попадают в репозиторий
- `apply` доступен только через ручной запуск `workflow_dispatch` — случайное применение исключено
- Состояние изолировано по окружениям — изменение dev не затрагивает prod
