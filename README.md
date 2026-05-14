# ASP.NET Core MVC + MS SQL Server Deployment Using Docker

## Project Overview

This project demonstrates how to deploy an ASP.NET Core MVC application with Microsoft SQL Server using Docker containers.

The setup includes:

* ASP.NET Core MVC Application
* Microsoft SQL Server 2022
* Docker Networking
* Automated deployment scripts
* Dynamic public URL generation
* Database and SQL user auto creation

---

# Architecture

```text
Browser
   |
   v
ASP.NET Core MVC Container
   |
Docker Network
   |
MS SQL Server Container
```

---

# Prerequisites

* Ubuntu Server
* Docker Installed
* .NET 8 SDK Installed
* Internet Connection

Required Open Ports:

* 8080
* 1433

---

# Connect to VM

```text
ssh lab-user@Your-Server-IP
```

---

# Step 1: Verify Docker

```bash
docker --version

docker ps
```

---

# Step 2: Install .NET 8 SDK

```bash
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

sudo dpkg -i packages-microsoft-prod.deb

rm packages-microsoft-prod.deb

sudo apt update

sudo apt install -y dotnet-sdk-8.0
```

Verify:

```bash
dotnet --version
```

---

# Step 3: Clone Repository

```bash
git clone https://github.com/shubhsalunke/ASP.NET-MVC-MSSQL-Server.git

cd ASP.NET-MVC-MSSQL-Server
```

---

# Step 4: Verify Project Structure

```bash
ls
```

Expected:

```text
ops  src  Dockerfile  sample.env
```

---

# Step 5: Create ASP.NET Core MVC Application

```bash
cd src

dotnet new mvc -n WebApp

cd ..
```

---

# Step 6: Install MS SQL Packages

```bash
cd src/WebApp
```

Install Entity Framework SQL Server Package:

```bash
dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 8.0.0
```

Install Entity Framework Tools:

```bash
dotnet add package Microsoft.EntityFrameworkCore.Tools --version 8.0.0
```

Restore Packages:

```bash
dotnet restore
```

Build Application:

```bash
dotnet build
```

Back to root directory:

```bash
cd ../..
```

---

# Step 7: Create Environment File

Copy sample environment file:

```bash
cp sample.env .env
```

Open `.env` file:

```bash
nano .env
```

Add:

```env
APP_NAME=dotnet-mvc-app

APP_PORT=8080

MSSQL_CONTAINER=mssql-db

MSSQL_PORT=1433

MSSQL_DATABASE=AppDB

MSSQL_USER=appuser

MSSQL_PASSWORD=YourStrong@Pass123

APP_DB_PASSWORD=StrongPass123$
```

Save file.

---

# Step 9: Give Execute Permission

```bash
chmod +x ops/create.sh

chmod +x ops/delete.sh
```

---

# Step 10: Deploy Application

```bash
bash ops/create.sh
```

---

# Step 11: Verify Running Containers

```bash
docker ps
```

Expected containers:

```text
dotnet-mvc-app
mssql-db
```

---

# Step 12: Access Application

Open browser:

```text
http://Your-Server-IP:8080
```

---

# Step 13: Connect to MS SQL Server

```bash
docker exec -it mssql-db /opt/mssql-tools18/bin/sqlcmd \
-S localhost \
-U sa \
-P 'YourStrong@Pass123' \
-C
```

---

# Step 14: Verify Database

```sql
SELECT name FROM sys.databases;
GO
```

Expected output:

```text
AppDB
```

---

# Step 15: Verify SQL User

```sql
SELECT name FROM sys.sql_logins;
GO
```

Expected output:

```text
appuser
```

---

# Step 16: Database Credentials

| Parameter | Value          |
| --------- | -------------- |
| Database  | AppDB          |
| Username  | appuser        |
| Password  | StrongPass123$ |

---

# Step 17: Exit MSSQL

```sql
EXIT
```

---

# Step 18: Stop Application

```bash
bash ops/delete.sh
```

---

# Project Structure

```text
ASP.NET-MVC-MSSQL-Server/
│
├── .env
├── Dockerfile
├── sample.env
│
├── ops/
│   ├── create.sh
│   └── delete.sh
│
└── src/
    └── WebApp/
```

---

# Technologies Used

* ASP.NET Core MVC
* Microsoft SQL Server 2022
* Docker
* Linux Ubuntu
* Bash Scripting

---

# Features

* Automated MS SQL Server deployment
* Automated database creation
* Automated SQL login creation
* Dockerized ASP.NET Core MVC deployment
* Dynamic public URL generation
* Reusable deployment scripts
* Clean container removal

---

# Useful Commands

Check Containers:

```bash
docker ps
```

Check Logs:

```bash
docker logs mssql-db

docker logs dotnet-mvc-app
```

Restart Application:

```bash
bash ops/delete.sh

bash ops/create.sh
```

Cleanup Volumes:

```bash
docker volume prune -f
```

---

# Final Result

Successfully deployed:

* ASP.NET Core MVC Application
* Microsoft SQL Server 2022
* Dockerized Infrastructure
* Automated Deployment Scripts
* Dynamic Public Access URL

Application URL:

```text
http://Your-Server-IP:8080
```
