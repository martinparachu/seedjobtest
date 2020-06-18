#!/bin/bash

source_server=10.10.0.183
source_port=5401
source_db=mwl_rr_restored
source_owner_user=stg_rr_owner_user
source_owner_password=stg_rr_owner_password

target_server=10.10.0.183
target_port=5401
target_db=mwl_rr_${target}
target_owner_password=${target}_owner_password
target_owner_user=${target}_rr_owner_user
target_app_password=${target}_rr_owner_password
target_app_user=mwl_rr_app_${target}

review_schema=review
public_schema=public

export PGPASSWORD=${!source_owner_password}

echo pg_dump -h $source_server -p $source_port -U ${!source_owner_user} --no-owner --no-privileges --no-acl -n $review_schema -T 'review."ReviewRule"' -T 'review."UserConfig"' -T 'review."Shortcut"' -F p -Ft -b -v -f rr_source_review_dump.tar $source_db
echo pg_dump -h $source_server -p $source_port -U ${!source_owner_user} --no-owner --no-privileges --no-acl -n $public_schema -F p -Ft -b -v -f rr_source_public_dump.tar $source_db





