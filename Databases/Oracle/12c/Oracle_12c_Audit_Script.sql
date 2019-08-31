/*
############################################################
# Author       :  Benson Macharia
# Description  :  Oracle 12c CIS Benchmark Audit Script
# GitHub       :  https://github.com/bensonmacharia/CIS-Benchmark-Scripts
############################################################
*/

set echo on
REM **************************************************************************
REM Oracle 12c CIS Benchmark Audit Script
REM Author - Benson Macharia
REM **************************************************************************

set echo off
set termout on
set heading on
set feedback off
set trimspool on
set linesize 200
set pagesize 200
set markup html on spool on

Spool Oracle_12c_CIS_Audit_Dump.html

prompt -----------------------------------------
prompt [Test]: Ensure All Default Passwords Are Changed
prompt [Query] : SELECT USERNAME FROM DBA_USERS_WITH_DEFPWD WHERE USERNAME NOT LIKE '%XS$NULL%';
prompt [Output]:
SELECT USERNAME FROM DBA_USERS_WITH_DEFPWD WHERE USERNAME NOT LIKE '%XS$NULL%';
prompt [Expected Output]: Empty Result
prompt [Remediation]: For each username run PASSWORD <username> 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure All Sample Data And Users Have Been Removed 
prompt [Query] : SELECT USERNAME FROM ALL_USERS WHERE USERNAME IN ('BI','HR','IX','OE','PM','SCOTT','SH');
prompt [Output]:
SELECT USERNAME FROM ALL_USERS WHERE USERNAME IN ('BI','HR','IX','OE','PM','SCOTT','SH');
prompt [Expected Output]: Empty Result
prompt [Remediation]: Execute $ORACLE_HOME/demo/schema/drop_sch.sql and then DROP USER SCOTT CASCADE;	  
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Manual Test]: Ensure 'SECURE_CONTROL_<listener_name>' Is Set In 'listener.ora'
prompt [Expected Output]: In the $ORACLE_HOME/network/admin/listener.ora ensure each listener has an associated SECURE_CONTROL_<listener_name> directive
prompt [Remediation]: Set the SECURE_CONTROL_<listener_name> for each defined listener in the listener.ora	
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Manual Test]: Ensure 'extproc' Is Not Present in 'listener.ora'	  
prompt [Expected Output]: Run grep -i extproc $ORACLE_HOME/network/admin/listener.ora and ensure extproc does not exist
prompt [Remediation]: Remove extproc from the listener.ora file
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Manual Test]: Ensure 'ADMIN_RESTRICTIONS_<listener_name>' Is Set to 'ON'
prompt [Expected Output]: Run grep -i admin_restrictions $ORACLE_HOME/network/admin/listener.ora and ensure ADMIN_RESTRICTIONS_<listener_name> is set to ON for	all listeners
prompt [Remediation]: Set the ADMIN_RESTRICTIONS_<listener_name> value to ON
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Manual Test]: Ensure 'SECURE_REGISTER_<listener_name>' Is Set to 'TCPS' or 'IPC'
prompt [Expected Output]: grep -i SECURE_REGISTER $ORACLE_HOME/network/admin/listener.ora and ensure SECURE_REGISTER_<listener_name> is set to TCPS or IPC
prompt [Remediation]: For each listener set the SECURE_REGISTER_<listener_name>=TCPS or SECURE_REGISTER_<listener_name>=IPC
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'AUDIT_SYS_OPERATIONS' Is Set to 'TRUE' 	
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME) = 'AUDIT_SYS_OPERATIONS';
prompt [Output]:
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME) = 'AUDIT_SYS_OPERATIONS';
prompt [Expected Output]: AUDIT_SYS_OPERATIONS Value Is Set to 'TRUE'
prompt [Remediation]: ALTER SYSTEM SET AUDIT_SYS_OPERATIONS = TRUE SCOPE=SPFILE; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'AUDIT_TRAIL' Is Set to 'OS','DB,EXTENDED', or 'XML,EXTENDED' 	
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='AUDIT_TRAIL';
prompt [Output]:
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='AUDIT_TRAIL';
prompt [Expected Output]: AUDIT_TRAIL VALUE is set to OS or	DB,EXTENDED or XML,EXTENDED.	  
prompt [Remediation]: ALTER SYSTEM SET AUDIT_TRAIL = 'DB,EXTENDED' SCOPE = SPFILE; or ALTER SYSTEM SET AUDIT_TRAIL = 'OS' SCOPE = SPFILE; or ALTER SYSTEM SET AUDIT_TRAIL = 'XML,EXTENDED' SCOPE = SPFILE;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'GLOBAL_NAMES' Is Set to 'TRUE' 	
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='GLOBAL_NAMES';
prompt [Output]:
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='GLOBAL_NAMES';
prompt [Expected Output]: GLOBAL_NAMES VALUE is set to TRUE
prompt [Remediation]: ALTER SYSTEM SET GLOBAL_NAMES = TRUE SCOPE = SPFILE;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'LOCAL_LISTENER' Is Set Appropriately 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='LOCAL_LISTENER';
prompt [Output]:
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='LOCAL_LISTENER';
prompt [Expected Output]: VALUE is	set to (DESCRIPTION=(ADDRESS= (PROTOCOL=IPC)(KEY=REGISTER)))	
prompt [Remediation]: ALTER SYSTEM SET LOCAL_LISTENER='[description]' SCOPE = BOTH;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'O7_DICTIONARY_ACCESSIBILITY' Is Set to 'FALSE' 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='O7_DICTIONARY_ACCESSIBILITY';
prompt [Output]:
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='O7_DICTIONARY_ACCESSIBILITY';
prompt [Expected Output]: VALUE is set to FALSE
prompt [Remediation]: ALTER SYSTEM SET O7_DICTIONARY_ACCESSIBILITY=FALSE SCOPE = SPFILE;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'OS_ROLES' Is Set to 'FALSE' 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='OS_ROLES';
prompt [Output]:
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='OS_ROLES';
prompt [Expected Output]: VALUE is set to FALSE
prompt [Remediation]: ALTER SYSTEM SET OS_ROLES = FALSE SCOPE = SPFILE;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'REMOTE_LISTENER' Is Empty 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='REMOTE_LISTENER'; 
prompt [Output]:
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='REMOTE_LISTENER';
prompt [Expected Output]: Empty result
prompt [Remediation]: ALTER SYSTEM SET REMOTE_LISTENER = '' SCOPE = SPFILE;  
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'REMOTE_LOGIN_PASSWORDFILE' Is Set to 'NONE' 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='REMOTE_LOGIN_PASSWORDFILE';
prompt [Output]:
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='REMOTE_LOGIN_PASSWORDFILE';
prompt [Expected Output]: VALUE is set to NONE  
prompt [Remediation]: ALTER SYSTEM SET REMOTE_LOGIN_PASSWORDFILE = 'NONE' SCOPE = SPFILE; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'REMOTE_OS_AUTHENT' Is Set to 'FALSE' 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='REMOTE_OS_AUTHENT';
prompt [Output]:
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='REMOTE_OS_AUTHENT';
prompt [Expected Output]: VALUE is set to FALSE
prompt [Remediation]: ALTER SYSTEM SET REMOTE_OS_AUTHENT = FALSE SCOPE = SPFILE;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'REMOTE_OS_ROLES' Is Set to 'FALSE' 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='REMOTE_OS_ROLES';
prompt [Output]:
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='REMOTE_OS_ROLES';
prompt [Expected Output]: VALUE is set to FALSE	  
prompt [Remediation]: ALTER SYSTEM SET REMOTE_OS_ROLES = FALSE SCOPE = SPFILE;
prompt -----------------------------------------	

