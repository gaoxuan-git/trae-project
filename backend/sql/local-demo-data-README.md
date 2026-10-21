# Local Demo Data

`local-demo-data.sql` adds realistic development data to the local
`dexter_dianshang` database without removing existing business rows.

## Included data

- 24 products with local images, two SKUs, descriptions and stock
- 20 users, 25 addresses, 60 account records and 900 visit records
- 80 orders covering unpaid, shipping, received, completed and refunded states
- 32 product reviews, 5 coupons and 50 coupon ownership records
- 4 seckill, 3 group-buy and 3 bargain activities
- 6 articles and 45 days of trade/product statistics

All product and article images are existing local files under
`backend/crmebimage`. The development image service must be available at
`http://127.0.0.1:8080`.

## Import

Run from the repository root:

```bash
mysql -uroot -p123456 dexter_dianshang < backend/sql/local-demo-data.sql
redis-cli -n 10 FLUSHDB
```

The script is idempotent. It replaces only records owned by
`DEMO-SEED-V1`, using `demo-seed-v1` on products and `[DEMO-SEED-V1]` on
users and orders. Existing rows are retained.

## Backup and restore

Create a backup before importing:

```bash
mysqldump -uroot -p123456 --single-transaction \
  --set-gtid-purged=OFF dexter_dianshang > /tmp/dexter_dianshang.sql
```

Restore when needed:

```bash
mysql -uroot -p123456 dexter_dianshang < /tmp/dexter_dianshang.sql
redis-cli -n 10 FLUSHDB
```
