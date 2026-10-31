-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_at")
VALUES (1, 'Casey Vale', 'casey.pk@example.test', '2026-02-01T09:00:00Z');

-- 2. customer unique. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_at")
VALUES (101, 'Casey Vale', 'avery.quinn@example.test', '2026-02-01T09:00:00Z');

-- 3. customer not null. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_at")
VALUES (102, NULL, 'casey.null@example.test', '2026-02-01T09:00:00Z');

-- 4. account pk. Expected: pk_account, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on")
VALUES (3, 2, 'ACCT-2001', 'USD', 1, '2026-02-01');

-- 5. account unique. Expected: uq_account_0, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on")
VALUES (103, 2, 'ACCT-1001', 'USD', 1, '2026-02-01');

-- 6. account fk. Expected: fk_account_0, SQLSTATE 23503.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on")
VALUES (104, 900001, 'ACCT-2002', 'USD', 1, '2026-02-01');

-- 7. transfer pk. Expected: pk_transfer, SQLSTATE 23505.
INSERT INTO portfolio."transfer" ("transfer_id", "from_account_id", "to_account_id", "amount", "status", "created_at", "idempotency_key")
VALUES (5, 3, 4, 1, 'test', '2026-02-01T09:00:00Z', 'idem-pk-test');

-- 8. transfer unique. Expected: uq_transfer_0, SQLSTATE 23505.
INSERT INTO portfolio."transfer" ("transfer_id", "from_account_id", "to_account_id", "amount", "status", "created_at", "idempotency_key")
VALUES (105, 3, 4, 1, 'test', '2026-02-01T09:00:00Z', 'idem-1001');

-- 9. transfer from fk. Expected: fk_transfer_0, SQLSTATE 23503.
INSERT INTO portfolio."transfer" ("transfer_id", "from_account_id", "to_account_id", "amount", "status", "created_at", "idempotency_key")
VALUES (106, 900002, 4, 1, 'test', '2026-02-01T09:00:00Z', 'idem-from-fk');

-- 10. transfer to fk. Expected: fk_transfer_1, SQLSTATE 23503.
INSERT INTO portfolio."transfer" ("transfer_id", "from_account_id", "to_account_id", "amount", "status", "created_at", "idempotency_key")
VALUES (107, 3, 900003, 1, 'test', '2026-02-01T09:00:00Z', 'idem-to-fk');

-- 11. account balance check. Expected: account_balance_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_number", "currency", "balance", "opened_on")
VALUES (108, 1, 'ACCT-2003', 'USD', -1, '2026-02-01');

-- 12. transfer amount check. Expected: transfer_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."transfer" ("transfer_id", "from_account_id", "to_account_id", "amount", "status", "created_at", "idempotency_key")
VALUES (109, 3, 4, 0, 'test', '2026-02-01T09:00:00Z', 'idem-amount-check');
