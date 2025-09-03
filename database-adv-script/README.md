# Write Complex Queries with Joins

This directory contains SQL scripts that demonstrate how to write complex queries using various types of joins. The scripts include examples of INNER JOIN, LEFT JOIN, and FULL OUTER JOIN, showcasing how to combine data from multiple tables based on related columns.
Subqueries are also included to illustrate how to nest queries for more advanced data retrieval.
Additionally, the scripts cover aggregation functions and window functions to perform calculations across sets of rows related to the current row.

## Files

- `joins_queries.sql`: This file contains SQL queries that illustrate the use of different join types to retrieve and combine data from multiple tables in a database.
- `subqueries.sql`: This file includes SQL queries that utilize subqueries to perform more complex data retrieval operations.
- `aggregations_and_window_functions.sql`: This file demonstrates the use of aggregation functions (like COUNT) and window functions (like RANK) to perform calculations across sets of rows related to the current row.
- `README.md`: This file provides an overview of the contents of the directory and instructions on how to use the SQL scripts.

## Usage

To execute the SQL queries, you can use a database management tool or command-line interface that supports SQL. For example, if you are using PostgreSQL, you can run the following command in your terminal:

```bash
psql -d your_database -f alx-airbnb-database/database-adv-script/joins_queries.sql
psql -d your_database -f alx-airbnb-database/database-adv-script/subqueries.sql
psql -d your_database -f alx-airbnb-database/database-adv-script/aggregations_and_window_functions.sql
```

## Requirements

- A relational database management system (RDBMS) such as PostgreSQL, MySQL, or SQLite.
- Basic knowledge of SQL and database concepts.
- Tables with related data to perform joins on.
- A database schema that includes tables such as `properties`, `reviews`, and `users` for the provided queries to work correctly.
- Ensure that your database contains the necessary tables and data to execute the queries successfully.
- Adjust the database connection parameters as needed for your environment.
