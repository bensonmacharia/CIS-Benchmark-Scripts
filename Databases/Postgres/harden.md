# PostgreSQL CIS Benchmark Hardening Guide (Step-by-Step)

This guide provides **step-by-step instructions to harden a PostgreSQL database** based on the **CIS PostgreSQL Benchmark**. It includes all major areas: authentication, access control, auditing/logging, encryption, and configuration.

---

## 1. Secure Authentication & Password Policies

**Goal:** Enforce strong passwords and secure user accounts.

### Steps:
1. **Set strong passwords for all roles:**
```sql
ALTER ROLE postgres WITH PASSWORD 'Str0ngP@ssw0rd!';
```
2. **Check all users and passwords:**
```sql
\du
```
3. **Remove or rename default accounts:**
```sql
ALTER ROLE postgres RENAME TO admin;
```
4. **Set password expiration:**
```sql
ALTER ROLE appuser VALID UNTIL '2026-02-14';
```

### Check:
```sql
SELECT rolname, rolvaliduntil FROM pg_authid;
```
**Expected Result:** All roles have strong passwords and expiration dates set.

---

## 2. Restrict Access / Principle of Least Privilege

**Goal:** Limit user privileges and control access.

### Steps:
1. **Grant minimal privileges:**
```sql
GRANT SELECT, INSERT, UPDATE ON DATABASE mydb TO appuser;
```
2. **Revoke unnecessary privileges:**
```sql
REVOKE ALL PRIVILEGES ON DATABASE mydb FROM public;
```
3. **Restrict remote access in `pg_hba.conf`:**
```text
# Allow only specific IPs
host    mydb    appuser    192.168.1.0/24    md5
```
4. **Reload configuration:**
```bash
SELECT pg_reload_conf();
```

### Check:
```sql
\du
```
**Expected Result:** Users have only required privileges; unnecessary roles removed.

---

## 3. Enable Logging & Auditing

**Goal:** Track user activity, login attempts, and DDL/DML changes.

### Steps:
1. **Enable standard logging in `postgresql.conf`:**
```ini
logging_collector = on
log_directory = 'pg_log'
log_filename = 'postgresql-%Y-%m-%d.log'
log_statement = 'ddl'
log_connections = on
log_disconnections = on
```
2. **Install and configure `pgaudit` (optional, for detailed auditing):**
```sql
CREATE EXTENSION pgaudit;
```
3. **Set pgaudit logging:**
```sql
SET pgaudit.log = 'all';
```

### Check:
- Verify logs exist in `pg_log/`  
- Ensure pgaudit entries appear for role activities.  
**Expected Result:** Logs capture login, DDL, DML, and administrative activity.

---

## 4. Encrypt Data in Transit & at Rest

**Goal:** Protect sensitive data from interception or compromise.

### Steps:
1. **Enable SSL for client connections:**
- Generate certificates:
```bash
# Generate CA
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -days 3650 -out rootCA.crt

# Generate server key and certificate
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr
openssl x509 -req -in server.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out server.crt -days 3650
chmod 600 server.key
```
2. **Configure `postgresql.conf` for SSL:**
```ini
ssl = on
ssl_cert_file = '/path/to/server.crt'
ssl_key_file = '/path/to/server.key'
ssl_ca_file = '/path/to/rootCA.crt'
```
3. **Require SSL in `pg_hba.conf`:**
```text
hostssl mydb appuser 192.168.1.0/24 md5
```
4. **Restart PostgreSQL:**
```bash
sudo systemctl restart postgresql
```

### Check:
```sql
SHOW ssl;
```
**Expected Result:** SSL is enabled; connections require encryption.

5. **Optional Data-at-Rest Encryption:**  
- Use filesystem-level encryption (LUKS, encrypted partitions) or column-level encryption with `pgcrypto`:
```sql
CREATE TABLE sensitive (
  id SERIAL,
  data TEXT,
  encrypted_data BYTEA
);
INSERT INTO sensitive (data, encrypted_data) VALUES ('secret', pgp_sym_encrypt('secret','encryption_key'));
```

---

## 5. Secure Configuration & Patch Management

**Goal:** Harden configuration and ensure PostgreSQL is up-to-date.

### Steps:
1. **Bind PostgreSQL to trusted interfaces:**
```ini
listen_addresses = 'localhost'
```
2. **Disable unused extensions:**
```sql
DROP EXTENSION IF EXISTS dblink;
DROP EXTENSION IF EXISTS adminpack;
```
3. **Remove test databases:**
```sql
DROP DATABASE IF EXISTS test;
```
4. **Apply OS and PostgreSQL updates regularly:**
```bash
sudo apt update && sudo apt upgrade postgresql
```
5. **Check configuration parameters:**
```sql
SHOW all;
```
**Expected Result:** Only necessar