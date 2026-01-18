# MySQL CIS Benchmark Validation & Testing Guide

This guide provides **step-by-step instructions to validate and test** MySQL hardening based on the CIS benchmark. For each check, the query/command, explanation of results, and recommended fix are provided.

---

## 1. Verify Root/Admin User Password Strength
**Query:**
```sql
SELECT User, Host, authentication_string FROM mysql.user WHERE User='root';
```
**Explanation:**
- Empty or weak passwords indicate insecure accounts.
**Recommendation:**
```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'StrongP@ssw0rd!';
```

---

## 2. Check for Default or Anonymous Accounts
**Query:**
```sql
SELECT User, Host FROM mysql.user;
```
**Explanation:**
- Default accounts (`root@%`, anonymous users) pose a security risk.
**Recommendation:**
```sql
DROP USER 'test'@'localhost';
RENAME USER 'root'@'%' TO 'admin'@'localhost';
```

---

## 3. Verify User Privileges (Least Privilege)
**Query:**
```sql
SHOW GRANTS FOR 'username'@'host';
```
**Explanation:**
- Users with excessive privileges (e.g., GRANT ALL) violate least privilege.
**Recommendation:**
```sql
GRANT SELECT, INSERT, UPDATE ON mydb.* TO 'appuser'@'localhost';
```

---

## 4. Check Password Expiration Policy
**Query:**
```sql
SELECT User, Host, password_expired FROM mysql.user;
```
**Explanation:**
- Passwords that never expire are insecure.
**Recommendation:**
```sql
ALTER USER 'appuser'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;
```

---

## 5. Verify Logging (General, Error, Slow Query)
**Commands:**
```sql
SHOW VARIABLES LIKE 'general_log';
SHOW VARIABLES LIKE 'log_error';
SHOW VARIABLES LIKE 'slow_query_log';
```
**Explanation:**
- Disabled logs prevent tracking of activity and errors.
**Recommendation:**
```ini
[mysqld]
general_log = ON
log_error = /var/log/mysql/error.log
slow_query_log = ON
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2
```

---

## 6. Check Audit Plugin
**Query:**
```sql
SELECT * FROM information_schema.plugins WHERE PLUGIN_NAME='audit_log';
```
**Explanation:**
- Missing plugin means activity is not audited.
**Recommendation:**
```sql
INSTALL PLUGIN audit_log SONAME 'audit_log.so';
```

---

## 7. Verify SSL/TLS Configuration
**Query:**
```sql
SHOW VARIABLES LIKE '%ssl%';
SHOW STATUS LIKE 'Ssl_cipher';
```
**Explanation:**
- Empty SSL cipher or `have_ssl = DISABLED` indicates unencrypted connections.
**Recommendation:**
```ini
[mysqld]
ssl-ca=/etc/mysql/ssl/ca-cert.pem
ssl-cert=/etc/mysql/ssl/server-cert.pem
ssl-key=/etc/mysql/ssl/server-key.pem
```
```sql
ALTER USER 'appuser'@'localhost' REQUIRE SSL;
```

---

## 8. Verify Data-at-Rest Encryption
**Query:**
```sql
SHOW VARIABLES LIKE 'innodb_encrypt_tables';
```
**Explanation:**
- OFF indicates tablespaces are unencrypted.
**Recommendation:**
```ini
[mysqld]
encrypt-tables = ON
```
- Encrypt backups using `mysqldump + gpg`.

---

## 9. Verify bind-address
**Query:**
```sql
SHOW VARIABLES LIKE 'bind_address';
```
**Explanation:**
- `0.0.0.0` exposes MySQL to all interfaces.
**Recommendation:**
```ini
[mysqld]
bind-address = 127.0.0.1
```

---

## 10. Check for Test Database
**Query:**
```sql
SHOW DATABASES LIKE 'test';
```
**Explanation:**
- Test database presence is a security risk.
**Recommendation:**
```sql
DROP DATABASE test;
```

---

## 11. Check Unused Plugins
**Query:**
```sql
SELECT PLUGIN_NAME, PLUGIN_STATUS FROM information_schema.plugins;
```
**Explanation:**
- Unused plugins increase attack surface.
**Recommendation:**
```sql
UNINSTALL PLUGIN plugin_name;
```

---

## 12. Verify Symbolic Links Disabled
**Query:**
```sql
SHOW VARIABLES LIKE 'symbolic-links';
```
**Explanation:**
- ON allows filesystem exploitation via symlinks.
**Recommendation:**
```ini
[mysqld]
symbolic-links=0
```

---

## 13. Verify TLS Version Enforcement
**Query:**
```sql
SHOW VARIABLES LIKE 'ssl_cipher';
```
**Explanation:**
- Weak TLS (1.0/1.1) is insecure.
**Recommendation:**
```ini
[mysqld]
ssl-cipher=TLS_AES_256_GCM_SHA384
```

---

## 14. Check Secure File Privileges
**Query:**
```sql
SHOW VARIABLES LIKE 'secure_file_priv';
```
**Explanation:**
- Empty or unrestricted path allows arbitrary file access.
**Recommendation:**
```ini
[mysqld]
secure_file_priv=/var/lib/mysql-files
```

---

## 15. Verify Patch Level
**Query:**
```sql
SELECT VERSION();
```
**Explanation:**
- Outdated versions may have known vulnerabilities.
**Recommendation:**
```bash
sudo apt update && sudo apt upgrade mysql-server
```

---

## 16. Audit Table Privileges
**Query:**
```sql
SELECT * FROM mysql.tables_priv;
```
**Explanation:**
- Excessive privileges on critical tables are risky.
**Recommendation:**
```sql
REVOKE INSERT, UPDATE, DELETE ON mydb.sensitive_table FROM 'user'@'host';
```

---

## 17. Verify Secure Backups
**Explanation:**
- Unencrypted backups may leak sensitive data.
**Recommendation:**
```bash
mysqldump -u root -p mydb | gpg --symmetric --cipher-algo AES256 -o mydb.sql.gpg
```