prompt -----------------------------------------
prompt [Test]: Ensure 'UTIL_FILE_DIR' Is Empty 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='UTIL_FILE_DIR';
prompt [Output]:
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='UTIL_FILE_DIR';
prompt [Expected Output]: Empty result
prompt [Remediation]: ALTER SYSTEM SET UTIL_FILE_DIR = '' SCOPE = SPFILE;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'SEC_CASE_SENSITIVE_LOGON' Is Set to 'TRUE' 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SEC_CASE_SENSITIVE_LOGON';
prompt [Output]: 
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SEC_CASE_SENSITIVE_LOGON'; 
prompt [Expected Output]: VALUE is set to TRUE	  
prompt [Remediation]: ALTER SYSTEM SET SEC_CASE_SENSITIVE_LOGON = TRUE SCOPE = SPFILE; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'SEC_MAX_FAILED_LOGIN_ATTEMPTS' Is Set to '10' 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SEC_MAX_FAILED_LOGIN_ATTEMPTS'; 
prompt [Output]: 
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SEC_MAX_FAILED_LOGIN_ATTEMPTS'; 
prompt [Expected Output]: VALUE is set to 10
prompt [Remediation]: ALTER SYSTEM SET SEC_MAX_FAILED_LOGIN_ATTEMPTS = 10 SCOPE = SPFILE;
prompt ----------------------------------------- 

prompt ----------------------------------------- 
prompt [Test]: Ensure 'SEC_PROTOCOL_ERROR_FURTHER_ACTION' Is Set to 'DELAY,3' or 'DROP,3' 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SEC_PROTOCOL_ERROR_FURTHER_ACTION';
prompt [Output]:  
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SEC_PROTOCOL_ERROR_FURTHER_ACTION';
prompt [Expected Output]: VALUE is set to DELAY,3 or DROP,3
prompt [Remediation]: ALTER SYSTEM SET SEC_PROTOCOL_ERROR_FURTHER_ACTION = 'DELAY,3' SCOPE = SPFILE; or ALTER SYSTEM SET SEC_PROTOCOL_ERROR_FURTHER_ACTION = 'DROP,3' SCOPE = SPFILE;
prompt ----------------------------------------- 

prompt ----------------------------------------- 
prompt [Test]: Ensure 'SEC_PROTOCOL_ERROR_TRACE_ACTION' Is Set to 'LOG' 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SEC_PROTOCOL_ERROR_TRACE_ACTION'; 
prompt [Output]: 
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SEC_PROTOCOL_ERROR_TRACE_ACTION';
prompt [Expected Output]: VALUE is set to LOG
prompt [Remediation]: ALTER SYSTEM SET SEC_PROTOCOL_ERROR_TRACE_ACTION=LOG SCOPE = SPFILE; 
prompt ----------------------------------------- 

prompt ----------------------------------------- 
prompt [Test]: Ensure 'SEC_RETURN_SERVER_RELEASE_BANNER' Is Set to 'FALSE' 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SEC_RETURN_SERVER_RELEASE_BANNER'; 
prompt [Output]: 
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SEC_RETURN_SERVER_RELEASE_BANNER';
prompt [Expected Output]: VALUE is set to FALSE
prompt [Remediation]: ALTER SYSTEM SET SEC_RETURN_SERVER_RELEASE_BANNER = FALSE SCOPE = SPFILE; 
prompt ----------------------------------------- 

prompt ----------------------------------------- 
prompt [Test]: Ensure 'SQL92_SECURITY' Is Set to 'FALSE' 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SQL92_SECURITY'; 
prompt [Output]: 
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='SQL92_SECURITY';   
prompt [Expected Output]: VALUE is set to SCOPE
prompt [Remediation]: ALTER SYSTEM SET SQL92_SECURITY = FALSE SCOPE = SPFILE;
prompt ----------------------------------------- 

prompt ----------------------------------------- 
prompt [Test]: Ensure '_TRACE_FILES_PUBLIC'	Is Set to 'FALSE' 
prompt [Query] : SELECT VALUE FROM V$PARAMETER WHERE NAME='_trace_files_public';
prompt [Output]: 
SELECT VALUE FROM V$PARAMETER WHERE NAME='_trace_files_public'; 
prompt [Expected Output]: VALUE equal to FALSE or empty result
prompt [Remediation]: ALTER SYSTEM SET "_trace_files_public" = FALSE SCOPE = SPFILE; 
prompt ----------------------------------------- 

