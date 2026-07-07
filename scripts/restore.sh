#!/bin/bash

set -e

BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage:"
    echo "./scripts/restore.sh backups/<backup-file>.sql"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Backup file not found."
    exit 1
fi

echo "Dropping existing database..."

docker exec hotel-postgres \
psql \
-U postgres \
-c "DROP DATABASE IF EXISTS hotel_restore;"

echo "Creating fresh database..."

docker exec hotel-postgres \
psql \
-U postgres \
-c "CREATE DATABASE hotel_restore;"

echo "Restoring backup..."

cat "$BACKUP_FILE" | docker exec -i hotel-postgres \
psql \
-U postgres \
-d hotel_restore

echo ""

echo "Restore completed successfully."

echo "Database restored as : hotel_restore"