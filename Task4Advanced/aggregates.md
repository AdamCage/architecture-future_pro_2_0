# Агрегаты системы "Будущее 2.0"

## Медицинский домен

### Patient (Пациент)
**Bounded Context:** Patient Management

**Идентификатор:** `patientId` (UUID)

**Инварианты:**
- ФИО пациента не может быть пустым
- Дата рождения не может быть в будущем
- Один активный статус пациента одновременно (активный/архивный)

**Ключевые атрибуты:**
- `patientId` — уникальный идентификатор
- `fullName` — полное имя
- `birthDate` — дата рождения
- `contactInfo` — контактная информация
- `status` — статус пациента
- `registeredAt` — дата регистрации

**Команды:** RegisterPatient, UpdatePatientInfo, ArchivePatient

**События:** PatientRegistered, PatientUpdated, PatientArchived

---

### MedicalRecord (Медицинская карта)
**Bounded Context:** Patient Management

**Идентификатор:** `recordId` (UUID)

**Инварианты:**
- Медицинская карта обязательно привязана к существующему пациенту
- Медицинские исследования и истории болезни хранятся отдельно и не включаются в аналитику
- Карта не может быть удалена, только архивирована

**Ключевые атрибуты:**
- `recordId` — уникальный идентификатор
- `patientId` — ссылка на пациента
- `createdAt` — дата создания
- `lastUpdatedAt` — дата последнего обновления

**Команды:** CreateMedicalRecord, UpdateMedicalRecord

**События:** MedicalRecordCreated, MedicalRecordUpdated

---

### Appointment (Запись на приём)
**Bounded Context:** Patient Management

**Идентификатор:** `appointmentId` (UUID)

**Инварианты:**
- Запись должна иметь привязанного пациента и врача
- Время записи не может быть в прошлом (при создании)
- Нельзя отменить уже завершённую запись
- Статус: Created → Confirmed → Completed | Cancelled

**Ключевые атрибуты:**
- `appointmentId` — уникальный идентификатор
- `patientId` — ссылка на пациента
- `staffId` — ссылка на врача
- `clinicId` — ссылка на клинику
- `scheduledAt` — запланированное время
- `status` — статус записи
- `completedAt` — время завершения

**Команды:** CreateAppointment, ConfirmAppointment, CompleteAppointment, CancelAppointment

**События:** AppointmentCreated, AppointmentConfirmed, AppointmentCompleted, AppointmentCancelled

---

### Clinic (Клиника)
**Bounded Context:** Clinic Management

**Идентификатор:** `clinicId` (UUID)

**Инварианты:**
- Клиника должна иметь уникальное название и адрес
- Хотя бы один активный кабинет должен быть зарегистрирован

**Ключевые атрибуты:**
- `clinicId` — уникальный идентификатор
- `name` — название клиники
- `address` — адрес
- `contactInfo` — контактная информация
- `rooms` — список кабинетов

**Команды:** CreateClinic, UpdateClinicInfo, AddRoom

**События:** ClinicCreated, ClinicUpdated, RoomAssigned

---

### Staff (Персонал)
**Bounded Context:** Staff Management

**Идентификатор:** `staffId` (UUID)

**Инварианты:**
- Сотрудник должен иметь хотя бы одну роль
- Лицензия врача должна быть действующей для приёма пациентов
- Рабочее расписание не может иметь пересекающихся временных слотов

**Ключевые атрибуты:**
- `staffId` — уникальный идентификатор
- `fullName` — полное имя
- `roles` — список ролей
- `specialization` — специализация
- `licenseNumber` — номер медицинской лицензии
- `workSchedule` — рабочее расписание

**Команды:** RegisterStaff, AssignRole, UpdateWorkSchedule

**События:** StaffRegistered, StaffRoleChanged, WorkScheduleUpdated

---

### Equipment (Оборудование)
**Bounded Context:** Inventory Management

**Идентификатор:** `equipmentId` (UUID)

**Инварианты:**
- Серийный номер оборудования уникален
- Статус обслуживания должен отражать реальное состояние

**Ключевые атрибуты:**
- `equipmentId` — уникальный идентификатор
- `serialNumber` — серийный номер
- `name` — наименование
- `clinicId` — местонахождение
- `maintenanceStatus` — статус обслуживания
- `lastMaintenanceAt` — дата последнего обслуживания

**Команды:** RegisterEquipment, UpdateMaintenanceStatus

**События:** EquipmentRegistered, EquipmentMaintenanceUpdated

---

