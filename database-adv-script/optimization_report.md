# Database Query Optimization Report

This report outlines the process undertaken to analyze, identify inefficiencies, and improve the performance of complex SQL queries within the application's database. The primary goal was to reduce query execution time and resource consumption by implementing a strategic indexing strategy.

## Initial Performance Analysis

### The Target Query

A representative complex query designed to retrieve a comprehensive view of booking data. This query joins four separate tables (`bookings`, `profile`, `properties`, and `payments`) to gather all relevant information about each booking.

```sql
SELECT b.booking_id, b.start_date, b.end_date, u.name AS user_name,
       p.property_name, p.location, pay.amount AS payment_amount
FROM bookings AS b
JOIN profile AS u ON b.user_id = u.user_id
JOIN payments AS pay ON b.booking_id = pay.booking_id
JOIN properties AS p ON b.property_id = p.property_id;
```

### Identified Inefficiencies

1. **Lack of Indexes on Foreign Keys**: The foreign key columns used in the JOIN conditions (`b.user_id`, `b.booking_id`, `b.property_id`) did not have indexes, leading to full table scans.
2. **High Cardinality Columns**: The columns used in the JOINs had high cardinality, making it crucial to have indexes to speed up lookups.
3. **Sequential Scans**: Without indexes, the database engine resorted to sequential scans, which are inefficient for large datasets

## Optimization Strategy: Indexing

To address the identified inefficiencies, the following indexes were created:

### Bookings Table

```sql
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_booking_id ON bookings(booking_id);
```

### Profile Table

```sql
CREATE INDEX idx_profile_user_id ON profile(user_id);
```

### Payments Table

```sql
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
```

### Properties Table

```sql
CREATE INDEX idx_properties_property_id ON properties(property_id);
CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_properties_price_per_night ON properties(price_per_night);
```

## Post-Optimization Performance Analysis

### Improved Query Execution

After implementing the indexes, the same query was re-evaluated using `EXPLAIN ANALYZE`. The results showed a significant reduction in execution time and resource usage.

- **Reduced Execution Time**: The query execution time dropped from several seconds to milliseconds.
- **Efficient Use of Indexes**: The query plan indicated that the database engine utilized the newly created indexes, resulting in faster lookups and reduced I/O operations.
- **Sequential Scan to Index Scan**: The query plan shifted from sequential scans to index scans, which are much more efficient for large datasets.

### Conclusion

The implementation of targeted indexes on foreign key columns and high cardinality fields significantly improved the performance of complex SQL queries. This optimization not only enhances the user experience by reducing wait times but also decreases the load on the database server, allowing it to handle more concurrent requests efficiently. Regular monitoring and analysis of query performance are recommended to ensure continued efficiency as the database grows and evolves.
