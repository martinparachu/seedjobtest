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

#pg_dump -h $source_server -p $source_port -U ${!source_owner_user} --no-owner --no-privileges --no-acl -n $review_schema -T 'review."ReviewRule"' -T 'review."UserConfig"' -T 'review."Shortcut"' -F p -Ft -b -v -f rr_source_review_dump.tar $source_db
#pg_dump -h $source_server -p $source_port -U ${!source_owner_user} --no-owner --no-privileges --no-acl -n $public_schema -F p -Ft -b -v -f rr_source_public_dump.tar $source_db



target_server=10.10.0.183
target_port=5401
target_db=mwl_rr_stg
target_owner_user=mwl_rr_owner_stg
target_owner_password=947W6QL8kJ
target_app_user=mwl_rr_app_stg
target_app_password=947W6QL8kJ
target_master_db=postgres
target_master_user=postgres
target_master_password=b3be2caec4

	export PGPASSWORD=$target_master_password
	psql -h $target_server -p $target_port -U $target_master_user -d $target_master_db -c "CREATE USER $target_owner_user WITH PASSWORD '$target_owner_password'"
	psql -h $target_server -p $target_port -U $target_master_user -d $target_master_db -c "CREATE USER $target_app_user WITH PASSWORD '$target_app_password'"
	psql -h $target_server -p $target_port -U $target_master_user -d $target_master_db -c "ALTER  USER $target_owner_user CREATEDB"






