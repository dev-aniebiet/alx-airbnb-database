# Design Database Schema (DDL)

This directory contains scripts to create and manage the database schema (create tables, set constraints) for the Airbnb clone project. The scripts are written in SQL and are intended to be executed in a relational database management system (RDBMS).

## Files

- `create_tables.sql`: This script contains SQL commands to create the necessary tables for the Airbnb clone project, including users, properties, bookings, payments, reviews and messages. It also defines primary keys, foreign keys, and other constraints to ensure data integrity. Create indexes for frequently queried columns to optimize performance.

## Usage

To execute the schema creation script, run the following command in your SQL environment:

```sql
\i alx-airbnb-database/database-script-0x01/schemas.sql
```

## Note

- Ensure that you have the necessary permissions to create tables and set constraints in the database.
- Modify the script as needed to fit specific database requirements or constraints.
- Always back up existing data before running schema modification scripts in a production environment.
- Test the schema in a development environment before deploying to production.
