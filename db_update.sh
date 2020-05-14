#!/bin/bash

source_server=10.10.0.183
source_port=5401
source_db="mwl_intranet_${source}"
if [ "$source" == "val" ]; then
    source_owner_password=val_owner_password
    source_owner_user=val_owner_user
fi

target_server=10.10.0.183
target_port=5401
target_db="mwl_intranet_${target}"
if [ "$target" == "stg" ]; then
    target_owner_password=stg_owner_password
    target_owner_user=stg_owner_user
    target_app_password=stg_app_password
    target_app_user=stg_app_user
else
    target_owner_password=dev_owner_password
    target_owner_user=dev_owner_user
    target_app_password=dev_app_password
    target_app_user=dev_app_user
fi

echo source_server
echo source_port
echo source_db
echo source_owner_user

echo target_server
echo target_port
echo target_db
echo target_owner_user
echo target_app_user

 
export PGPASSWORD=$source_owner_password

#pg_dump -h $source_server -p $source_port -U $source_owner_user --no-owner --no-privileges --no-acl -n 'audit' --schema-only -Ft -b -v -f source_dump_audit.tar $source_db

export PGPASSWORD=$target_owner_password

#pg_dump -h $target_server -p $target_port -U $target_owner_user --no-owner --no-privileges --no-acl -n 'queue' --schema-only -Ft -b -v -f target_dump_queue.tar $target_db
