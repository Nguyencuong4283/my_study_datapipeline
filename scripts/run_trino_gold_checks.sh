#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Setup Trino gold schema and tables"
docker exec -i trino trino < "${PROJECT_ROOT}/sql/ddl/create_trino_gold_schema.sql"
docker exec -i trino trino < "${PROJECT_ROOT}/sql/ddl/create_trino_gold_tables.sql"
docker exec -i trino trino < "${PROJECT_ROOT}/sql/queries/sync_trino_gold_partitions.sql"

echo "==> Show tables in hive.analytics"
docker exec trino trino --execute "SHOW TABLES FROM hive.analytics"

echo
echo "==> Count rows from gold tables"
docker exec trino trino --execute "SELECT COUNT(*) FROM hive.analytics.daily_sales_gold"
docker exec trino trino --execute "SELECT COUNT(*) FROM hive.analytics.category_sales_gold"
docker exec trino trino --execute "SELECT COUNT(*) FROM hive.analytics.customer_ltv_gold"