prompt ----------------------------------------- 
prompt [Test]: Ensure 'RESOURCE_LIMIT' Is Set to 'TRUE' 
prompt [Query] : SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='RESOURCE_LIMIT'; 
prompt [Output]: 
SELECT UPPER(VALUE) FROM V$PARAMETER WHERE UPPER(NAME)='RESOURCE_LIMIT';
prompt [Expected Output]: VALUE is set to TRUE
prompt [Remediation]: ALTER SYSTEM SET RESOURCE_LIMIT = TRUE SCOPE = SPFILE; 
prompt ----------------------------------------- 

prompt ----------------------------------------- 
prompt [Test]: Ensure 'FAILED_LOGIN_ATTEMPTS' Is Less than or Equal to '5' 
prompt [Query] : SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='FAILED_LOGIN_ATTEMPTS' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT > 5); 
prompt [Output]: 
SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='FAILED_LOGIN_ATTEMPTS' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT > 5); 
prompt [Expected Output]: Empty result
prompt [Remediation]: ALTER PROFILE <profile_name> LIMIT FAILED_LOGIN_ATTEMPTS 5; 
prompt ----------------------------------------- 

prompt ----------------------------------------- 
prompt [Test]: Ensure 'PASSWORD_LOCK_TIME' Is Greater than or Equal to '1' 
prompt [Query] : SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='PASSWORD_LOCK_TIME' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT < 1);
prompt [Output]: 
SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='PASSWORD_LOCK_TIME' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT < 1);
prompt [Expected Output]: Empty result
prompt [Remediation]: ALTER PROFILE <profile_name> LIMIT PASSWORD_LOCK_TIME 1;
prompt ----------------------------------------- 

