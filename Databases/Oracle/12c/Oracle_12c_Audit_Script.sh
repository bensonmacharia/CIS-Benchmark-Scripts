sqlplus -s /nolog << EOF
CONNECT admin/password;

whenever sqlerror exit sql.sqlcode;
set echo off 
set heading off

@Oracle_12c_Audit_Script.sql

exit;
EOF 