### AIAnalysis (ИИ-анализ)
**Bounded Context:** AI Services

**Идентификатор:** `analysisId` (UUID)

**Инварианты:**
- Анализ всегда привязан к конкретному запросу (исследованию)
- Результат анализа неизменяем после завершения
- Уровень уверенности (confidence) должен быть в диапазоне 0–1

**Ключевые атрибуты:**
- `analysisId` — уникальный идентификатор
- `requestId` — ссылка на исходный запрос
- `modelVersion` — версия используемой ML-модели
- `result` — результат анализа
- `confidence` — уровень уверенности
- `processedAt` — время обработки

**Команды:** RequestAIAnalysis, CompleteAIAnalysis

**События:** AIAnalysisRequested, AIAnalysisCompleted, RecommendationGenerated

---

## Финансовый домен

### Account (Счёт)
**Bounded Context:** Account Management

**Идентификатор:** `accountId` (UUID)

**Инварианты:**
- Баланс не может быть ниже разрешённого минимума без явного кредитования
- Счёт привязан к конкретному клиенту (patientId)
- Замороженный счёт не допускает транзакций

**Ключевые атрибуты:**
- `accountId` — уникальный идентификатор
- `patientId` — ссылка на клиента
- `balance` — текущий баланс
- `currency` — валюта
- `status` — статус (active/frozen/closed)
- `createdAt` — дата открытия

**Команды:** CreateAccount, CreditAccount, DebitAccount, FreezeAccount, CloseAccount

**События:** AccountCreated, AccountBalanceUpdated, AccountFrozen, AccountClosed

---

### CreditContract (Кредитный договор)
**Bounded Context:** Credit Management

**Идентификатор:** `contractId` (UUID)

**Инварианты:**
- Кредитный лимит не может превышать установленный максимум для клиента
- Срок действия договора должен быть в будущем (при создании)
- Процентная ставка должна быть положительной

**Ключевые атрибуты:**
- `contractId` — уникальный идентификатор
- `patientId` — ссылка на клиента
- `creditLimit` — кредитный лимит
- `interestRate` — процентная ставка
- `startDate` — дата начала
- `endDate` — дата окончания
- `status` — статус договора
- `paymentSchedule` — график платежей

**Команды:** CreateCreditContract, ChangeCreditLimit, CloseCreditContract

**События:** CreditContractCreated, CreditLimitChanged, PaymentDue, CreditRepaid

---

### Payment (Платёж)
**Bounded Context:** Payment Processing

**Идентификатор:** `paymentId` (UUID)

**Инварианты:**
- Сумма платежа должна быть положительной
- Платёж не может быть отменён после успешного выполнения
- Статус: Initiated → Processing → Processed | Failed

**Ключевые атрибуты:**
- `paymentId` — уникальный идентификатор
- `sourceAccountId` — счёт-источник
- `targetAccountId` — счёт-получатель
- `amount` — сумма
- `currency` — валюта
- `status` — статус
- `initiatedAt` — время инициации
- `processedAt` — время обработки

**Команды:** InitiatePayment, ProcessPayment, FailPayment

**События:** PaymentInitiated, PaymentProcessed, PaymentFailed

---

## Аналитический домен

### DataView (Представление данных)
**Bounded Context:** Data Mart

**Идентификатор:** `viewId` (UUID)

**Инварианты:**
- Представление не включает данные медицинских карт и результатов исследований
- Доступ ограничен согласно ролям пользователя

**Ключевые атрибуты:**
- `viewId` — уникальный идентификатор
- `name` — название представления
- `query` — запрос для формирования данных
- `accessRoles` — роли, имеющие доступ
- `lastRefreshedAt` — время последнего обновления

**Команды:** CreateDataView, RefreshDataView

**События:** DataViewCreated, DataViewRefreshed

---

### MaterializedView (Материализованное представление)
**Bounded Context:** Streaming Marts

**Идентификатор:** `viewId` (UUID)

**Инварианты:**
- Данные обновляются в near-real-time (задержка < 1 минуты)
- Агрегации вычисляются на основе входящих событий

**Ключевые атрибуты:**
- `viewId` — уникальный идентификатор
- `sourceTopic` — исходный Kafka-топик
- `aggregationType` — тип агрегации
- `windowSize` — размер временного окна
- `lastUpdatedAt` — время последнего обновления

**Команды:** CreateMaterializedView, UpdateAggregation

**События:** MaterializedViewCreated, AggregateUpdated, MaterializedViewRefreshed
