# Architecture Decisions

## ADR-001: AWS Region

**Decision:** Deploy in Africa (Cape Town), af-south-1.

The region is selected for the proposed ERP workload and will be used consistently across infrastructure, storage, monitoring, and supporting services.

## ADR-002: Single-Instance ERPNext Deployment

**Decision:** Deploy the initial ERPNext environment on one Amazon EC2 t3.large instance.

The instance provides 2 vCPUs and 8 GiB RAM and hosts the Dockerized ERPNext application stack.

The deployment includes:

- ERPNext/Frappe
- MariaDB
- Redis
- Background workers
- Scheduler
- Nginx reverse proxy

This configuration meets the initial single-server deployment requirement while providing a foundation for subsequent scaling.

### Architectural trade-off

The application, database, and supporting services share the same compute resources and failure domain.

The architecture therefore prioritizes recoverability rather than multi-instance high availability.

## ADR-003: MariaDB on EC2 Instead of Amazon RDS

**Decision:** Run MariaDB within the Dockerized application environment on EC2.

### Context

The initial client requirement is for a cost-conscious ERPNext deployment with a single application server.

Amazon RDS was evaluated as an alternative managed database architecture.

### Rationale

Hosting MariaDB alongside ERPNext:

- Aligns with the initial single-instance deployment requirement.
- Avoids provisioning a separate database instance during the initial phase.
- Allows application and database deployment to be managed together.
- Supports persistent database storage through EBS-backed Docker volumes.
- Retains flexibility to separate the database tier as requirements evolve.

### Trade-offs

The project assumes responsibility for database administration, backup configuration, patching, recovery, and monitoring.

Database performance and application performance share EC2 resources.

A failure affecting the EC2 instance can affect both application and database availability.

### Future evolution

When database utilization, operational requirements, or availability objectives justify separation, MariaDB can be migrated to Amazon RDS.

An appropriate RDS Multi-AZ configuration can then provide managed database failover.

This decision reflects the initial project requirements rather than a general preference for self-managed databases.

## ADR-004: Persistent Storage

**Decision:** Use encrypted Amazon EBS gp3 storage.

MariaDB data and persistent ERPNext application files must use EBS-backed storage.

Container recreation must not result in loss of persistent business data.

The initial allocated capacity is 100 GB.

## ADR-005: DNS and HTTPS

**Decision:** Use Amazon Route 53 for DNS management and Nginx as the application reverse proxy.

HTTPS will be configured using an appropriate TLS certificate solution.

Only required application ports will be exposed publicly.

MariaDB, Redis, and internal application ports must remain inaccessible from the public internet.

## ADR-006: Secure Administration

**Decision:** Use AWS Systems Manager Session Manager for administrative access.

Public SSH access will not be required.

The EC2 instance will use an appropriately scoped IAM instance profile.

## ADR-007: Observability

**Decision:** Implement Amazon CloudWatch monitoring.

The implementation will include:

- EC2 infrastructure metrics
- Application and system logs
- Relevant operational alarms
- Monitoring of storage utilization
- Monitoring of application and database health

## ADR-008: Backup and Recovery

**Decision:** Implement complementary infrastructure and application-level backup mechanisms.

AWS Backup will manage the selected infrastructure backup policy.

ERPNext application and database backups will be stored in Amazon S3.

Recovery procedures will be documented and tested.

The initial architecture does not provide automatic application failover across Availability Zones.

## ADR-009: Business Intelligence

**Decision:** Integrate Amazon QuickSight.

QuickSight will access approved ERPNext reporting data using restricted read-only database credentials.

SPICE will be evaluated for reducing repeated analytical queries against the transactional database.

## ADR-010: Infrastructure Evolution

The initial architecture supports vertical EC2 scaling.

Future enhancements may include:

- Separating MariaDB into Amazon RDS
- Deploying multiple ERPNext application nodes
- Introducing an Application Load Balancer
- Distributing application nodes across Availability Zones
- Separating background workers where workload characteristics justify it

Application-level state, shared files, Redis, database connectivity,
and background processing must be addressed before introducing
multiple ERPNext application nodes.
