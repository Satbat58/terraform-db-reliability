#!/bin/bash

set -e

BACKUP_DIR="./backups"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP_FILE="$BACKUP_DIR/hotel_$TIMESTAMP.sql"

mkdir -p "$BACKUP_DIR"

echo "Creating database backup..."

docker exec hotel-postgres \
pg_dump \
-U postgres \
-d hotel \
> "$BACKUP_FILE"

echo ""

echo "Backup completed successfully."

echo "Backup File : $BACKUP_FILE"