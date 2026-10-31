-- Fictional sample records for MIT 8103: Bank / Fintech Platform.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_at") VALUES (1, 'Avery Quinn', 'avery.quinn@example.test', '2026-01-10T09:00:00Z');
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_at") VALUES (2, 'Jordan Lee', 'jordan.lee@example.test', '2026-01-11T09:00:00Z');
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on") VALUES (3, 1, 'ACCT-1001', 'USD', 1200.5, '2026-01-12');
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on") VALUES (4, 2, 'ACCT-1002', 'EUR', 800, '2026-01-13');
INSERT INTO portfolio."transfer" ("transfer_id", "from_account_id", "to_account_id", "amount", "status", "created_at", "idempotency_key") VALUES (5, 3, 4, 25.5, 'settled', '2026-01-14T10:00:00Z', 'idem-1001');
INSERT INTO portfolio."transfer" ("transfer_id", "from_account_id", "to_account_id", "amount", "status", "created_at", "idempotency_key") VALUES (6, 4, 3, 10, 'pending', '2026-01-15T10:00:00Z', 'idem-1002');
COMMIT;
