---------------------------------------------------------
-- Composite Index
---------------------------------------------------------

CREATE INDEX idx_booking_city_created_org_status
ON hotel_bookings
(
    city,
    created_at,
    org_id,
    status
);

---------------------------------------------------------
-- Foreign Key Index
---------------------------------------------------------

CREATE INDEX idx_booking_events_booking_id
ON booking_events(booking_id);