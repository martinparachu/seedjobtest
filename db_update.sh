#!/bin/bash

source_server=10.10.0.183
source_port=5401
source_db="mwl_intranet_${source}"
source_owner_password=${source}_owner_password
source_owner_user=${source}_owner_user

target_server=10.10.0.183
target_port=5401
target_db="mwl_intranet_${target}"
target_owner_password=${target}_owner_password
target_owner_user=${target}_owner_user
target_app_password=${target}_app_password
target_app_user=${target}_app_user


echo $source_server
echo $source_port
echo $source_db
echo $source_owner_user

echo $target_server
echo $target_port
echo $target_db
echo $target_owner_user
echo $target_app_user

 
export PGPASSWORD=$source_owner_password

pg_dump -h $source_server -p $source_port -U $source_owner_user --no-owner --no-privileges --no-acl -n 'audit' --schema-only -Ft -b -v -f source_dump_audit.tar $source_db

export PGPASSWORD=$target_owner_password

pg_dump -h $target_server -p $target_port -U $target_owner_user --no-owner --no-privileges --no-acl -n 'queue' --schema-only -Ft -b -v -f target_dump_queue.tar $target_db
