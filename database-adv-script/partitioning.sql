-- Create a new partitioned table with the same structure as the original.
-- The 'PARTITION BY RANGE' clause tells PostgreSQL how to distribute the rows.
CREATE TABLE bookings_partitioned (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price NUMERIC(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (start_date);
-- Create partitions for specific date ranges.-- Each partition is a separate table that stores a subset of the data.
-- The database will automatically route data to the correct partition.
-- Here we create partitions for each quarter of 2025 as an example.
CREATE TABLE bookings_2025_q1 PARTITION OF bookings_partitioned FOR
VALUES
FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE bookings_2025_q2 PARTITION OF bookings_partitioned FOR
VALUES
FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE bookings_2025_q3 PARTITION OF bookings_partitioned FOR
VALUES
FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE bookings_2025_q4 PARTITION OF bookings_partitioned FOR
VALUES
FROM ('2025-10-01') TO ('2026-01-01');
-- Copy data, then rename tables.
-- First copy data from the old 'bookings' table
-- into 'bookings_partitioned', then drop the old table and rename the new one.
INSERT INTO bookings_partitioned (
        booking_id,
        property_id,
        user_id,
        start_date,
        end_date,
        total_price,
        status,
        created_at,
        updated_at
    )
SELECT booking_id,
    property_id,
    user_id,
    start_date,
    end_date,
    total_price,
    status,
    created_at,
    updated_at
FROM bookings;
DROP TABLE bookings;
ALTER TABLE bookings_partitioned
    RENAME TO bookings;
-- Create indexes on the partitioned table.
-- Indexes on the parent table will be automatically created on each partition.
CREATE INDEX idx_bookings_property_id ON bookings (property_id);
CREATE INDEX idx_bookings_user_id ON bookings (user_id);
CREATE INDEX idx_bookings_status ON bookings (status);
CREATE INDEX idx_bookings_start_date ON bookings (start_date);
CREATE INDEX idx_bookings_end_date ON bookings (end_date);
CREATE INDEX idx_bookings_created_at ON bookings (created_at);
-- Test query performance.
-- Now, when query is run with a 'start_date' range, the query planner
-- will perform "partition pruning," meaning it will only scan the relevant partitions.
-- Example: Fetching all bookings from February 2025.
-- The database knows it only needs to look inside the 'bookings_2025_q1' partition.
EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE start_date >= '2025-02-01'
    AND start_date < '2025-03-01';