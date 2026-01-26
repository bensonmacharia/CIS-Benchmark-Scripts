# PostgreSQL CIS Benchmark Validation Guide

This document provides **validation and verification steps** to confirm that a PostgreSQL database is hardened according to the **CIS PostgreSQL Benchmark**.  
Each section follows the format: **Control Objective → Validation Steps → Expected Result**.

Applies to PostgreSQL 12+

---

## 1. Authentication & Password Security Validation

### Control Objective
Ensure strong authentication mechanisms are enforced and weak authentication is disabled.

### Validation Steps

1. Verify password encryption method:
```sql
SHOW password_encryption;
```

2. Verify no roles use expired or NULL passwords:
```sql
SELECT rolname, rolvaliduntil FROM pg_authid;
```

3. Verify no `trust` authentication is configured:
```bash
grep -i trust pg_hba.conf
```

### Expected Result
- `password_encryption` is set to `scram-sha-256`
- No roles have NULL passwords
- No `trust` entries exist in `pg_hba.conf`

---

## 2. Least Privilege & Access Control Validation

### Control Objective
Ensure users and roles have only the minimum required privileges.

### Validation Steps

1. List all roles:
```sql
\du
```

2. Verify PUBLIC role has no unnecessary privileges:
```sql
\dp
```

3. Verify database-level privileges:
```sql
SELECT datname, datacl FROM pg_database;
```

4. Verify restricted network access:
```bash
cat pg_hba.conf
```

### Expected Result
- No excessive superuser roles
- PUBLIC role has no privileges on databases or schemas
- Access is restricted by IP and role

---

## 3. Logging & Auditing Validation

### Control Objective
Ensure sufficient logging and auditing is enabled for accountability.

### Validation Steps

1. Verify logging parameters:
```sql
SHOW logging_collector;
SHOW log_connections;
SHOW log_disconnections;
SHOW log_statement;
```

2. Verify pgaudit is installed:
```sql
SELECT * FROM pg_extension WHERE extname = 'pgaudit';
```

3. Verify pgaudit configuration:
```sql
SHOW shared_preload_libraries;
SHOW pgaudit.log;
```

4. Verify logs are generated:
```bash
ls -l pg_log/
```

### Expected Result
- Logging is enabled
- pgaudit is active
- Audit entries appear for DDL and DML actions

---

## 4. Encryption in Transit Validation

### Control Objective
Ensure all client connections use encrypted channels.

### Validation Steps

1. Verify SSL is enabled:
```sql
SHOW ssl;
```

2. Verify active connections are encrypted:
```sql
SELECT pid, usename, ssl FROM pg_stat_ssl;
```

3. Verify SSL enforcement in pg_hba.conf:
```bash
grep hostssl pg_hba.conf
```

### Expected Result
- SSL is enabled
- All active connections use SSL
- `hostssl` rules are enforced

---

## 5. Encryption at Rest Validation

### Control Objective
Ensure sensitive data and backups are protected at rest.

### Validation Steps

1. Verify filesystem encryption (OS-level):
```bash
lsblk -f
```

2. Verify pgcrypto extension if used:
```sql
SELECT * FROM pg_extension WHERE extname = 'pgcrypto';
```

3. Verify backups are encrypted:
```bash
file mydb.sql.gpg
```

### Expected Result
- Database storage uses encrypted disks OR
- Sensitive columns are encrypted
- Backup files are encrypted

---

## 6. Secure Configuration Validation

### Control Objective
Ensure PostgreSQL is configured with secure defaults.

### Validation Steps

1. Verify listening interfaces:
```sql
SHOW listen_addresses;
```

2. Verify Unix socket permissions:
```sql
SHOW unix_socket_permissions;
```

3. Verify unused extensions are removed:
```sql
SELECT extname FROM pg_extension;
```

4. Verify configuration file permissions:
```bash
ls -l postgresql.conf pg_hba.conf
```

### Expected Result
- PostgreSQL listens only on trusted interfaces
- Configuration files are restricted to postgres user
- Only required extensions are installed

---

## 7. Patch & Version Management Validation

### Control Objective
Ensure PostgreSQL is running a supported and patched version.

### Validation Steps

1. Verify PostgreSQL version:
```sql
SELECT version();
```

2. Verify OS patch status:
```bash
apt list --upgradable | grep postgres
```

### Expected Result
- PostgreSQL version is supported
- Latest security patches are applied

---

## 8. Backup & Recovery Validation

### Control Objective
Ensure backups are secure and restorable.

### Validation Steps

1. Verify backup permissions:
```bash
ls -l mydb.sql.gpg
```

2. Test backup restore:
```bash
gpg -d mydb.sql.gpg | psql test_restore
```

### Expected Result
- Backups are encrypted
- Backups are accessible only to authorized users
- Restore operations succeed

---

## 9. Monitoring & Activity Review Validation

### Control Objective
Ensure database activity can be monitored and reviewed.

### Validation Steps

1. Verify activity tracking:
```sql
SHOW track_activities;
```

2. Review active sessions:
```sql
SELECT * FROM pg_stat_activity;
```

3. Verify log centralization (if applicable):
- Check SIEM or log aggregation platform

### Expected Result
- Activity tracking is enabled
- Administrators can detect suspicious behavior

---
