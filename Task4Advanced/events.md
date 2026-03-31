# Каталог доменных событий системы "Будущее 2.0"

## Медицинский домен

### PatientRegistered
| Поле          | Значение                                           |
|---------------|----------------------------------------------------|
| **Название**  | PatientRegistered                                  |
| **Контекст**  | Patient Management                                 |
| **Семантика** | Новый пациент зарегистрирован в системе            |
| **Топик**     | `medical.patient.registered`                       |

**Минимальный контракт (JSON Schema):**
```json
{
  "eventId": "uuid",
  "eventType": "PatientRegistered",
  "occurredAt": "datetime",
  "patientId": "uuid",
  "fullName": "string",
  "birthDate": "date",
  "registeredAt": "datetime"
}
```

---

### AppointmentCompleted
| Поле          | Значение                                                       |
|---------------|----------------------------------------------------------------|
| **Название**  | AppointmentCompleted                                           |
| **Контекст**  | Patient Management                                             |
| **Семантика** | Приём пациента завершён; триггер для оплаты и ИИ-обработки    |
| **Топик**     | `medical.appointment.completed`                                |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "AppointmentCompleted",
  "occurredAt": "datetime",
  "appointmentId": "uuid",
  "patientId": "uuid",
  "staffId": "uuid",
  "clinicId": "uuid",
  "completedAt": "datetime",
  "serviceCode": "string"
}
```

---

### AppointmentCancelled
| Поле          | Значение                                           |
|---------------|----------------------------------------------------|
| **Название**  | AppointmentCancelled                               |
| **Контекст**  | Patient Management                                 |
| **Семантика** | Запись на приём отменена                           |
| **Топик**     | `medical.appointment.cancelled`                    |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "AppointmentCancelled",
  "occurredAt": "datetime",
  "appointmentId": "uuid",
  "patientId": "uuid",
  "cancelledAt": "datetime",
  "reason": "string"
}
```

---

### ResearchProcessed
| Поле          | Значение                                                      |
|---------------|---------------------------------------------------------------|
| **Название**  | ResearchProcessed                                             |
| **Контекст**  | AI Services                                                   |
| **Семантика** | Результаты медицинского исследования получены и обработаны    |
| **Топик**     | `medical.research.processed`                                  |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "ResearchProcessed",
  "occurredAt": "datetime",
  "researchId": "uuid",
  "patientId": "uuid",
  "researchType": "string",
  "processedAt": "datetime"
}
```

---

### AIAnalysisCompleted
| Поле          | Значение                                                      |
|---------------|---------------------------------------------------------------|
| **Название**  | AIAnalysisCompleted                                           |
| **Контекст**  | AI Services                                                   |
| **Семантика** | ИИ-анализ медицинских данных завершён, рекомендации готовы    |
| **Топик**     | `medical.ai.analysis.completed`                               |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "AIAnalysisCompleted",
  "occurredAt": "datetime",
  "analysisId": "uuid",
  "patientId": "uuid",
  "modelVersion": "string",
  "confidence": "float",
  "recommendationSummary": "string",
  "processedAt": "datetime"
}
```

---

### StaffRegistered
| Поле          | Значение                                           |
|---------------|----------------------------------------------------|
| **Название**  | StaffRegistered                                    |
| **Контекст**  | Staff Management                                   |
| **Семантика** | Новый сотрудник зарегистрирован в системе          |
| **Топик**     | `medical.staff.registered`                         |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "StaffRegistered",
  "occurredAt": "datetime",
  "staffId": "uuid",
  "fullName": "string",
  "roles": ["string"],
  "clinicId": "uuid"
}
```

---

## Финансовый домен

### AccountCreated
| Поле          | Значение                                           |
|---------------|----------------------------------------------------|
| **Название**  | AccountCreated                                     |
| **Контекст**  | Account Management                                 |
| **Семантика** | Новый банковский счёт открыт для клиента           |
| **Топик**     | `finance.account.created`                          |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "AccountCreated",
  "occurredAt": "datetime",
  "accountId": "uuid",
  "patientId": "uuid",
  "currency": "string",
  "initialBalance": "decimal",
  "createdAt": "datetime"
}
```

---

