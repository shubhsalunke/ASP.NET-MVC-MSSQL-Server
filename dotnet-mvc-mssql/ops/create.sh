#!/bin/bash

source "$(dirname "$0")/../.env"

echo "Creating Docker network..."
docker network create dotnet-network 2>/dev/null || true

echo "Removing old MSSQL container..."
docker rm -f "$MSSQL_CONTAINER" 2>/dev/null || true

echo "Starting MSSQL container..."
docker run -d \
  --name "$MSSQL_CONTAINER" \
  --network dotnet-network \
  -e ACCEPT_EULA=Y \
  -e SA_PASSWORD="$MSSQL_PASSWORD" \
  -p "$MSSQL_PORT":1433 \
  mcr.microsoft.com/mssql/server:2022-latest

echo "Waiting MSSQL Server to start..."
sleep 40

echo "Creating database and database user..."

docker exec -i "$MSSQL_CONTAINER" /opt/mssql-tools18/bin/sqlcmd \
-S localhost \
-U sa \
-P "$MSSQL_PASSWORD" \
-C <<EOF
IF DB_ID('$MSSQL_DATABASE') IS NULL
BEGIN
    CREATE DATABASE [$MSSQL_DATABASE];
END
GO

USE [$MSSQL_DATABASE];
GO

IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name = '$MSSQL_USER')
BEGIN
    CREATE LOGIN [$MSSQL_USER]
    WITH PASSWORD = 'StrongPass123$';
END
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = '$MSSQL_USER')
BEGIN
    CREATE USER [$MSSQL_USER]
    FOR LOGIN [$MSSQL_USER];
END
GO

ALTER ROLE db_owner ADD MEMBER [$MSSQL_USER];
GO

SELECT name FROM sys.sql_logins;
GO
EOF

echo "Building ASP.NET MVC image..."
docker build -t "$APP_NAME" .

echo "Removing old ASP.NET container..."
docker rm -f "$APP_NAME" 2>/dev/null || true

echo "Starting ASP.NET MVC application..."
docker run -d \
  --name "$APP_NAME" \
  --network dotnet-network \
  -p "$APP_PORT":8080 \
  "$APP_NAME"

echo "Application Started Successfully"

SERVER_IP=$(curl -s ifconfig.me)

echo "Application URL:"
echo "http://$SERVER_IP:$APP_PORT"
