-- Initial Complex Query
-- This query retrieves all bookings along with the full details of the user who booked,
-- the property that was booked, and the payment information.
SELECT b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    p.first_name,
    p.last_name,
    u.email,
    p.name AS property_name,
    p.description,
    pay.payment_method,
    pay.payment_date
FROM bookings b
    JOIN profile AS p ON b.user_id = p.user_id
    JOIN users AS u ON b.user_id = u.user_id
    JOIN payments AS pay ON b.booking_id = pay.booking_id
    JOIN properties AS p ON b.property_id = p.property_id;
-- Performance Analysis
-- To analyze this query, you would run `EXPLAIN ANALYZE [QUERY]` in PostgreSQL.
-- Potential Inefficiencies without Indexes:
--   - Sequential Scans: The database would have to read every single row from all four tables ('bookings', 'profile', 'properties', 'payments') to find the matching records for the JOINs. This is very slow, especially on large tables.
--   - High Join Cost: The database would perform costly join operations (like Nested Loop or Hash Joins) on the full, un-indexed tables, leading to high CPU and memory usage.
--   - The query plan would show high 'cost' and 'time' estimates for each operation.
-- 3. Refactored Query for Improved Performance
-- The structure of the query is correct for the data it needs to retrieve. The performance improvement
-- doesn't come from changing the query itself, but from ensuring the database can execute it efficiently
-- using the indexes we created in 'database_index.sql'.
-- This "refactored" approach relies on the presence of those indexes.
-- When the indexes `idx_bookings_user_id`, `idx_bookings_property_id`, and an index on `payments(booking_id)` exist,
-- the database query planner will automatically choose a much more efficient execution plan.
-- How Indexes Improve This Query:
--   - Index Scans: Instead of reading the entire table, the database can use the B-tree structure of the indexes to quickly find the exact rows needed for the joins. For example, when joining `bookings` and `profile`, it can use `idx_bookings_user_id` to instantly locate the relevant bookings for a user.
--   - Lower Join Cost: With indexes, the database can use more efficient join algorithms (like Index Nested Loop Joins), significantly reducing the execution time.
-- To confirm the improvement, run EXPLAIN ANALYZE on the same query after creating the indexes.
-- You should see the plan change from 'Seq Scan' to 'Index Scan' on the join columns,
-- and the total execution time will be much lower.
EXPLAIN ANALYZE
SELECT b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    p.first_name,
    p.last_name,
    u.email,
    p.name AS property_name,
    p.description,
    pay.payment_method,
    pay.payment_date
FROM bookings b
    JOIN profile AS p ON b.user_id = p.user_id
    JOIN users AS u ON b.user_id = u.user_id
    JOIN payments AS pay ON b.booking_id = pay.booking_id
    JOIN properties AS p ON b.property_id = p.property_id;