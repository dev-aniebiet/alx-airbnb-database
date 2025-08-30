# Seed the Database with Sample Data

This directory contains SQL scripts to populate the database with initial sample data for the Airbnb clone project. The scripts are designed to insert data into the tables created by the schema definition scripts.

## Files

- `seed.sql`: This script contains SQL commands to insert sample data into the users, properties, bookings, payments, reviews, and messages tables. Ensure the sample data reflects real-world usage (e.g., multiple users, bookings, payments, reviews, and messages).

## Usage

To execute the seed script, run the following command in your SQL environment:

```sql
\i alx-airbnb-database/database-script-0x02/seed.sql
```

## Note

- Ensure that the database schema has been created before running the seed script.
- Modify the sample data as needed to fit specific testing or development requirements.