prompt -----------------------------------------
prompt [Test]: Ensure 'PASSWORD_LIFE_TIME' Is Less than or Equal to '90' 
prompt [Query] : SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='PASSWORD_LIFE_TIME' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT > 90);
prompt [Output]: 
SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='PASSWORD_LIFE_TIME' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT > 90);
prompt [Expected Output]: Empty result
prompt [Remediation]: ALTER PROFILE <profile_name> LIMIT PASSWORD_LIFE_TIME 90; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'PASSWORD_REUSE_MAX' Is Greater than or Equal to '20' 
prompt [Query] : SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='PASSWORD_REUSE_MAX' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT < 20); 
prompt [Output]: 
SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='PASSWORD_REUSE_MAX' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT < 20); 
prompt [Expected Output]: Empty result
prompt [Remediation]: ALTER PROFILE <profile_name> LIMIT PASSWORD_REUSE_MAX 20;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'PASSWORD_REUSE_TIME' Is Greater than or Equal to '365' 
prompt [Query] : SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='PASSWORD_REUSE_TIME' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT < 365); 
prompt [Output]: 
SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='PASSWORD_REUSE_TIME' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT < 365);
prompt [Expected Output]: Empty result
prompt [Remediation]: ALTER PROFILE <profile_name> LIMIT PASSWORD_REUSE_TIME 365; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'PASSWORD_GRACE_TIME' Is Less than or Equal to '5' 
prompt [Query] : SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='PASSWORD_GRACE_TIME' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT > 5);
prompt [Output]: 
SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='PASSWORD_GRACE_TIME' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT > 5);
prompt [Expected Output]: Empty result
prompt [Remediation]: ALTER PROFILE <profile_name> LIMIT PASSWORD_GRACE_TIME 5;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'DBA_USERS.PASSWORD' Is Not Set to 'EXTERNAL' for Any User 
prompt [Query] : SELECT USERNAME FROM DBA_USERS WHERE PASSWORD='EXTERNAL'; 
prompt [Output]: 
SELECT USERNAME FROM DBA_USERS WHERE PASSWORD='EXTERNAL';
prompt [Expected Output]: Empty result
prompt [Remediation]: ALTER USER <username> IDENTIFIED BY <password>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'PASSWORD_VERIFY_FUNCTION' Is Set for All Profiles 
prompt [Query] : SELECT PROFILE, RESOURCE_NAME FROM DBA_PROFILES WHERE RESOURCE_NAME='PASSWORD_VERIFY_FUNCTION' AND (LIMIT = 'DEFAULT' OR LIMIT = 'NULL');
prompt [Output]: 
SELECT PROFILE, RESOURCE_NAME FROM DBA_PROFILES WHERE RESOURCE_NAME='PASSWORD_VERIFY_FUNCTION' AND (LIMIT = 'DEFAULT' OR LIMIT = 'NULL');
prompt [Expected Output]: Empty result
prompt [Remediation]: Create a custom password verification function which fulfills the password requirements of the organization.
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'SESSIONS_PER_USER' Is Less than or Equal to '10' 
prompt [Query] : SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='SESSIONS_PER_USER' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT > 10);
prompt [Output]: 
SELECT PROFILE, RESOURCE_NAME, LIMIT FROM DBA_PROFILES WHERE RESOURCE_NAME='SESSIONS_PER_USER' AND (LIMIT = 'DEFAULT' OR LIMIT = 'UNLIMITED' OR LIMIT > 10);
prompt [Expected Output]: Empty result
prompt [Remediation]: ALTER PROFILE <profile_name> LIMIT SESSIONS_PER_USER 10;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure No Users Are Assigned the 'DEFAULT' Profile 
prompt [Query] : SELECT USERNAME FROM DBA_USERS WHERE PROFILE='DEFAULT' AND ACCOUNT_STATUS='OPEN' AND USERNAME NOT IN ('ANONYMOUS', 'CTXSYS', 'DBSNMP', 'EXFSYS', 'LBACSYS', 'MDSYS', 'MGMT_VIEW','OLAPSYS','OWBSYS', 'ORDPLUGINS', 'ORDSYS', 'OUTLN', 'SI_INFORMTN_SCHEMA', 'SYS', 'SYSMAN', 'SYSTEM', 'TSMSYS', 'WK_TEST', 'WKSYS', 'WKPROXY', 'WMSYS', 'XDB', 'CISSCAN');
prompt [Output]: 
SELECT USERNAME FROM DBA_USERS WHERE PROFILE='DEFAULT' AND ACCOUNT_STATUS='OPEN' AND USERNAME NOT IN ('ANONYMOUS', 'CTXSYS', 'DBSNMP', 'EXFSYS', 'LBACSYS', 'MDSYS', 'MGMT_VIEW','OLAPSYS','OWBSYS', 'ORDPLUGINS', 'ORDSYS', 'OUTLN', 'SI_INFORMTN_SCHEMA', 'SYS', 'SYSMAN', 'SYSTEM', 'TSMSYS', 'WK_TEST', 'WKSYS', 'WKPROXY', 'WMSYS', 'XDB', 'CISSCAN');
prompt [Expected Output]: Empty result
prompt [Remediation]:  ALTER USER <username> PROFILE <appropriate_profile>
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_ADVISOR' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_ADVISOR';
prompt [Output]: 
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_ADVISOR';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_ADVISOR FROM PUBLIC; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_CRYPTO' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND TABLE_NAME='DBMS_CRYPTO';
prompt [Output]: 
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND TABLE_NAME='DBMS_CRYPTO';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_CRYPTO FROM PUBLIC;  
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_JAVA' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_JAVA'; 
prompt [Output]: 
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_JAVA'; 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_JAVA FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_JAVA_TEST' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_JAVA_TEST'; 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_JAVA_TEST FROM PUBLIC; 
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_JAVA_TEST';
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_JOB' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_JOB';
prompt [Output]: 
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_JOB';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_JOB FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_LDAP' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_LDAP';
prompt [Output]: 
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_LDAP';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_LDAP FROM PUBLIC; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_LOB' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_LOB';
prompt [Output]: 
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_LOB';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_LOB FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_OBFUSCATION_TOOLKIT' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_OBFUSCATION_TOOLKIT';
prompt [Output]: 
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_OBFUSCATION_TOOLKIT';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_OBFUSCATION_TOOLKIT FROM PUBLIC; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_BACKUP_RESTORE' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_BACKUP_RESTORE';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_BACKUP_RESTORE';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_BACKUP_RESTORE FROM PUBLIC; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_SCHEDULER' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_SCHEDULER';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_SCHEDULER'; 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_SCHEDULER FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_SQL' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_SQL';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_SQL';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_SQL FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_XMLGEN' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_XMLGEN'; 
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_XMLGEN';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_XMLGEN FROM PUBLIC;  
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_XMLQUERY' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_XMLQUERY';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_XMLQUERY';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_XMLQUERY FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'UTL_FILE' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_FILE';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_FILE';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON UTL_FILE FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'UTL_INADDR' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_INADDR';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_INADDR'; 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON UTL_INADDR FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'UTL_TCP' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_TCP';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_TCP'; 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON UTL_TCP FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'UTL_MAIL' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_MAIL';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_MAIL';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON UTL_MAIL FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'UTL_SMTP' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_SMTP';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_SMTP';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON UTL_SMTP FROM PUBLIC; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'UTL_DBWS' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_DBWS'; 
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_DBWS'; 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON UTL_DBWS FROM 'PUBLIC'; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'UTL_ORAMTS' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_ORAMTS';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_ORAMTS';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON UTL_ORAMTS FROM PUBLIC; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'UTL_HTTP' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_HTTP';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='UTL_HTTP';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON UTL_HTTP FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'HTTPURITYPE' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='HTTPURITYPE';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='HTTPURITYPE';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON HTTPURITYPE FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_SYS_SQL' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_SYS_SQL'; 
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_SYS_SQL'; 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_SYS_SQL FROM PUBLIC; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_BACKUP_RESTORE'
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_BACKUP_RESTORE';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_BACKUP_RESTORE';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_BACKUP_RESTORE FROM PUBLIC;
prompt -----------------------------------------	

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_AQADM_SYSCALLS' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_AQADM_SYSCALLS';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_AQADM_SYSCALLS'; 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_AQADM_SYSCALLS FROM PUBLIC; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_REPACT_SQL_UTL' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_REPACT_SQL_UTL';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_REPACT_SQL_UTL';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_REPACT_SQL_UTL FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'INITJVMAUX' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='INITJVMAUX';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='INITJVMAUX';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON INITJVMAUX FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_STREAMS_ADM_UTL' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_STREAMS_ADM_UTL';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_STREAMS_ADM_UTL';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_STREAMS_ADM_UTL FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE' Is Revoked from 'PUBLIC' on 'DBMS_AQADM_SYS' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_AQADM_SYS';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_AQADM_SYS';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_AQADM_SYS FROM PUBLIC; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE'	Is Revoked from 'PUBLIC' on 'DBMS_STREAMS_RPC' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_STREAMS_RPC';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_STREAMS_RPC';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_STREAMS_RPC FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE'	Is Revoked from 'PUBLIC' on 'DBMS_PRVTAQIM' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_PRVTAQIM';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_PRVTAQIM';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_PRVTAQIM FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE'	Is Revoked from 'PUBLIC' on 'LTADM' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='LTADM'; 
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='LTADM';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON LTADM FROM PUBLIC; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE'	Is Revoked from 'PUBLIC' on 'WWV_DBMS_SQL' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='WWV_DBMS_SQL';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='WWV_DBMS_SQL'; 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON WWV_DBMS_SQL FROM PUBLIC;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE'	Is Revoked from 'PUBLIC' on 'WWV_EXECUTE_IMMEDIATE' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='WWV_EXECUTE_IMMEDIATE';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='WWV_EXECUTE_IMMEDIATE';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON WWV_EXECUTE_IMMEDIATE FROM PUBLIC; 
prompt -----------------------------------------  

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE'	Is Revoked from 'PUBLIC' on 'DBMS_IJOB' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_IJOB';
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_IJOB';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_IJOB FROM PUBLIC; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE'	Is Revoked from 'PUBLIC' on 'DBMS_FILE_TRANSFER' 
prompt [Query] : SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_FILE_TRANSFER'; 
prompt [Output]:
SELECT PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE='PUBLIC' AND PRIVILEGE='EXECUTE' AND TABLE_NAME='DBMS_FILE_TRANSFER'; 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ON DBMS_FILE_TRANSFER FROM PUBLIC; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'SELECT_ANY_DICTIONARY' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE  FROM DBA_SYS_PRIVS  WHERE PRIVILEGE='SELECT ANY DICTIONARY'  AND GRANTEE NOT IN ('DBA','DBSNMP','OEM_MONITOR','OLAPSYS','ORACLE_OCM','SYSMAN','WMSYS'); 
prompt [Output]:
SELECT GRANTEE, PRIVILEGE  FROM DBA_SYS_PRIVS  WHERE PRIVILEGE='SELECT ANY DICTIONARY'  AND GRANTEE NOT IN ('DBA','DBSNMP','OEM_MONITOR','OLAPSYS','ORACLE_OCM','SYSMAN','WMSYS');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE SELECT_ANY_DICTIONARY FROM <grantee>;  
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'SELECT ANY TABLE' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='SELECT ANY TABLE' AND GRANTEE NOT IN ('DBA', 'MDSYS', 'SYS', 'IMP_FULL_DATABASE', 'EXP_FULL_DATABASE', 'DATAPUMP_IMP_FULL_DATABASE', 'WMSYS', 'SYSTEM','OLAP_DBA', 'DV_REALM_OWNER');
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='SELECT ANY TABLE' AND GRANTEE NOT IN ('DBA', 'MDSYS', 'SYS', 'IMP_FULL_DATABASE', 'EXP_FULL_DATABASE', 'DATAPUMP_IMP_FULL_DATABASE', 'WMSYS', 'SYSTEM','OLAP_DBA', 'DV_REALM_OWNER');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE SELECT ANY TABLE FROM <grantee>; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'AUDIT SYSTEM' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='AUDIT SYSTEM' AND GRANTEE NOT IN ('DBA','DATAPUMP_IMP_FULL_DATABASE','IMP_FULL_DATABASE','SYS','AUDIT_ADMIN');
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='AUDIT SYSTEM' AND GRANTEE NOT IN ('DBA','DATAPUMP_IMP_FULL_DATABASE','IMP_FULL_DATABASE','SYS','AUDIT_ADMIN');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE AUDIT SYSTEM FROM <grantee>;  
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXEMPT ACCESS POLICY' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS  WHERE PRIVILEGE='EXEMPT ACCESS POLICY';
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS  WHERE PRIVILEGE='EXEMPT ACCESS POLICY';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXEMPT ACCESS POLICY FROM <grantee>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'BECOME USER' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE  FROM DBA_SYS_PRIVS  WHERE PRIVILEGE='BECOME USER'  AND GRANTEE NOT IN ('DBA','SYS','IMP_FULL_DATABASE');
prompt [Output]:
SELECT GRANTEE, PRIVILEGE  FROM DBA_SYS_PRIVS  WHERE PRIVILEGE='BECOME USER'  AND GRANTEE NOT IN ('DBA','SYS','IMP_FULL_DATABASE');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE BECOME USER FROM <grantee>; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'CREATE_PROCEDURE' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='CREATE PROCEDURE' AND GRANTEE NOT IN ( 'DBA','DBSNMP','MDSYS','OLAPSYS','OWB$CLIENT','OWBSYS','RECOVERY_CATALOG_OWNER','SPATIAL_CSW_ADMIN_USR','SPATIAL_WFS_ADMIN_USR','SYS','APEX_030200','APEX_040000','APEX_040100','APEX_040200','DVF','RESOURCE','DV_REALM_RESOURCE','APEX_GRANTS_FOR_NEW_USERS_ROLE');
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='CREATE PROCEDURE' AND GRANTEE NOT IN ( 'DBA','DBSNMP','MDSYS','OLAPSYS','OWB$CLIENT','OWBSYS','RECOVERY_CATALOG_OWNER','SPATIAL_CSW_ADMIN_USR','SPATIAL_WFS_ADMIN_USR','SYS','APEX_030200','APEX_040000','APEX_040100','APEX_040200','DVF','RESOURCE','DV_REALM_RESOURCE','APEX_GRANTS_FOR_NEW_USERS_ROLE');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE CREATE_PROCEDURE FROM <grantee>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'ALTER SYSTEM' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE  FROM DBA_SYS_PRIVS WHERE PRIVILEGE='ALTER SYSTEM' AND GRANTEE NOT IN ('SYS','SYSTEM','APEX_030200','APEX_040000','APEX_040100','APEX_040200','DBA','EM_EXPRESS_ALL','SYSBACKUP','GSMADMIN_ROLE','GSM_INTERNAL','SYSDG','GSMADMIN_INTERNAL');
prompt [Output]:
SELECT GRANTEE, PRIVILEGE  FROM DBA_SYS_PRIVS WHERE PRIVILEGE='ALTER SYSTEM' AND GRANTEE NOT IN ('SYS','SYSTEM','APEX_030200','APEX_040000','APEX_040100','APEX_040200','DBA','EM_EXPRESS_ALL','SYSBACKUP','GSMADMIN_ROLE','GSM_INTERNAL','SYSDG','GSMADMIN_INTERNAL');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE ALTER SYSTEM FROM <grantee>; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'CREATE ANY LIBRARY' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS  WHERE PRIVILEGE='CREATE ANY LIBRARY' AND GRANTEE NOT IN ('SYS','SYSTEM','DBA','IMP_FULL_DATABASE');
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS  WHERE PRIVILEGE='CREATE ANY LIBRARY' AND GRANTEE NOT IN ('SYS','SYSTEM','DBA','IMP_FULL_DATABASE');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE CREATE ANY LIBRARY FROM <grantee>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'CREATE LIBRARY' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE  FROM DBA_SYS_PRIVS WHERE PRIVILEGE='CREATE LIBRARY' AND GRANTEE NOT IN ('SYS','SYSTEM','DBA','MDSYS','SPATIAL_WFS_ADMIN_USR','SPATIAL_CSW_ADMIN_USR','DVSYS','GSMADMIN_INTERNAL','XDB');
prompt [Output]:
SELECT GRANTEE, PRIVILEGE  FROM DBA_SYS_PRIVS WHERE PRIVILEGE='CREATE LIBRARY' AND GRANTEE NOT IN ('SYS','SYSTEM','DBA','MDSYS','SPATIAL_WFS_ADMIN_USR','SPATIAL_CSW_ADMIN_USR','DVSYS','GSMADMIN_INTERNAL','XDB');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE CREATE LIBRARY FROM <grantee>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'GRANT ANY OBJECT PRIVILEGE' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='GRANT ANY OBJECT PRIVILEGE' AND GRANTEE NOT IN ('DBA','SYS','IMP_FULL_DATABASE','DATAPUMP_IMP_FULL_DATABASE', 'EM_EXPRESS_ALL', 'DV_REALM_OWNER');
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='GRANT ANY OBJECT PRIVILEGE' AND GRANTEE NOT IN ('DBA','SYS','IMP_FULL_DATABASE','DATAPUMP_IMP_FULL_DATABASE', 'EM_EXPRESS_ALL', 'DV_REALM_OWNER');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE GRANT ANY OBJECT PRIVILEGE FROM <grantee>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'GRANT ANY ROLE' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='GRANT ANY ROLE' AND GRANTEE NOT IN ('DBA','SYS','DATAPUMP_IMP_FULL_DATABASE','IMP_FULL_DATABASE', 'SPATIAL_WFS_ADMIN_USR','SPATIAL_CSW_ADMIN_USR', 'GSMADMIN_INTERNAL','DV_REALM_OWNER', 'EM_EXPRESS_ALL', 'DV_OWNER');
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='GRANT ANY ROLE' AND GRANTEE NOT IN ('DBA','SYS','DATAPUMP_IMP_FULL_DATABASE','IMP_FULL_DATABASE', 'SPATIAL_WFS_ADMIN_USR','SPATIAL_CSW_ADMIN_USR', 'GSMADMIN_INTERNAL','DV_REALM_OWNER', 'EM_EXPRESS_ALL', 'DV_OWNER');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE GRANT ANY ROLE FROM <grantee>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'GRANT ANY PRIVILEGE' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='GRANT ANY PRIVILEGE' AND GRANTEE NOT IN ('DBA','SYS','IMP_FULL_DATABASE','DATAPUMP_IMP_FULL_DATABASE','DV_REALM_OWNER', 'EM_EXPRESS_ALL');
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='GRANT ANY PRIVILEGE' AND GRANTEE NOT IN ('DBA','SYS','IMP_FULL_DATABASE','DATAPUMP_IMP_FULL_DATABASE','DV_REALM_OWNER', 'EM_EXPRESS_ALL'); 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE GRANT ANY PRIVILEGE FROM <grantee>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'DELETE_CATALOG_ROLE' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE granted_role='DELETE_CATALOG_ROLE' AND GRANTEE NOT IN ('DBA','SYS');
prompt [Output]:
SELECT GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE granted_role='DELETE_CATALOG_ROLE' AND GRANTEE NOT IN ('DBA','SYS');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE DELETE_CATALOG_ROLE FROM <grantee>; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'SELECT_CATALOG_ROLE' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE granted_role='SELECT_CATALOG_ROLE' AND grantee not in ('DBA','SYS','IMP_FULL_DATABASE','EXP_FULL_DATABASE','OEM_MONITOR', 'SYSBACKUP','EM_EXPRESS_BASIC'); 
prompt [Output]:
SELECT GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE granted_role='SELECT_CATALOG_ROLE' AND grantee not in ('DBA','SYS','IMP_FULL_DATABASE','EXP_FULL_DATABASE','OEM_MONITOR', 'SYSBACKUP','EM_EXPRESS_BASIC'); 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE SELECT_CATALOG_ROLE FROM <grantee>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE_CATALOG_ROLE' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE granted_role='EXECUTE_CATALOG_ROLE' AND grantee not in ('DBA','SYS','IMP_FULL_DATABASE','EXP_FULL_DATABASE');
prompt [Output]:
SELECT GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE granted_role='EXECUTE_CATALOG_ROLE' AND grantee not in ('DBA','SYS','IMP_FULL_DATABASE','EXP_FULL_DATABASE'); 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE_CATALOG_ROLE FROM <grantee>; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'DBA' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE='DBA' AND GRANTEE NOT IN ('SYS','SYSTEM');
prompt [Output]:
SELECT GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE='DBA' AND GRANTEE NOT IN ('SYS','SYSTEM'); 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE DBA FROM <grantee>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'ALL' Is Revoked from Unauthorized 'GRANTEE' on 'AUD$'	
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='AUD$' AND GRANTEE NOT IN ('DELETE_CATALOG_ROLE');
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='AUD$' AND GRANTEE NOT IN ('DELETE_CATALOG_ROLE');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE ALL ON AUD$ FROM <grantee>; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'ALL' Is Revoked from Unauthorized 'GRANTEE' on 'USER_HISTORY$' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='USER_HISTORY$'; 
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='USER_HISTORY$';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE ALL ON USER_HISTORY$ FROM <grantee>; 
prompt ----------------------------------------- 

