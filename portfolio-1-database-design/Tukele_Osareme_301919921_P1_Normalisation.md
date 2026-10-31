# MIT 8103: Bank / Fintech Platform — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| customer_id | account records (list) |
| --- | --- |
| 1 | [3] |
| 2 | [4] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| account.account_id | account.customer_id | account.account_number | customer.customer_id | customer.full_name |
| --- | --- | --- | --- | --- |
| 3 | 1 | ACCT-1001 | 1 | Avery Quinn |
| 4 | 2 | ACCT-1002 | 2 | Jordan Lee |

Key: account_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## account_example

| account.account_id | account.customer_id | account.account_number | customer.customer_id | customer.full_name |
| --- | --- | --- | --- | --- |
| 3 | 1 | ACCT-1001 | 1 | Avery Quinn |
| 4 | 2 | ACCT-1002 | 2 | Jordan Lee |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | full_name | email | created_at |
| --- | --- | --- | --- |
| 1 | Avery Quinn | avery.quinn@example.test | 2026-01-10T09:00:00+00:00 |
| 2 | Jordan Lee | jordan.lee@example.test | 2026-01-11T09:00:00+00:00 |

## account

| account_id | customer_id | account_number | currency | balance | opened_on |
| --- | --- | --- | --- | --- | --- |
| 3 | 1 | ACCT-1001 | USD | 1200.5 | 2026-01-12 |
| 4 | 2 | ACCT-1002 | EUR | 800 | 2026-01-13 |

## transfer

| transfer_id | from_account_id | to_account_id | amount | status | created_at | idempotency_key |
| --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | 4 | 25.5 | settled | 2026-01-14T10:00:00+00:00 | idem-1001 |
| 6 | 4 | 3 | 10 | pending | 2026-01-15T10:00:00+00:00 | idem-1002 |

## Dependencies

- customer: (customer_id) → full_name, email, created_at
- account: (account_id) → customer_id, account_number, currency, balance, opened_on
- transfer: (transfer_id) → from_account_id, to_account_id, amount, status, created_at, idempotency_key

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
