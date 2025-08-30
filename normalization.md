# Database Normalization Analysis

## Current Schema Analysis

The current schema is mostly well-normalized, but there are a few areas that need attention to achieve proper 3NF.

### Normalization Violations Identified:

1. **First Normal Form (1NF)** - ✅ PASSED:

   - All tables appear to have atomic columns, so 1NF is satisfied.
   - No repeating groups.
   - Each table has a primary key.

2. **Second Normal Form (2NF)** - ✅ MOSTLY PASSED:

   - All entities have a single-column primary key.
   - No partial dependencies on composite keys.
   - `location` in the `properties` table is not fully dependent on the primary key `property_id`. It can be broken down into `city`, `state`, and `country` for better clarity and to avoid redundancy.

3. **Third Normal Form (3NF)** - ❌ FAILED:
   - The `users` table mixes personal information with authentication details, which can lead to redundancy and update anomalies.
   - The `properties` table has a transitive dependency where `location` can be further decomposed.
   - The `payments` table has a transitive dependency where `amount` can be derived from `booking_id` and `payment_date`.
   - The `reviews` table has a transitive dependency where `rating` can be derived from `property_id` and `user_id`.

### Suggested Changes to Achieve 3NF:

1. **Users Table**:
   - Split into two tables: `profile` (user_id, first_name, last_name, email, phone number) and `authentication` (user_id, password_hash, created_at, updated_at).
2. **Properties Table**:
   - Decompose `location` into separate fields: `city`, `state`, `country`.
3. **Payments Table**:
   - Remove `amount` and derive it from `booking_id` and `payment_date`.
4. **Reviews Table**:
   - Remove `rating` and derive it from `property_id` and `user_id`.

### Revised Schema:

```sql
-- Profile Table
CREATE TABLE profile (
    user_id UUID PRIMARY KEY DEFAULT REFERENCES UserAuthentication(user_id) ON DELETE CASCADE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Authentication Table
CREATE TABLE UserAuthentication (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('guest', 'host', 'admin') DEFAULT 'guest',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES profile(user_id) ON DELETE CASCADE
);
-- Properties Table
CREATE TABLE properties (
    property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profile(user_id) ON DELETE CASCADE,
    host_id UUID REFERENCES profile(user_id) ON DELETE CASCADE,
    location_id UUID REFERENCES location(location_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price_per_night DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Location Table
CREATE TABLE location (
    location_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    longitude DECIMAL(9, 6),
    latitude DECIMAL(9, 6),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Payments Table
CREATE TABLE payments (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID REFERENCES bookings(booking_id) ON DELETE CASCADE,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Reviews Table
CREATE TABLE reviews (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID REFERENCES properties(property_id) ON DELETE CASCADE,
    user_id UUID REFERENCES profile(user_id) ON DELETE CASCADE,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```sql
-- Create View for Booking with Total Price
CREATE VIEW booking_with_total AS
SELECT
    b.*,
    ROUND(p.price_per_night * DATEDIFF(b.end_date, b.start_date), 2) AS total_price
FROM booking b
JOIN property p ON b.property_id = p.property_id;

-- Create view for complete user information
CREATE VIEW user_complete AS
SELECT
    ua.user_id,
    ua.email,
    ua.role,
    ua.created_at AS registered_at,
    up.first_name,
    up.last_name,
    up.phone_number,
    up.updated_at AS profile_updated_at
FROM user_auth ua
LEFT JOIN user_profile up ON ua.user_id = up.user_id;

-- Create view for property with location details
CREATE VIEW property_with_location AS
SELECT
    p.*,
    l.street_address,
    l.city,
    l.state,
    l.country,
    l.postal_code,
    l.latitude,
    l.longitude
FROM property p
JOIN location l ON p.location_id = l.location_id;
```
