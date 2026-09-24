# Business Requirements

## 1. Business Context

An organization operating a legacy on-premises ERP requires a modern, centrally accessible ERP platform with structured data migration, operational reporting, and a sustainable cloud hosting model.

This portfolio project simulates that modernization using ERPNext on AWS and synthetic legacy ERP data.

## 2. Project Objectives

- Deploy ERPNext in a controlled AWS environment.
- Establish a repeatable application deployment process.
- Migrate representative legacy business records.
- Preserve data integrity through validation and reconciliation.
- Provide management reporting through Amazon QuickSight.
- Implement security, backup, and recovery controls.
- Establish a documented infrastructure cost and scaling strategy.

## 3. Functional Requirements

### ERP Platform

The environment must support ERPNext application access, persistent business data, background jobs, scheduled tasks, and the supporting database and cache services.

### Data Migration

The migration process must support:

- CSV-based legacy data exports.
- Temporary storage of raw exports.
- Data profiling and quality assessment.
- Source-to-target field mapping.
- Data transformation and validation.
- Controlled import into ERPNext.
- Reconciliation of imported records and balances.
- Reporting of rejected or unresolved records.

### Business Intelligence

Authorized users must be able to access business dashboards based on approved ERPNext reporting datasets.

Reporting access must use a dedicated read-only database identity and restrict exposure to approved data.

## 4. Non-Functional Requirements

### Security

- Restrict network access to required services.
- Protect credentials and application secrets.
- Encrypt persistent storage.
- Use least-privilege AWS permissions.
- Avoid exposing database and Redis ports publicly.

### Recoverability

- Persist application and database data independently of container lifecycles.
- Implement scheduled backups.
- Document restoration procedures.
- Validate recovery through a practical restore test.

### Performance

- Validate application responsiveness and resource utilization under representative workloads.
- Measure the impact of database operations, background jobs, and reporting activity.

### Cost Management

- Begin with a single EC2 instance.
- Monitor resource consumption before committing to long-term compute pricing.
- Remove temporary migration resources after their purpose is complete.

## 5. Availability Assumption

The initial deployment uses one EC2 instance and therefore has a single compute failure domain.

The implementation will prioritize recovery controls rather than claim multi-instance high availability.

Recovery Time Objective (RTO) and Recovery Point Objective (RPO) must be established before a production service-level commitment is made.

## 6. Acceptance Criteria

The milestone will be considered complete when:

- ERPNext is accessible securely.
- Required application containers operate correctly.
- Application and database data survive container recreation.
- Representative synthetic records are imported successfully.
- Migration reconciliation results are documented.
- QuickSight reporting access is validated.
- Backup and restoration procedures are tested.
- Infrastructure costs and architectural limitations are documented.

## 7. Project Data Policy

Only synthetic or appropriately sanitized data may be committed to this public repository.

Real customer records, financial exports, credentials, database backups, and confidential architecture details must remain outside version control.
