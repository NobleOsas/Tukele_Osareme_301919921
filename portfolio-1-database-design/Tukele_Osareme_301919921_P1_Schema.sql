-- MIT 8103: Bank / Fintech Platform: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customer" (
  "customer_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_customer" PRIMARY KEY ("customer_id"),
  CONSTRAINT "uq_customer_0" UNIQUE ("email")
);
CREATE TABLE portfolio."account" (
  "account_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "account_number" text NOT NULL,
  "currency" text NOT NULL,
  "balance" numeric(18,2) NOT NULL,
  "opened_on" date NOT NULL,
  CONSTRAINT "pk_account" PRIMARY KEY ("account_id"),
  CONSTRAINT "uq_account_0" UNIQUE ("account_number")
);
CREATE TABLE portfolio."transfer" (
  "transfer_id" bigint NOT NULL,
  "from_account_id" bigint NOT NULL,
  "to_account_id" bigint NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "status" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  "idempotency_key" text NOT NULL,
  CONSTRAINT "pk_transfer" PRIMARY KEY ("transfer_id"),
  CONSTRAINT "uq_transfer_0" UNIQUE ("idempotency_key")
);
ALTER TABLE portfolio."account" ADD CONSTRAINT "fk_account_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customer" ("customer_id");
ALTER TABLE portfolio."transfer" ADD CONSTRAINT "fk_transfer_0" FOREIGN KEY ("from_account_id") REFERENCES portfolio."account" ("account_id");
ALTER TABLE portfolio."transfer" ADD CONSTRAINT "fk_transfer_1" FOREIGN KEY ("to_account_id") REFERENCES portfolio."account" ("account_id");
ALTER TABLE portfolio."account" ADD CONSTRAINT "account_balance_nonnegative" CHECK ("balance" >= 0);
ALTER TABLE portfolio."transfer" ADD CONSTRAINT "transfer_amount_positive" CHECK ("amount" > 0);
COMMIT;
