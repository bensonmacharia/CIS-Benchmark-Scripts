# PostgreSQL CIS Benchmark Hardening Guide

This guide provides **step-by-step instructions to harden a PostgreSQL database** based on the **CIS PostgreSQL Benchmark**.

---

## 1. Secure Authentication & Password Policies

**Goal:** Enforce strong authentication and prevent credential abuse.

### Steps

1. Enable SCRAM-SHA-256 password encryption:
```ini
password_encryption = scram-sha-256
```

2. Set strong passwords:
```sql
ALTER ROLE postgres WITH PASSWORD 'Str0ngP@ssw0rd!';
```

3. Rename default superuser:
```sql
ALTER ROLE postgres RENAME TO admin;
```

4. Set password expiration:
```sql
ALTER ROLE appuser VALID UNTIL '2026-02-14';
```

5. Enforce password authentication:
```text
host    all    all    0.0.0.0/0    scram-sha-256
```

### Check
```sql
SHOW password_encryption;
SELECT rolname, rolvaliduntil FROM pg_authid;
```

**Expected Result:**  
All roles use SCRAM-SHA-256 with expiration dates and no trust authentication.

---

## 2. Restrict Access / Principle of Least Privilege

**Goal:** Ensure users only have the minimum permissions required.

### Steps

1. Revoke default PUBLIC privileges:
```sql
REVOKE ALL ON DATABASE mydb FROM public;
REVOKE ALL ON SCHEMA public FROM public;
```

2. Grant minimal access:
```sql
GRANT CONNECT ON DATABASE mydb TO appuser;
GRANT USAGE ON SCHEMA public TO appuser;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO appuser;
```

3. Restrict network access:
```text
host    mydb    appuser    192.168.1.0/24    scram-sha-256
```

### Check
```sql
\du
\dp
```

**Expected Result:**  
Users have only explicitly granted privileges; PUBLIC access is removed.

---

## 3. Logging & Auditing

**Goal:** Capture authentication, DDL, and data access events.

### Steps

1. Enable logging:
```ini
logging_collector = on
log_connections = on
log_disconnections = on
log_statement = 'ddl'
log_line_prefix = '%m %u %d %r %p '
```

2. Install pgaudit:
```sql
CREATE EXTENSION pgaudit;
```

3. Enable pgaudit:
```ini
shared_preload_libraries = 'pgaudit'
pgaudit.log = 'read, write, ddl, role'
```

### Check
```sql
SHOW logging_collector;
SHOW shared_preload_libraries;
```

**Expected Result:**  
All connection attempts, DDL, and audited actions appear in logs.

---

## 4. Encrypt Data in Transit & At Rest

**Goal:** Protect data confidentiality.

### Steps

1. Enable SSL:
```ini
ssl = on
```

2. Require encrypted connections:
```text
hostssl    all    all    0.0.0.0/0    scram-sha-256
```

3. Use encrypted storage or pgcrypto:
```sql
CREATE EXTENSION pgcrypto;
```

### Check
```sql
SHOW ssl;
SELECT * FROM pg_stat_ssl;
```

**Expected Result:**  
All client connections are encrypted; sensitive data is protected at rest.

---

## 5. Secure Configuration & Patch Management

**Goal:** Reduce attack surface and maintain secure defaults.

### Steps

1. Bind to trusted interfaces:
```ini
listen_addresses = 'localhost'
```

2. Remove unused extensions:
```sql
DROP EXTENSION IF EXISTS dblink;
DROP EXTENSION IF EXISTS adminpack;
```

3. Apply updates:
```bash
sudo apt update && sudo apt upgrade postgresql
```

### Check
```sql
SHOW listen_addresses;
```

**Expected Result:**  
PostgreSQL listens only on trusted interfaces and runs up-to-date software.

---

## 6. Backup Security

**Goal:** Ensure backups are protected and recoverable.

### Steps

1. Encrypt backups:
```bash
pg_dump mydb | gpg --symmetric --cipher-algo AES256 > mydb.sql.gpg
```

2. Restrict permissions:
```bash
chmod 600 mydb.sql.gpg
```

### Check
```bash
ls -l mydb.sql.gpg
```

**Expected Result:**  
Backups are encrypted, access-controlled, and restorable.

---

## 7. Monitoring & Activity Review

**Goal:** Detect suspicious or unauthorized activity.

### Steps

1. Enable activity tracking:
```ini
track_activities = on
```

2. Monitor sessions:
```sql
SELECT * FROM pg_stat_activity;
```

### Check
```sql
SHOW track_activities;
```

**Expected Result:**  
Administrators can review active and historical database activity.

---
