#!/bin/bash
usage() { echo "Usage: $0 [-u <string>] [-p <string>] [-s <string>]" 1>&2; exit 1; }

while getopts ":u:p:s:" o; do
    case "${o}" in
        u)
            u=${OPTARG}
            ;;
        p)
            p=${OPTARG}
            ;;
	s)
            s=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${u}" ] || [ -z "${p}" ] || [ -z "${s}" ]; then
    usage
fi

echo "Starting Oracle script"

sqlplus -s /nolog << EOF
CONNECT ${u}/${p}@${s};
  whenever sqlerror exit sql.sqlcode;
  @Oracle_12c_Audit_Script.sql
  exit;
EOF
ERR_CODE=$? # then $? is loaded with error received
if [[ 0 != "${ERR_CODE}" ]] ; then
  echo could not connect :\(
else 
  echo connection and script execution succeeded
fi
