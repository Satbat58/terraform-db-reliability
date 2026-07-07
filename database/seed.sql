---------------------------------------------------------
-- Generate 100 Hotel Bookings
---------------------------------------------------------

INSERT INTO hotel_bookings
(
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)

SELECT

gen_random_uuid(),

'HTL-' || gs,

(
ARRAY[
'delhi',
'mumbai',
'bangalore',
'hyderabad',
'chennai',
'pune'
]
)[floor(random()*6+1)],

CURRENT_DATE + (random()*20)::INT,

CURRENT_DATE + ((random()*20)::INT + 3),

ROUND((1000 + random()*9000)::numeric,2),

(
ARRAY[
'BOOKED',
'COMPLETED',
'CANCELLED',
'PENDING'
]
)[floor(random()*4+1)],

NOW() - ((random()*60)::INT || ' days')::INTERVAL

FROM generate_series(1,100) gs;

---------------------------------------------------------
-- Generate Booking Events
---------------------------------------------------------

INSERT INTO booking_events
(
    booking_id,
    event_type,
    payload,
    created_at
)

SELECT

id,

(
ARRAY[
'BOOKED',
'PAYMENT_SUCCESS',
'CHECKIN',
'CHECKOUT',
'CANCELLED'
]
)[floor(random()*5+1)],

jsonb_build_object(

'source','seed-script',

'remarks','Automatically generated'

),

created_at

FROM hotel_bookings

LIMIT 60;