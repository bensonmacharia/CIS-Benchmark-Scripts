#!/bin/bash
sqlplus -s /nolog << EOF
CONNECT admin/password;

whenever sqlerror exit sql.sqlcode;
set echo off 
set heading off


exit;
EOF 