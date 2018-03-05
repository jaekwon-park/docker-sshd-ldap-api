#!/bin/bash

PARSED_OPTION=$(getopt -n "$0" -o :a:p:b:s: --long "admin:,pass:,base:,server:" -- "$@")
if [ $? -ne 0 ]; then
  echo "invaild option "
  exit 1
fi
eval set -- "$PARSED_OPTION"
#echo $0" Argument Reparsed [ "$PARSED_OPTION " ]"

while true; do
  case $1 in
  -a | --admin)
    ADMIN_DN=$2
    shift 2
    ;;
  -p | --pass)
    ADMIN_DN_PASS=$2
    shift 2
    ;;
  -b | --base)
    LDAP_BASE=$2
    shift 2
    ;;
  -s | --server)
    server_ip=$2
    shift 2
    ;;
  --)
    shift
    break
    ;;
  esac
done

# get request ID
for i in $(ldapsearch -LLL -h ldap -D "$ADMIN_DN " -w $ADMIN_DN_PASS -x -b "ou=group,$LDAP_BASE" "(&(objectClass=*))" cn | grep cn: | awk '{print $2}'); do
    if [[ $(ldapsearch -LLL -h ldap -D "$ADMIN_DN " -w $ADMIN_DN_PASS -x -b "cn=$i,ou=host,$LDAP_BASE" "(&(objectClass=nisNetgroup)(nisNetgroupTriple=*))" | grep $server_ip | wc -l) -eq 1 ]]; then
        group_name=$(ldapsearch -LLL -h ldap -D "$ADMIN_DN " -w $ADMIN_DN_PASS -x -b "cn=$i,ou=group,$LDAP_BASE" "(&(objectClass=*))" gidNumber | grep gidNumber: | awk '{print $2}')
        id=$(ldapsearch -LLL -h ldap -D "$ADMIN_DN " -w $ADMIN_DN_PASS -x -b "ou=people,$LDAP_BASE" "(&(objectclass=posixAccount)(gidNumber=$group_name))" cn | grep ^cn: | awk '{print $2}')
        if [[ -f /key/$id.pub ]]; then
            echo $id.pub
        fi

    fi
done
# Get Admin ID
admin_group=$(ldapsearch -LLL -h ldap -D "$ADMIN_DN " -w $ADMIN_DN_PASS -x -b "cn=admin,ou=group,$LDAP_BASE" "(&(objectClass=*))" gidNumber | grep gidNumber: | awk '{print $2}')
admin_id=$(ldapsearch -LLL -h ldap -D "$ADMIN_DN " -w $ADMIN_DN_PASS -x -b "ou=people,$LDAP_BASE" "(&(objectclass=posixAccount)(gidNumber=$admin_group))" cn | grep ^cn: | awk '{print $2}')

for i in $admin_id; do
  if [[ -f /key/$i.pub ]]; then
      echo $i.pub
  fi
done