### AccountBalanceUpdated
| Поле          | Значение                                                      |
|---------------|---------------------------------------------------------------|
| **Название**  | AccountBalanceUpdated                                         |
| **Контекст**  | Account Management                                            |
| **Семантика** | Баланс счёта изменён в результате транзакции или платежа      |
| **Топик**     | `finance.account.balance.updated`                             |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "AccountBalanceUpdated",
  "occurredAt": "datetime",
  "accountId": "uuid",
  "previousBalance": "decimal",
  "newBalance": "decimal",
  "delta": "decimal",
  "currency": "string",
  "reason": "string"
}
```

---

### CreditContractCreated
| Поле          | Значение                                                      |
|---------------|---------------------------------------------------------------|
| **Название**  | CreditContractCreated                                         |
| **Контекст**  | Credit Management                                             |
| **Семантика** | Новый кредитный договор оформлен для клиента                  |
| **Топик**     | `finance.credit.contract.created`                             |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "CreditContractCreated",
  "occurredAt": "datetime",
  "contractId": "uuid",
  "patientId": "uuid",
  "creditLimit": "decimal",
  "interestRate": "float",
  "startDate": "date",
  "endDate": "date",
  "currency": "string"
}
```

---

### PaymentProcessed
| Поле          | Значение                                                            |
|---------------|---------------------------------------------------------------------|
| **Название**  | PaymentProcessed                                                    |
| **Контекст**  | Payment Processing                                                  |
| **Семантика** | Платёж успешно обработан; обновляются балансы и аналитические метрики |
| **Топик**     | `finance.payment.processed`                                         |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "PaymentProcessed",
  "occurredAt": "datetime",
  "paymentId": "uuid",
  "sourceAccountId": "uuid",
  "targetAccountId": "uuid",
  "amount": "decimal",
  "currency": "string",
  "processedAt": "datetime",
  "referenceId": "uuid"
}
```

---

### PaymentFailed
| Поле          | Значение                                                      |
|---------------|---------------------------------------------------------------|
| **Название**  | PaymentFailed                                                 |
| **Контекст**  | Payment Processing                                            |
| **Семантика** | Платёж не прошёл; необходима компенсирующая транзакция        |
| **Топик**     | `finance.payment.failed`                                      |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "PaymentFailed",
  "occurredAt": "datetime",
  "paymentId": "uuid",
  "sourceAccountId": "uuid",
  "amount": "decimal",
  "currency": "string",
  "failedAt": "datetime",
  "errorCode": "string",
  "errorMessage": "string"
}
```

---

### FinancialReportGenerated
| Поле          | Значение                                                 |
|---------------|----------------------------------------------------------|
| **Название**  | FinancialReportGenerated                                 |
| **Контекст**  | Financial Reporting                                      |
| **Семантика** | Финансовый отчёт сформирован и готов к публикации        |
| **Топик**     | `finance.report.generated`                               |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "FinancialReportGenerated",
  "occurredAt": "datetime",
  "reportId": "uuid",
  "reportType": "string",
  "periodStart": "date",
  "periodEnd": "date",
  "generatedAt": "datetime"
}
```

---

## Аналитический домен

### AggregateUpdated
| Поле          | Значение                                                                |
|---------------|-------------------------------------------------------------------------|
| **Название**  | AggregateUpdated                                                        |
| **Контекст**  | Streaming Marts                                                         |
| **Семантика** | Метрика агрегации обновлена на основе входящих событий из доменов      |
| **Топик**     | `analytics.aggregate.updated`                                           |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "AggregateUpdated",
  "occurredAt": "datetime",
  "aggregateId": "uuid",
  "metricName": "string",
  "value": "decimal",
  "dimensions": {"key": "value"},
  "windowEnd": "datetime"
}
```

---

### MaterializedViewRefreshed
| Поле          | Значение                                                            |
|---------------|---------------------------------------------------------------------|
| **Название**  | MaterializedViewRefreshed                                           |
| **Контекст**  | Streaming Marts                                                     |
| **Семантика** | Материализованное представление обновлено, данные актуальны         |
| **Топик**     | `analytics.view.refreshed`                                          |

**Минимальный контракт:**
```json
{
  "eventId": "uuid",
  "eventType": "MaterializedViewRefreshed",
  "occurredAt": "datetime",
  "viewId": "uuid",
  "viewName": "string",
  "refreshedAt": "datetime",
  "rowCount": "integer"
}
```

---

## Общие требования к событиям

### Обязательные поля каждого события
- `eventId` — уникальный идентификатор события (UUID v4)
- `eventType` — тип события (строка)
- `occurredAt` — время возникновения события (ISO 8601)

### Заголовки Kafka-сообщения
- `correlationId` — ID для связи цепочки событий
- `schemaVersion` — версия схемы события
- `sourceService` — сервис-источник

### Версионирование схем
- Версии схем хранятся в Confluent Schema Registry
- Обратная совместимость обязательна для минорных версий
- Breaking changes требуют создания нового топика или версии
