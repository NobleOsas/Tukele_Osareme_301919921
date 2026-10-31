# MIT 8103: Bank / Fintech Platform — SQL queries

## 1. Show related account, customer records (up to 20).

```sql
SELECT t0."account_id" AS "account_account_id",
       t0."account_number" AS "account_account_number",
       t1."customer_id" AS "customer_customer_id",
       t1."full_name" AS "customer_full_name"
FROM portfolio."account" t0
JOIN portfolio."customer" t1 ON t0."customer_id" = t1."customer_id"
ORDER BY t0."account_id", t1."customer_id"
LIMIT 20;
```

| account_account_id | account_account_number | customer_customer_id | customer_full_name |
| --- | --- | --- | --- |
| 3 | ACCT-1001 | 1 | Avery Quinn |
| 4 | ACCT-1002 | 2 | Jordan Lee |

## 2. Find transfer records where status matches "settled" (up to 20).

```sql
SELECT * FROM portfolio."transfer"
WHERE "status" IS NOT DISTINCT FROM 'settled'
ORDER BY "transfer_id"
LIMIT 20;
```

| transfer_id | from_account_id | to_account_id | amount | status | created_at | idempotency_key |
| --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | 4 | 25.5 | settled | 2026-01-14T10:00:00+00:00 | idem-1001 |

## 3. Count transfer records for each from_account_id (up to 20 groups).

```sql
SELECT "from_account_id", count(*) AS record_count
FROM portfolio."transfer"
GROUP BY "from_account_id"
ORDER BY record_count DESC, "from_account_id" NULLS LAST
LIMIT 20;
```

| from_account_id | record_count |
| --- | --- |
| 3 | 1 |
| 4 | 1 |

## 4. Find transfer records where status matches "settled" (up to 20).

```sql
SELECT * FROM portfolio."transfer"
WHERE "status" IS NOT DISTINCT FROM 'settled'
ORDER BY "transfer_id"
LIMIT 20;
```

| transfer_id | from_account_id | to_account_id | amount | status | created_at | idempotency_key |
| --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | 4 | 25.5 | settled | 2026-01-14T10:00:00+00:00 | idem-1001 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.749 | 4.406, 2.703, 2.749 | Sort → Seq Scan | 322 |
| After index | 0.302 | 0.297, 0.302, 0.554 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.749 ms to 0.302 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=4.365..4.369 rows=50 loops=1)
  Seq Scan on transfer (actual time=0.03..4.303 rows=50 loops=1)
Planning Time: 0.535 ms
Execution Time: 4.406 ms
```

### Before index, run 2

```text
Sort (actual time=2.675..2.678 rows=50 loops=1)
  Seq Scan on transfer (actual time=0.021..2.634 rows=50 loops=1)
Planning Time: 0.408 ms
Execution Time: 2.703 ms
```

### Before index, run 3

```text
Sort (actual time=2.718..2.721 rows=50 loops=1)
  Seq Scan on transfer (actual time=0.029..2.667 rows=50 loops=1)
Planning Time: 0.501 ms
Execution Time: 2.749 ms
```

### After index, run 1

```text
Sort (actual time=0.248..0.251 rows=50 loops=1)
  Bitmap Heap Scan on transfer (actual time=0.034..0.205 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=50 loops=1)
Planning Time: 0.653 ms
Execution Time: 0.297 ms
```

### After index, run 2

```text
Sort (actual time=0.253..0.255 rows=50 loops=1)
  Bitmap Heap Scan on transfer (actual time=0.036..0.209 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.018..0.019 rows=50 loops=1)
Planning Time: 0.644 ms
Execution Time: 0.302 ms
```

### After index, run 3

```text
Sort (actual time=0.346..0.351 rows=50 loops=1)
  Bitmap Heap Scan on transfer (actual time=0.043..0.259 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.022..0.022 rows=50 loops=1)
Planning Time: 0.815 ms
Execution Time: 0.554 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Tukele_Osareme_301919921_P2_Queries.sql, then Tukele_Osareme_301919921_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Tukele_Osareme_301919921_P2_QueryResults.png) · [Index comparison](screenshots/Tukele_Osareme_301919921_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

