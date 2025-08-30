-- SQL Scripts to seed the database with initial data for the Airbnb clone project.
-- Insert sample users
INSERT INTO users (
        user_id,
        first_name,
        last_name,
        email,
        password_hash,
        phone_number,
        role,
        created_at
    )
VALUES (
        gen_random_uuid(),
        'Alice',
        'Johnson',
        'alice.johnson@email.com',
        'hashed_password1',
        '123-456-7890',
        'host',
        CURRENT_TIMESTAMP
    ),
    (
        gen_random_uuid(),
        'Bob',
        'Smith',
        'bob.smith@email.com',
        'hashed_password2',
        '234-567-8901',
        'guest',
        CURRENT_TIMESTAMP
    ),
    (
        gen_random_uuid(),
        'Charlie',
        'Brown',
        'charlie.brown@email.com',
        'hashed_password3',
        '345-678-9012',
        'guest',
        CURRENT_TIMESTAMP
    );
(
    gen_random_uuid(),
    'Diana',
    'Prince',
    'diana.prince@email.com',
    'hashed_password4',
    '456-789-0123',
    'admin',
    CURRENT_TIMESTAMP
);
-- Insert sample properties
INSERT INTO properties (
        property_id,
        host_id,
        name,
        description,
        location,
        price_per_night,
        created_at,
        updated_at
    )
VALUES (
        gen_random_uuid(),
        (
            SELECT user_id
            FROM users
            WHERE email = 'alice.john@email.com'
        ),
        'Cozy Cottage',
        'A cozy cottage in the countryside.',
        '123 Country Lane, Countryside',
        120.00,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    ),
    (
        gen_random_uuid(),
        (
            SELECT user_id
            FROM users
            WHERE email = 'alice.john@email.com'
        ),
        'Modern Apartment',
        'A modern apartment in the city center.',
        '456 City St, Metropolis',
        200.00,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    ),
    (
        gen_random_uuid(),
        (
            SELECT user_id
            FROM users
            WHERE email = 'diana.prince@email.com'
        ),
        'Beachfront Villa',
        'A luxurious villa with a beachfront view.',
        '789 Ocean Drive, Beach City',
        350.00,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    );
-- Insert sample bookings
INSERT INTO bookings (
        booking_id,
        property_id,
        user_id,
        start_date,
        end_date,
        total_price,
        status,
        created_at
    )
VALUES (
        gen_random_uuid(),
        (
            SELECT property_id
            FROM properties
            WHERE name = 'Cozy Cottage'
        ),
        (
            SELECT user_id
            FROM users
            WHERE email = 'alice.john@email.com'
        ),
        '2024-07-01',
        '2024-07-05',
        480.00,
        'confirmed',
        CURRENT_TIMESTAMP
    ),
    (
        gen_random_uuid(),
        (
            SELECT property_id
            FROM properties
            WHERE name = 'Modern Apartment'
        ),
        (
            SELECT user_id
            FROM users
            WHERE email = 'bob.smith@email.com'
        ),
        '2024-08-10',
        '2024-08-15',
        1000.00,
        'pending',
        CURRENT_TIMESTAMP
    ),
    (
        gen_random_uuid(),
        (
            SELECT property_id
            FROM properties
            WHERE name = 'Beachfront Villa'
        ),
        (
            SELECT user_id
            FROM users
            WHERE email = 'bob.smith@email.com'
        ),
        '2024-09-01',
        '2024-09-07',
        2100.00,
        'cancelled',
        CURRENT_TIMESTAMP
    );
-- Insert sample payments
INSERT INTO payments (
        payment_id,
        booking_id,
        amount,
        payment_method,
        payment_status,
        payment_date
    )
VALUES (
        gen_random_uuid(),
        (
            SELECT booking_id
            FROM bookings
            WHERE status = 'confirmed'
            LIMIT 1
        ), 480.00, 'credit_card', 'completed', CURRENT_TIMESTAMP
    ),
    (
        gen_random_uuid(),
        (
            SELECT booking_id
            FROM bookings
            WHERE status = 'pending'
            LIMIT 1
        ), 1000.00, 'paypal', 'pending', CURRENT_TIMESTAMP
    ),
    (
        gen_random_uuid(),
        (
            SELECT booking_id
            FROM bookings
            WHERE status = 'cancelled'
            LIMIT 1
        ), 2100.00, 'stripe', 'failed', CURRENT_TIMESTAMP
    );
-- Insert sample reviews
INSERT INTO reviews (
        review_id,
        property_id,
        user_id,
        rating,
        comment,
        created_at
    )
VALUES (
        gen_random_uuid(),
        (
            SELECT property_id
            FROM properties
            WHERE name = 'Cozy Cottage'
        ),
        (
            SELECT user_id
            FROM users
            WHERE email = 'bob.smith@email.com'
        ),
        5,
        'Amazing stay! The cottage was cozy and the host was very welcoming.',
        CURRENT_TIMESTAMP
    ),
    (
        gen_random_uuid(),
        (
            SELECT property_id
            FROM properties
            WHERE name = 'Modern Apartment'
        ),
        (
            SELECT user_id
            FROM users
            WHERE email = 'jane.doe@email.com'
        ),
        4,
        'Great location and modern amenities. Would stay again!',
        CURRENT_TIMESTAMP
    ),
    (
        gen_random_uuid(),
        (
            SELECT property_id
            FROM properties
            WHERE name = 'Beachfront Villa'
        ),
        (
            SELECT user_id
            FROM users
            WHERE email = 'john.doe@email.com'
        ),
        3,
        'Beautiful view but the service could be improved.',
        CURRENT_TIMESTAMP
    );
-- Insert sample messages
INSERT INTO messages (
        message_id,
        sender_id,
        recipient_id,
        message_body,
        sent_at
    )
VALUES (
        gen_random_uuid(),
        (
            SELECT user_id
            FROM users
            WHERE email = 'bob.smith@email.com'
        ),
        (
            SELECT user_id
            FROM users
            WHERE email = 'jane.smith@email.com'
        ),
        'Hi Jane, I am interested in booking your apartment for next month. Is it available?',
        CURRENT_TIMESTAMP
    ),
    (
        gen_random_uuid(),
        (
            SELECT user_id
            FROM users
            WHERE email = 'alice.john@email.com'
        ),
        (
            SELECT user_id
            FROM users
            WHERE email = 'stacy.ron@email.com'
        ),
        'Hello Stacy, thank you for your inquiry. The cottage is available for your requested dates.',
        CURRENT_TIMESTAMP
    ),
    (
        gen_random_uuid(),
        (
            SELECT user_id
            FROM users
            WHERE email = 'john.doe@email.com'
        ),
        (
            SELECT user_id
            FROM users
            WHERE email = 'samuel.ed@email.com'
        ),
        'Hey Samuel, just wanted to check in and see how your stay at the villa was.',
        CURRENT_TIMESTAMP
    );