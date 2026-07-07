#!/bin/bash

echo ""

echo "==============================="
echo "Hotel Bookings"
echo "==============================="

docker exec hotel-postgres \
psql \
-U postgres \
-d hotel \
-c "
SELECT COUNT(*) AS total_bookings
FROM hotel_bookings;
"

echo ""

echo "==============================="
echo "Booking Events"
echo "==============================="

docker exec hotel-postgres \
psql \
-U postgres \
-d hotel \
-c "
SELECT COUNT(*) AS total_events
FROM booking_events;
"

echo ""

echo "==============================="
echo "Bookings by City"
echo "==============================="

docker exec hotel-postgres \
psql \
-U postgres \
-d hotel \
-c "
SELECT city,
       COUNT(*) AS total
FROM hotel_bookings
GROUP BY city
ORDER BY city;
"

echo ""

echo "==============================="
echo "Bookings by Status"
echo "==============================="

docker exec hotel-postgres \
psql \
-U postgres \
-d hotel \
-c "
SELECT status,
       COUNT(*) AS total
FROM hotel_bookings
GROUP BY status
ORDER BY status;
"

echo ""

echo "==============================="
echo "Bookings by Organization"
echo "==============================="

docker exec hotel-postgres \
psql \
-U postgres \
-d hotel \
-c "
SELECT org_id,
       COUNT(*) AS total
FROM hotel_bookings
GROUP BY org_id;
"

echo ""

echo "==============================="
echo "Optimized Query"
echo "==============================="

docker exec hotel-postgres \
psql \
-U postgres \
-d hotel \
-c "
SELECT
    org_id,
    status,
    COUNT(*) AS bookings,
    SUM(amount) AS total_amount
FROM hotel_bookings
WHERE city='delhi'
AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id,status;
"