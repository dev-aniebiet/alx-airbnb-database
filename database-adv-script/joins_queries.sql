-- Write a query using anINNER JOIN to retrieve all bookings and the respective users who made those bookings.
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    p.first_name,
    p.last_name,
    p.phone_number
FROM
    bookings AS b
INNER JOIN
    profile AS p ON b.user_id = p.user_id;

-- Write a query using aLEFT JOIN to retrieve all properties and their reviews, including properties that have no reviews.
SELECT p.property_id,
    p.name AS property_name,
    p.description,
    r.rating,
    r.comment
FROM properties AS p
    LEFT JOIN reviews AS r ON p.property_id = r.property_id
ORDER BY p.property_id;

-- Write a query using a FULL OUTER JOIN to retrieve all users and all bookings,
-- even if the user has no booking or a booking is not linked to a user.
SELECT p.user_id,
    p.first_name,
    p.last_name,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status
FROM profile AS p
    FULL OUTER JOIN bookings AS b ON p.user_id = b.user_id;
