-- Show related account, customer records (up to 20).
SELECT t0."account_id" AS "account_account_id",
       t0."account_number" AS "account_account_number",
       t1."customer_id" AS "customer_customer_id",
       t1."full_name" AS "customer_full_name"
FROM portfolio."account" t0
JOIN portfolio."customer" t1 ON t0."customer_id" = t1."customer_id"
ORDER BY t0."account_id", t1."customer_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."account_id" AS "account_account_id",
       t0."account_number" AS "account_account_number",
       t1."customer_id" AS "customer_customer_id",
       t1."full_name" AS "customer_full_name"
FROM portfolio."account" t0
JOIN portfolio."customer" t1 ON t0."customer_id" = t1."customer_id"
ORDER BY t0."account_id", t1."customer_id"
LIMIT 20;

-- Find transfer records where status matches "settled" (up to 20).
SELECT * FROM portfolio."transfer"
WHERE "status" IS NOT DISTINCT FROM 'settled'
ORDER BY "transfer_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."transfer"
WHERE "status" IS NOT DISTINCT FROM 'settled'
ORDER BY "transfer_id"
LIMIT 20;

-- Count transfer records for each from_account_id (up to 20 groups).
SELECT "from_account_id", count(*) AS record_count
FROM portfolio."transfer"
GROUP BY "from_account_id"
ORDER BY record_count DESC, "from_account_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "from_account_id", count(*) AS record_count
FROM portfolio."transfer"
GROUP BY "from_account_id"
ORDER BY record_count DESC, "from_account_id" NULLS LAST
LIMIT 20;

-- Find transfer records where status matches "settled" (up to 20).
SELECT * FROM portfolio."transfer"
WHERE "status" IS NOT DISTINCT FROM 'settled'
ORDER BY "transfer_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."transfer"
WHERE "status" IS NOT DISTINCT FROM 'settled'
ORDER BY "transfer_id"
LIMIT 20;
