# ERPNext on AWS — Implementation Plan

## 1. Implementation Strategy

This project follows an architecture-led, incremental implementation approach.

Each milestone will include:
- Infrastructure or application configuration.
- Security and operational considerations.
- Implementation instructions.
- Functional validation.
- Sanitized implementation evidence.
- Documentation and Git commits.

AWS Region: Africa (Cape Town), af-south-1.

Primary compute: Amazon EC2 t3.large (2 vCPU, 8 GiB RAM).

## 2. Implementation Milestones

### Milestone 1 — Project Foundation

- Establish business requirements.
- Document architecture decisions.
- Create the final AWS architecture diagram.
- Define the implementation roadmap.
- Initialize the GitHub repository.

### Milestone 2 — AWS Networking

- Create the VPC.
- Configure public and private subnets.
- Attach an Internet Gateway.
- Configure route tables and subnet associations.
- Create security groups.
- Configure required VPC endpoints.
- Validate routing and network security.

### Milestone 3 — Compute and Storage

- Launch EC2 t3.large.
- Configure Ubuntu Linux.
- Provision encrypted 100 GB gp3 EBS storage.
- Configure the EC2 IAM instance profile.
- Enable AWS Systems Manager Session Manager.
- Install Docker and Docker Compose.
- Validate instance connectivity and persistent storage.

### Milestone 4 — ERPNext Deployment

Deploy the Dockerized application stack:

- ERPNext/Frappe.
- MariaDB.
- Redis.
- Background workers.
- Scheduler.
- Nginx reverse proxy.

Validate application functionality, container health, background processing, and data persistence.

### Milestone 5 — Route 53 and HTTPS

- Configure Route 53 DNS.
- Create the application DNS record.
- Configure HTTPS.
- Configure the Nginx reverse proxy.
- Validate DNS resolution and secure application access.

### Milestone 6 — Legacy ERP Data Migration

- Generate synthetic HANSAWorld-style datasets.
- Stage raw CSV exports in Amazon S3.
- Profile and assess source data quality.
- Define ERPNext field mappings.
- Develop Python transformation scripts.
- Validate transformed records.
- Import data through supported ERPNext interfaces.
- Reconcile migrated records and balances.

### Milestone 7 — Security and Observability

- Configure CloudWatch metrics and logs.
- Install and configure the CloudWatch Agent.
- Create operational alarms.
- Review IAM permissions.
- Validate encryption and network restrictions.
- Document operational monitoring procedures.

### Milestone 8 — Backup and Recovery

- Configure AWS Backup.
- Implement ERPNext application and database backups.
- Store selected backups in Amazon S3.
- Configure backup retention.
- Document recovery procedures.
- Perform and validate a restoration test.

### Milestone 9 — QuickSight Integration

- Create approved reporting views.
- Configure restricted read-only database access.
- Establish secure QuickSight connectivity.
- Create datasets and configure SPICE.
- Develop business dashboards.
- Validate reporting permissions and dataset refresh.

### Milestone 10 — Architecture Validation

- Perform functional testing.
- Review infrastructure security.
- Assess resource utilization.
- Validate backup and recovery.
- Document architectural trade-offs.
- Evaluate the future RDS and Multi-AZ scaling path.
- Finalize project documentation and evidence.

## 3. Architecture Constraints

The initial implementation uses one EC2 instance hosting ERPNext,
MariaDB, Redis, and supporting application services.

MariaDB is hosted on EC2 in accordance with the initial client
requirements and consolidated deployment model.

The architecture prioritizes recoverability and operational
controls. It does not provide multi-instance high availability.

## 4. Implementation Evidence

Evidence will include sanitized configuration outputs,
architecture diagrams, validation results, and screenshots.

Credentials, client data, database backups, and confidential
infrastructure information must remain outside the repository.

## 5. Project Status

Milestone 1: In progress.

All subsequent milestones remain planned until implementation
and validation are completed.
