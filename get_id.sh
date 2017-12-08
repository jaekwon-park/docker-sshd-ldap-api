#!/bin/bash
server_ip=$1
# get request ID
for i in $(ldapsearch -LLL -h ldap -D "cn=admin,dc=example,dc=com" -w admin_pass -x -b "ou=group,dc=example,dc=com" "(&(objectClass=*))" cn | grep cn: | awk '{print $2}'); do
    if [[ $(ldapsearch -LLL -h ldap -D "cn=admin,dc=example,dc=com" -w admin_pass -x -b "cn=$i,ou=host,dc=example,dc=com" "(&(objectClass=nisNetgroup)(nisNetgroupTriple=*))" | grep $server_ip | wc -l) -eq 1 ]]; then
        group_name=$(ldapsearch -LLL -h ldap -D "cn=admin,dc=example,dc=com" -w admin_pass -x -b "cn=$i,ou=group,dc=example,dc=com" "(&(objectClass=*))" gidNumber | grep gidNumber: | awk '{print $2}')
        id=$(ldapsearch -LLL -h ldap -D "cn=admin,dc=example,dc=com" -w admin_pass -x -b "ou=people,dc=example,dc=com" "(&(objectclass=posixAccount)(gidNumber=$group_name))" cn | grep ^cn: | awk '{print $2}')
        if [[ -f /key/$id.pub ]]; then
            echo $id.pub
        fi

    fi
done
# Get Admin ID
admin_group=$(ldapsearch -LLL -h ldap -D "cn=admin,dc=example,dc=com" -w admin_pass -x -b "cn=admin,ou=group,dc=example,dc=com" "(&(objectClass=*))" gidNumber | grep gidNumber: | awk '{print $2}')
admin_id=$(ldapsearch -LLL -h ldap -D "cn=admin,dc=example,dc=com" -w admin_pass -x -b "ou=people,dc=example,dc=com" "(&(objectclass=posixAccount)(gidNumber=$admin_group))" cn | grep ^cn: | awk '{print $2}')
if [[ -f /key/$admin_id.pub ]]; then
    echo $admin_id.pub
fi
