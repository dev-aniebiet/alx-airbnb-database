-- Index on the 'bookings' table for foreign keys.
-- These columns are frequently used to join bookings with users and properties.

CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);

-- Index on the 'properties' table for the host and price.
-- 'host_id' is used for joining, and 'price_per_night' is likely to be used in filtering and sorting.

CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_properties_price_per_night ON properties(price_per_night);

-- Index on the 'users' table for email and last name.
-- 'email' is often used for lookups, and 'last_name' is commonly used in searches.
-- Additionally, indexing 'id' for faster primary key lookups.

CREATE INDEX idx_users_id ON users(id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_first_name ON users(first_name);
CREATE INDEX idx_users_last_name ON users(last_name);

-- --- Measuring Query Performance ---
-- using Query: Ranking properties by booking count:

-- Before indexes:
EXPLAIN ANALYZE
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
    RANK() OVER (ORDER BY booking_count DESC) AS property_rank
FROM
    PropertyBookings;
