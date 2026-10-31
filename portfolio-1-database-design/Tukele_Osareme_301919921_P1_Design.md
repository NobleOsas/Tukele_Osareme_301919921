# MIT 8103: Bank / Fintech Platform — database design

My case study records customer, account, transfer.

## Users

- Customers reviewing account activity
- Operations staff monitoring transfers
- Developers maintaining the platform

## Main operations

- Create customer and account records
- Record transfers between accounts
- Review transfer activity by account and status
- Summarize transfer amounts by account

## Entities

| Entity | Information stored |
| --- | --- |
| customer | Stores a platform customer independently of their account records. |
| account | Stores an account, its customer reference, currency, and current balance. Normalisation example: account references customer by customer_id, so customer name and email are stored once in customer rather than repeated on each account. |
| transfer | Records a synthetic transfer, its two account references, amount, status, timestamp, and request idempotency key. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## account

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| account_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| account_number | TEXT | Unique | Yes |
| currency | TEXT |  | Yes |
| balance | NUMERIC(18,2) |  | Yes |
| opened_on | DATE |  | Yes |
- customer_id → customer.customer_id
- Unique key: (account_number).

## transfer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| transfer_id | BIGINT | PK | Yes |
| from_account_id | BIGINT | FK | Yes |
| to_account_id | BIGINT | FK | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| status | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
| idempotency_key | TEXT | Unique | Yes |
- from_account_id → account.account_id
- to_account_id → account.account_id
- Unique key: (idempotency_key).

## Relationships and business rules

- Each customer email identifies at most one customer.
- Every account must reference an existing customer through customer_id.
- An account balance must be zero or greater.
- Every transfer must reference an existing source account through from_account_id.
- Every transfer must reference an existing destination account through to_account_id.
- A transfer amount must be greater than zero.
- A request idempotency key may identify at most one recorded transfer.

## Assumptions

- Each account belongs to one customer and has one currency.
- Each transfer moves a positive amount between two distinct platform accounts.
- Balances are represented as decimal amounts in the account's currency; currency conversion is out of scope.
- Transfer status is a descriptive field; this model does not prescribe a production workflow.