prompt -----------------------------------------
prompt [Test]: Ensure 'ALL' Is Revoked from Unauthorized 'GRANTEE' on 'LINK$' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='LINK$' AND GRANTEE NOT IN ('DV_SECANALYST'); 
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='LINK$' AND GRANTEE NOT IN ('DV_SECANALYST');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE ALL ON LINK$ FROM <grantee>; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'ALL'	Is Revoked from Unauthorized 'GRANTEE' on 'SYS.USER$' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='USER$' AND GRANTEE NOT IN ('CTXSYS','XDB','APEX_030200','APEX_040000','APEX_040100','APEX_040200','DV_SECANALYST','DVSYS','ORACLE_OCM'); 
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='USER$' AND GRANTEE NOT IN ('CTXSYS','XDB','APEX_030200','APEX_040000','APEX_040100','APEX_040200','DV_SECANALYST','DVSYS','ORACLE_OCM'); 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE ALL ON SYS.USER$ FROM <username>; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'ALL' Is Revoked from Unauthorized 'GRANTEE' on 'DBA_%' 
prompt [Query] : SELECT * FROM DBA_TAB_PRIVS  WHERE TABLE_NAME LIKE 'DBA_%'  and GRANTEE NOT IN ('APEX_030200','APPQOSSYS','AQ_ADMINISTRATOR_ROLE','CTXSYS', 'EXFSYS','MDSYS','OLAP_XS_ADMIN','OLAPSYS','ORDSYS','OWB$CLIENT','OWBSYS', 'SELECT_CATALOG_ROLE','WM_ADMIN_ROLE','WMSYS','XDBADMIN','LBACSYS', 'ADM_PARALLEL_EXECUTE_TASK','CISSCANROLE','APEX_040200','SYSKM','ORACLE_OCM', 'DVSYS','GSMADMIN_INTERNAL','XDB','SYSDG','SYS','AUDIT_ADMIN', 'AUDIT_VIEWER', 'CAPTURE_ADMIN', 'DBA', 'DV_ACCTMGR', 'DV_MONITOR', 'DV_SECANALYST'); 
prompt [Output]:
SELECT * FROM DBA_TAB_PRIVS  WHERE TABLE_NAME LIKE 'DBA_%'  and GRANTEE NOT IN ('APEX_030200','APPQOSSYS','AQ_ADMINISTRATOR_ROLE','CTXSYS', 'EXFSYS','MDSYS','OLAP_XS_ADMIN','OLAPSYS','ORDSYS','OWB$CLIENT','OWBSYS', 'SELECT_CATALOG_ROLE','WM_ADMIN_ROLE','WMSYS','XDBADMIN','LBACSYS', 'ADM_PARALLEL_EXECUTE_TASK','CISSCANROLE','APEX_040200','SYSKM','ORACLE_OCM', 'DVSYS','GSMADMIN_INTERNAL','XDB','SYSDG','SYS','AUDIT_ADMIN', 'AUDIT_VIEWER', 'CAPTURE_ADMIN', 'DBA', 'DV_ACCTMGR', 'DV_MONITOR', 'DV_SECANALYST');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE ALL ON DBA_ FROM <Non-DBA/SYS grantee>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'ALL' Is Revoked from Unauthorized 'GRANTEE' on 'SYS.SCHEDULER$_CREDENTIAL' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='SCHEDULER$_CREDENTIAL'; 
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE TABLE_NAME='SCHEDULER$_CREDENTIAL';
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE ALL ON SYS.SCHEDULER$_CREDENTIAL FROM <username>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'SYS.USER$MIG' Has Been Dropped 
prompt [Query] : SELECT OWNER, TABLE_NAME FROM ALL_TABLES WHERE OWNER='SYS' AND TABLE_NAME='USER$MIG'; 
prompt [Output]:
SELECT OWNER, TABLE_NAME FROM ALL_TABLES WHERE OWNER='SYS' AND TABLE_NAME='USER$MIG';
prompt [Expected Output]: Empty result
prompt [Remediation]: DROP TABLE SYS.USER$MIG;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure '%ANY%' Is Revoked from Unauthorized 'GRANTEE' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE LIKE '%ANY%' AND GRANTEE NOT IN ('AQ_ADMINISTRATOR_ROLE','DBA','DBSNMP','EXFSYS','EXP_FULL_DATABASE','IMP_FULL_DATABASE','DATAPUMP_IMP_FULL_DATABASE','JAVADEBUGPRIV','MDSYS','OEM_MONITOR','OLAPSYS','OLAP_DBA','ORACLE_OCM','OWB$CLIENT','OWBSYS','SCHEDULER_ADMIN','SPATIAL_CSW_ADMIN_USR','SPATIAL_WFS_ADMIN_USR','SYS','SYSMAN','SYSTEM','WMSYS','APEX_030200','APEX_040000','APEX_040100','APEX_040200','LBACSYS','SYSBACKUP','CTXSYS','OUTLN','DVSYS','ORDPLUGINS','ORDSYS','GSMADMIN_INTERNAL','XDB','SYSDG','AUDIT_ADMIN','DV_OWNER','DV_REALM_OWNER','EM_EXPRESS_ALL', 'RECOVERY_CATALOG_OWNER'); 
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE LIKE '%ANY%' AND GRANTEE NOT IN ('AQ_ADMINISTRATOR_ROLE','DBA','DBSNMP','EXFSYS','EXP_FULL_DATABASE','IMP_FULL_DATABASE','DATAPUMP_IMP_FULL_DATABASE','JAVADEBUGPRIV','MDSYS','OEM_MONITOR','OLAPSYS','OLAP_DBA','ORACLE_OCM','OWB$CLIENT','OWBSYS','SCHEDULER_ADMIN','SPATIAL_CSW_ADMIN_USR','SPATIAL_WFS_ADMIN_USR','SYS','SYSMAN','SYSTEM','WMSYS','APEX_030200','APEX_040000','APEX_040100','APEX_040200','LBACSYS','SYSBACKUP','CTXSYS','OUTLN','DVSYS','ORDPLUGINS','ORDSYS','GSMADMIN_INTERNAL','XDB','SYSDG','AUDIT_ADMIN','DV_OWNER','DV_REALM_OWNER','EM_EXPRESS_ALL', 'RECOVERY_CATALOG_OWNER'); 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE '<ANY Privilege>' FROM <grantee>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'DBA_SYS_PRIVS.%' Is Revoked from Unauthorized 'GRANTEE' with 'ADMIN_OPTION' Set to 'YES' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE ADMIN_OPTION='YES' AND GRANTEE not in ('AQ_ADMINISTRATOR_ROLE','DBA','OWBSYS', 'SCHEDULER_ADMIN','SYS','SYSTEM','WMSYS', 'APEX_040200','DVSYS','SYSKM','DV_ACCTMGR'); 
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE ADMIN_OPTION='YES' AND GRANTEE not in ('AQ_ADMINISTRATOR_ROLE','DBA','OWBSYS', 'SCHEDULER_ADMIN','SYS','SYSTEM','WMSYS', 'APEX_040200','DVSYS','SYSKM','DV_ACCTMGR');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE <privilege> FROM <grantee>; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure Proxy Users Have Only 'CONNECT' Privilege 
prompt [Query] : SELECT GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE GRANTEE IN (SELECT PROXY FROM DBA_PROXIES) AND GRANTED_ROLE NOT IN ('CONNECT');
prompt [Output]:
SELECT GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE GRANTEE IN (SELECT PROXY FROM DBA_PROXIES) AND GRANTED_ROLE NOT IN ('CONNECT');
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE CONNECT FROM <proxy_user>;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE ANY PROCEDURE' Is Revoked from 'OUTLN' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='EXECUTE ANY PROCEDURE' AND GRANTEE='OUTLN';
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='EXECUTE ANY PROCEDURE' AND GRANTEE='OUTLN'; 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ANY PROCEDURE FROM OUTLN;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Ensure 'EXECUTE ANY PROCEDURE' Is Revoked from 'DBSNMP' 
prompt [Query] : SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='EXECUTE ANY PROCEDURE' AND GRANTEE='DBSNMP';  
prompt [Output]:
SELECT GRANTEE, PRIVILEGE FROM DBA_SYS_PRIVS WHERE PRIVILEGE='EXECUTE ANY PROCEDURE' AND GRANTEE='DBSNMP'; 
prompt [Expected Output]: Empty result
prompt [Remediation]: REVOKE EXECUTE ANY PROCEDURE FROM DBSNMP; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'USER' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='USER' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS'; 
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='USER' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT USER;  
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'ALTER USER' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='ALTER USER' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS'; 
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='ALTER USER' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT ALTER USER; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'DROP USER' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='DROP USER' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='DROP USER' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT DROP USER;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'ROLE' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='ROLE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='ROLE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT ROLE; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'SYSTEM GRANT' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='SYSTEM GRANT' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='SYSTEM GRANT' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT SYSTEM GRANT; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'PROFILE' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='PROFILE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='PROFILE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT PROFILE;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'ALTER PROFILE' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='ALTER PROFILE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';  
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='ALTER PROFILE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';  
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT ALTER PROFILE; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'DROP	PROFILE' Audit	Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='DROP PROFILE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';  
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='DROP PROFILE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT DROP PROFILE;  
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'DATABASE LINK' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='DATABASE LINK' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';  
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='DATABASE LINK' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS'; 
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT DATABASE LINK; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'PUBLIC DATABASE LINK' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='PUBLIC DATABASE LINK' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='PUBLIC DATABASE LINK' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS'; 
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT PUBLIC DATABASE LINK;   
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'PUBLIC SYNONYM' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='PUBLIC SYNONYM' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';   
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='PUBLIC SYNONYM' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT PUBLIC SYNONYM; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'SYNONYM' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='SYNONYM' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS'; 
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='SYNONYM' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT SYNONYM; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'GRANT DIRECTORY' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='GRANT DIRECTORY' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS'; 
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='GRANT DIRECTORY' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT GRANT DIRECTORY;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'SELECT ANY DICTIONARY' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='SELECT ANY DICTIONARY' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='SELECT ANY DICTIONARY' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT SELECT ANY DICTIONARY;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'GRANT ANY OBJECT PRIVILEGE' Audit Option 
prompt [Query] : SELECT PRIVILEGE, SUCCESS, FAILURE FROM DBA_PRIV_AUDIT_OPTS WHERE PRIVILEGE='GRANT ANY OBJECT PRIVILEGE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS'; 
prompt [Output]:
SELECT PRIVILEGE, SUCCESS, FAILURE FROM DBA_PRIV_AUDIT_OPTS WHERE PRIVILEGE='GRANT ANY OBJECT PRIVILEGE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT GRANT ANY OBJECT PRIVILEGE;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'GRANT ANY PRIVILEGE' Audit Option 
prompt [Query] : SELECT PRIVILEGE, SUCCESS, FAILURE FROM DBA_PRIV_AUDIT_OPTS WHERE PRIVILEGE='GRANT ANY PRIVILEGE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Output]: 
SELECT PRIVILEGE, SUCCESS, FAILURE FROM DBA_PRIV_AUDIT_OPTS WHERE PRIVILEGE='GRANT ANY PRIVILEGE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT GRANT ANY PRIVILEGE; 
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'DROP ANY PROCEDURE' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='DROP ANY PROCEDURE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Output]: 
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='DROP ANY PROCEDURE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT DROP ANY PROCEDURE;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'ALL' Audit Option on 'SYS.AUD$' 
prompt [Query] : SELECT * FROM DBA_OBJ_AUDIT_OPTS WHERE OBJECT_NAME='AUD$' AND ALT='A/A' AND AUD='A/A' AND COM='A/A' AND DEL='A/A' AND GRA='A/A' AND IND='A/A' AND INS='A/A' AND LOC='A/A' AND REN='A/A' AND SEL='A/A' AND UPD='A/A' AND FBK='A/A';
prompt [Output]:
SELECT * FROM DBA_OBJ_AUDIT_OPTS WHERE OBJECT_NAME='AUD$' AND ALT='A/A' AND AUD='A/A' AND COM='A/A' AND DEL='A/A' AND GRA='A/A' AND IND='A/A' AND INS='A/A' AND LOC='A/A' AND REN='A/A' AND SEL='A/A' AND UPD='A/A' AND FBK='A/A';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT ALL ON SYS.AUD$ BY ACCESS;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'PROCEDURE' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='PROCEDURE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='PROCEDURE' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT PROCEDURE;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'ALTER SYSTEM' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='ALTER SYSTEM' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='ALTER SYSTEM' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT ALTER SYSTEM;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'TRIGGER' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='TRIGGER' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS'; 
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='TRIGGER' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS'; 
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT TRIGGER;
prompt -----------------------------------------

prompt -----------------------------------------
prompt [Test]: Enable 'CREATE SESSION' Audit Option 
prompt [Query] : SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='CREATE SESSION' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS';
prompt [Output]:
SELECT AUDIT_OPTION, SUCCESS, FAILURE FROM DBA_STMT_AUDIT_OPTS WHERE AUDIT_OPTION='CREATE SESSION' AND USER_NAME IS NULL AND PROXY_NAME IS NULL AND SUCCESS = 'BY ACCESS' AND FAILURE = 'BY ACCESS'; 
prompt [Expected Output]: Some results expected
prompt [Remediation]: AUDIT SESSION;
prompt -----------------------------------------

prompt end of script. Thank you. 
prompt https://github.com/bensonmacharia/CIS-Benchmark-Scripts
spool off
set markup html off
