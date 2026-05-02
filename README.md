# PixelShare Platform (AWS Cloud Infrastructure)

A cloud-native photo-sharing platform deployed on a fully automated AWS 3-tier architecture.

PixelShare demonstrates real-world DevOps engineering — infrastructure as code, containerisation, CI/CD pipelines, security hardening, and modern AWS design patterns, all production-ready.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Repository Structure](#repository-structure)
- [Deployment Workflow](#deployment-workflow)
- [Security](#security)
- [Monitoring & Observability](#monitoring--observability)
- [Future Enhancements](#future-enhancements)

---

## Project Overview

PixelShare is built to mirror a production-grade cloud system. It includes:

- **Containerised backend API** — Flask running in Docker on EC2
- **Secure, scalable AWS network** — VPC with public, private, and database subnet tiers
- **Infrastructure as Code** — fully automated provisioning with Terraform (modular)
- **CI/CD pipelines** — GitHub Actions for build, push, validate, and deploy
- **Private image registry** — Amazon ECR
- **Managed database** — Amazon RDS (MySQL) in isolated private subnets
- **Asset storage** — Amazon S3
- **Secrets management** — AWS Secrets Manager (no plaintext credentials)
- **Least-privilege access** — IAM roles & policies throughout
- **Observability** — CloudWatch metrics, logs, and ALB health checks

---

## Architecture

### Three-Tier Design

| Tier | Component | Location |
|---|---|---|
| Presentation | Frontend (placeholder / future) | Public-facing |
| Application | Flask API on EC2 (Docker) | Private subnets |
| Data | Amazon RDS MySQL | Database subnets |

### High-Level Diagram

```
                    ┌──────────────────────────────┐
                    │        Public Subnets         │
                    │   ┌──────────────────────┐    │
Internet ───────────►   │  Application Load    │    │
                    │   │      Balancer        │    │
                    │   └──────────────────────┘    │
                    └──────────────────────────────┘
                                   │
                                   ▼
                    ┌──────────────────────────────┐
                    │        Private Subnets        │
                    │   ┌──────────────────────┐    │
                    │   │   EC2 (Docker API)   │    │
                    │   └──────────────────────┘    │
                    └──────────────────────────────┘
                                   │
                                   ▼
                    ┌──────────────────────────────┐
                    │       Database Subnets        │
                    │   ┌──────────────────────┐    │
                    │   │     RDS (MySQL)      │    │
                    │   └──────────────────────┘    │
                    └──────────────────────────────┘
```

### AWS Services Used

- VPC, Subnets, Route Tables, Internet Gateway, NAT Gateway
- Application Load Balancer (ALB) + Target Groups
- EC2 (private subnet) with Docker Compose
- Amazon ECR (private container registry)
- Amazon RDS MySQL
- Amazon S3
- AWS Secrets Manager
- IAM Roles & Policies
- CloudWatch Metrics & Logs
- SSM Session Manager (no SSH keys required)

---

## Tech Stack

### Infrastructure
- **Terraform** — modular IaC
- **AWS** — VPC, ALB, EC2, RDS, S3, IAM, Secrets Manager, CloudWatch

### Application
- **Python / Flask** — REST API
- **Docker & Docker Compose** — containerisation
- **Amazon ECR** — private image registry

### CI/CD
- **GitHub Actions**
  - Build & push Docker image to ECR
  - Terraform validation & plan
  - Automated deployment workflow

---

## Repository Structure

```
pixelshare-aws-3tier/
│
├── frontend/               # UI (placeholder / future expansion)
│
├── infrastructure/
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── network/            # VPC, subnets, IGW, NAT, route tables
│   ├── compute/            # EC2, ALB, target groups
│   ├── database/           # RDS MySQL
│   ├── storage/            # S3 buckets
│   ├── iam/                # Roles & policies
│   ├── lambda/             # Serverless functions (future)
│   ├── monitoring/         # CloudWatch dashboards & alarms
│   └── secrets/            # Secrets Manager config
│
├── docs/                   # Architecture diagrams, notes
└── README.md
```

---

## Deployment Workflow

### 1. Developer pushes to GitHub
- **App changes** → triggers Docker build & push to ECR
- **Infra changes** → triggers Terraform validate & plan

### 2. GitHub Actions CI/CD
```
Push → Build Docker image → Push to ECR → Terraform Validate → (Auto) Deploy to AWS
```

### 3. EC2 pulls latest image
- Docker Compose restarts the API container
- ALB health checks confirm zero-downtime rollout

---

## Security

| Control | Implementation |
|---|---|
| Network isolation | EC2 & RDS in private subnets — no public IPs |
| No SSH key exposure | Access via SSM Session Manager only |
| Least-privilege IAM | Scoped roles per service |
| Secret management | DB credentials stored in AWS Secrets Manager |
| Public traffic gateway | All inbound traffic routed through ALB only |

---

## Monitoring & Observability

- **CloudWatch** — metrics and structured logs
- **ALB health checks** — automatic unhealthy instance removal
- **EC2 logs** — application-level visibility
- **RDS Performance Insights** — query-level database monitoring
- **Dashboards** — optional CloudWatch dashboards for key KPIs

---

## Future Enhancements

- [ ] Migrate compute layer to ECS Fargate (serverless containers)
- [ ] CloudFront CDN for frontend asset delivery
- [ ] API Gateway + Lambda serverless API variant
- [ ] Blue/green deployment strategy
- [ ] Terraform Cloud remote backend & state locking

---

## About This Project

This project was built to demonstrate end-to-end cloud engineering capability:

- Designing secure, scalable AWS architectures
- Building production-ready infrastructure with Terraform
- Containerising and deploying applications via CI/CD
- Applying DevOps best practices — security, modularity, and automation first
