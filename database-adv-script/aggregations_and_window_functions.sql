-- Aggregation: Find the total number of bookings made by each user.
-- This query joins the 'profile' and 'bookings' tables to link users to their bookings.
-- It then groups the results by user and uses the COUNT function to find the
-- total number of bookings for each user.
SELECT 
    p.user_id,
    p.first_name,
    p.last_name,
    COUNT(b.booking_id) AS total_bookings
FROM
    profile AS p
LEFT JOIN
    bookings AS b ON p.user_id = b.user_id
GROUP BY
    p.user_id,
    p.first_name,
    p.last_name
ORDER BY
    total_bookings DESC;

-- Use a window function RANK to rank properties based on the total number of bookings they have received.
-- This query first uses a Common Table Expression (CTE) called 'PropertyBookings'
-- to count the number of bookings for each property.
-- Then, the main query selects from this CTE and uses the RANK() window function
-- to assign a rank to each property based on its booking count in descending order.

WITH PropertyBookings AS (
    SELECT
        p.property_id,
        p.name AS property_name,
        COUNT(b.booking_id) AS booking_count
    FROM
        properties AS p
    LEFT JOIN
        bookings AS b ON p.property_id = b.property_id
    GROUP BY
        p.property_id, p.name
)
SELECT
    property_name,
    booking_count,
    RANK() OVER (ORDER BY booking_count DESC) AS property_rank,
    ROW_NUMBER() OVER (ORDER BY booking_count DESC) AS unique_rank
FROM PropertyBookings;

