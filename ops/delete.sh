#!/bin/bash

source "$(dirname "$0")/../.env"

echo "Stopping ASP.NET container..."
docker rm -f $APP_NAME 2>/dev/null || true

echo "Stopping MSSQL container..."
docker rm -f $MSSQL_CONTAINER 2>/dev/null || true

echo "Removing Docker network..."
docker network rm dotnet-network 2>/dev/null || true

echo "Cleanup completed"
