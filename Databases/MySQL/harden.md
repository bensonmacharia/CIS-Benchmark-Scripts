# MySQL CIS Benchmark Hardening Guide

This guide provides **step-by-step instructions** for hardening MySQL according to the **CIS MySQL 8 Benchmark** (Community Edition).

---

## 1. Install MySQL Securely

### Steps:
1. Install MySQL using your package manager:
```bash
sudo apt update
sudo apt install mysql-server
```
2. Start and enable the MySQL service:
```bash
sudo systemctl start mysql
sudo systemctl enable mysql
```
3. Run the secure installation script:
```bash
sudo mysql_secure_installation
```
This helps remove test databases, anonymous users, and sets the root password.

---

## 2. Secure Authentication & Password Policies

### Steps:
1. **Enforce strong passwords**
```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'StrongP@ssw0rd!';
```
2. **Disable or rename default accounts**
```sql
RENAME USER 'root'@'localhost' TO 'admin'@'localhost';
```
3. **Set password expiration policies**
```sql
ALTER USER 'admin'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;
```
4. **Verify users**
```sql
SELECT Host, User, password_expired FROM mysql.user;
```

---

## 3. Restrict Access / Principle of Least Privilege

### Steps:
1. **Remove unnecessary accounts**
```sql
DROP USER 'test'@'localhost';
```
2. **Grant only minimal privileges**
```sql
GRANT SELECT, INSERT, UPDATE ON mydb.* TO 'appuser'@'localhost';
```
3. **Restrict remote access**
```sql
RENAME USER 'appuser'@'%' TO 'appuser'@'192.168.1.10';
```
4. **Verify privileges**
```sql
SHOW GRANTS FOR 'appuser'@'192.168.1.10';
```

---

## 4. Enable Auditing & Logging

### Steps:
1. **Enable general log**
```sql
SET GLOBAL general_log = 'ON';
SET GLOBAL general_log_file = '/var/log/mysql/general.log';
```
2. **Enable error log**
```ini
[mysqld]
log_error = /var/log/mysql/error.log
```
3. **Enable slow query log**
```ini
[mysqld]
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2
```
4. **Optional: Use audit plugin**
```sql
INSTALL PLUGIN audit_log SONAME 'audit_log.so';
```

---

## 5. Encrypt Data in Transit & at Rest (SSL/TLS)

### Generate SSL Certificates
```bash
# Create a certificate authority (CA)
openssl genrsa 2048 > ca-key.pem
openssl req -new -x509 -nodes -days 3650 -key ca-key.pem -out ca-cert.pem

# Create server certificate
openssl req -newkey rsa:2048 -days 3650 -nodes -keyout server-key.pem -out server-req.pem
openssl x509 -req -in server-req.pem -days 3650 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem

# Create client certificate
openssl req -newkey rsa:2048 -days 3650 -nodes -keyout client-key.pem -out client-req.pem
openssl x509 -req -in client-req.pem -days 3650 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem
```

### Configure MySQL to Use SSL
```ini
[mysqld]
ssl-ca=/etc/mysql/ssl/ca-cert.pem
ssl-cert=/etc/mysql/ssl/server-cert.pem
ssl-key=/etc/mysql/ssl/server-key.pem
```

### Require SSL for Users
```sql
ALTER USER 'appuser'@'localhost' REQUIRE SSL;
```

### Verify SSL
```sql
SHOW VARIABLES LIKE '%ssl%';
```

---

## 6. Secure Configuration & Patch Management

### Steps:
1. **Bind MySQL to trusted network interfaces only**
```ini
[mysqld]
bind-address = 127.0.0.1
```
2. **Remove test database**
```sql
DROP DATABASE test;
```
3. **Disable unused plugins**
```sql
UNINSTALL PLUGIN example;
```
4. **Apply security patches regularly**
```bash
sudo apt update && sudo apt upgrade mysql-server
```
5. **Verify configuration**
```sql
SHOW VARIABLES LIKE 'bind_address';
```

---

## 7. Additional CIS Recommendations

1. **Audit table permissions**
```sql
SELECT * FROM mysql.tables_priv;
```
2. **Set secure file privileges**
```ini
[mysqld]
safe-file-priv=/var/lib/mysql-files
```
3. **Disable symbolic links**
```ini
[mysqld]
symbolic-links=0
```
4. **Enforce TLS versions (MySQL 8+):**
```ini
[mysqld]
ssl-cipher=TLS_AES_256_GCM_SHA384
```

---