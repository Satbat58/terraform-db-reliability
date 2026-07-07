# Full Project Structure

```text
terraform-db-reliability/
│
├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── infra/
│   ├── modules/
│   │
│   │   ├── network/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── locals.tf
│   │   │
|   │   │   ├── ecs/
|   │   │   │   ├── main.tf
|   │   │   │   ├── variables.tf
|   │   │   │   ├── outputs.tf
|   │   │   │   └── locals.tf
│   │   │
│   │   └── rds/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       ├── outputs.tf
│   │       └── locals.tf
│   │
│   └── envs/
│       │
│       ├── dev/
│       │   ├── backend.tf
│       │   ├── provider.tf
│       │   ├── versions.tf
│       │   ├── variables.tf
│       │   ├── terraform.tfvars
│       │   ├── locals.tf
│       │   ├── main.tf
│       │   └── outputs.tf
│       │
│       └── prod/
│           ├── backend.tf
│           ├── provider.tf
│           ├── versions.tf
│           ├── variables.tf
│           ├── terraform.tfvars
│           ├── locals.tf
│           ├── main.tf
│           └── outputs.tf
│
├── database/
│   ├── migrations/
│   │   └── 001_create_tables.sql
│   │
│   ├── seeds/
│   │   └── seed.sql
│   │
│   └── indexes.sql
│
├── scripts/
│   ├── backup.sh
│   ├── restore.sh
│   └── verify.sh
│
├── docker-compose.yml
├── README.md
├── .gitignore
└── Makefile
```

# Terraform + Database Reliability Assessment

## Overview

This repository demonstrates a production-oriented infrastructure design using **Terraform**, **AWS**, **Docker Compose**, and **PostgreSQL**.

The solution includes:

* Modular Terraform code
* Separate Development and Production environments
* Local PostgreSQL database using Docker Compose
* Database schema creation
* Seed data generation
* Query optimization using indexes
* Database backup and restore scripts
* Verification scripts

---

# Project Structure

```text
terraform-db-reliability/
│
├── .github/
│   └── workflows/
│
├── infra/
│   ├── modules/
│   │   ├── network/
│   │   ├── ecs/
│   │   └── rds/
│   │
│   └── envs/
│       ├── dev/
│       └── prod/
│
├── database/
│   ├── migrations/
│   ├── seeds/
│   └── indexes.sql
│
├── scripts/
│   ├── backup.sh
│   ├── restore.sh
│   └── verify.sh
│
├── docker-compose.yml
├── Makefile
└── README.md
```

---

# Solution Architecture

```
                    Internet
                        │
                        ▼
           Application Load Balancer
                        │
                        ▼
               ECS Fargate Service
                        │
                        ▼
            PostgreSQL RDS (Private)
```

Infrastructure components include:

* VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* NAT Gateway
* Application Load Balancer
* ECS Cluster
* ECS Service
* PostgreSQL RDS
* Security Groups

---

# Terraform Modules

## Network Module

Creates:

* VPC
* Internet Gateway
* NAT Gateway
* Public Subnets
* Private Subnets
* Route Tables

---

## ECS Module

Creates:

* ECS Cluster
* ECS Service
* ECS Task Definition
* Application Load Balancer
* Target Group
* Listener
* Security Groups

---

## RDS Module

Creates:

* PostgreSQL RDS
* DB Subnet Group
* RDS Security Group

RDS is deployed in private subnets and is accessible only from the ECS Security Group.

---

# Environment Configuration

Two independent environments are provided.

## Development

| Property            | Value       |
| ------------------- | ----------- |
| ECS CPU             | 256         |
| ECS Memory          | 512 MB      |
| Desired Tasks       | 1           |
| Database            | db.t3.micro |
| Backup Retention    | 3 Days      |
| Deletion Protection | Disabled    |

---

## Production

| Property            | Value        |
| ------------------- | ------------ |
| ECS CPU             | 512          |
| ECS Memory          | 1024 MB      |
| Desired Tasks       | 2            |
| Database            | db.t3.medium |
| Backup Retention    | 30 Days      |
| Deletion Protection | Enabled      |

---

# Database

The database consists of two tables.

## hotel_bookings

Stores booking information.

Columns include:

* Booking ID
* Organization ID
* Hotel ID
* City
* Check-in Date
* Check-out Date
* Booking Amount
* Status
* Created Timestamp

---

## booking_events

Stores booking lifecycle events.

Example events:

* BOOKED
* PAYMENT_SUCCESS
* CHECKIN
* CHECKOUT
* CANCELLED

---

# Seed Data

The repository generates:

* 100 Hotel Bookings
* 5 Organizations
* Multiple Cities
* Multiple Booking Statuses
* Random Booking Events

Cities include:

* Delhi
* Mumbai
* Bangalore
* Hyderabad
* Chennai
* Pune

Booking statuses include:

* BOOKED
* COMPLETED
* CANCELLED
* PENDING

---

# Query Optimization

The following query is optimized:

```sql
SELECT
    org_id,
    status,
    COUNT(*),
    SUM(amount)
FROM hotel_bookings
WHERE city='delhi'
AND created_at >= NOW()-INTERVAL '30 days'
GROUP BY org_id,status;
```

A composite index is created:

```sql
(city, created_at, org_id, status)
```

### Why this index?

The query filters by:

* city
* created_at

and groups by:

* org_id
* status

The composite index minimizes table scans and improves aggregation performance.

---

# Running the Database

Start PostgreSQL.

```bash
docker compose up -d
```

Verify containers.

```bash
docker ps
```

---

# Terraform Commands

Development Environment

```bash
cd infra/envs/dev

terraform init

terraform fmt -recursive

terraform validate

terraform plan
```

Production Environment

```bash
cd infra/envs/prod

terraform init

terraform fmt -recursive

terraform validate

terraform plan
```

---

# Backup

Run:

```bash
./scripts/backup.sh
```

A timestamped SQL dump will be created inside:

```
backups/
```

Example:

```
backups/hotel_20260706_193000.sql
```

---

# Restore

Restore a backup into a fresh database.

```bash
./scripts/restore.sh backups/hotel_20260706_193000.sql
```

The script creates a new database:

```
hotel_restore
```

and restores the backup.

---

# Verification

Run:

```bash
./scripts/verify.sh
```

The script verifies:

* Booking Count
* Event Count
* Cities
* Booking Status
* Organizations
* Optimized Query

---

# GitHub Actions

The repository supports Terraform validation using GitHub Actions.

The workflow performs:

* terraform fmt
* terraform init
* terraform validate
* terraform plan

Terraform deployment is intentionally excluded as part of this assessment.

---

# Production Improvements

If this infrastructure were deployed in production, the following enhancements would be implemented:

* AWS Secrets Manager for database credentials
* IAM Roles created using Terraform instead of placeholder ARNs
* HTTPS Listener with ACM Certificates
* ECS Auto Scaling
* Multi-AZ PostgreSQL
* CloudWatch Alarms
* Remote Terraform State Locking using DynamoDB
* WAF attached to the Application Load Balancer
* RDS Performance Insights
* AWS Systems Manager Parameter Store
* CI/CD Deployment Pipeline

---

# Submission Checklist

* Terraform Modules
* Dev Environment
* Prod Environment
* Docker Compose
* Database Schema
* Seed Data
* Query Optimization
* Backup Script
* Restore Script
* Verification Script
* README Documentation

All requested requirements for the assessment have been implemented.
