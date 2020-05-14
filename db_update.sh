#!/bin/bash

source_server=10.10.0.183
source_port=5401
source_db=mwl_intranet_val

target_server=10.10.0.183
target_port=5401
target_db=mwl_intranet_stg

echo "parametros de jenkins"
echo $source 
echo $target

export PGPASSWORD=$source_owner_password

#pg_dump -h $source_server -p $source_port -U $source_owner_user --no-owner --no-privileges --no-acl -n 'audit' --schema-only -Ft -b -v -f source_dump_audit.tar $source_db

export PGPASSWORD=$target_owner_password

#pg_dump -h $target_server -p $target_port -U $target_owner_user --no-owner --no-privileges --no-acl -n 'queue' --schema-only -Ft -b -v -f target_dump_queue.tar $target_db
