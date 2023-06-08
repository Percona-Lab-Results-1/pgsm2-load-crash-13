#!/bin/bash

# Set the database connection parameters
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="your_database"
DB_USER="your_username"
DB_PASSWORD="your_password"

# Set the sysbench parameters
SYSBENCH_THREADS=10
SYSBENCH_TRANSACTIONS=10000
SYSBENCH_DURATION=300

# Set the crash parameters
CRASH_DURATION=60

# Function to simulate a crash
simulate_crash() {
    echo "Simulating crash..."
    pkill -f postgres
    sleep $CRASH_DURATION
    echo "Restarting PostgreSQL..."
    sudo systemctl start postgresql
}

# Load test for PostgreSQL 13
echo "Running load test for PostgreSQL 13..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS pg_stat_monitor;"
sysbench --threads=$SYSBENCH_THREADS --time=$SYSBENCH_DURATION --db-driver=pgsql --pgsql-host=$DB_HOST --pgsql-port=$DB_PORT --pgsql-db=$DB_NAME --pgsql-user=$DB_USER --pgsql-password=$DB_PASSWORD --pgsql-ignore-errors=ALL --pgsql-use-query="SELECT 1;" --pgsql-use-prepared-stmt=0 oltp_read_only run
simulate_crash

echo "Load tests completed."

