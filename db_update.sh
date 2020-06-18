#!/bin/bash

source_server=10.10.0.183
source_port=5401
source_db=mwl_rr_restored
source_owner_user=stg_rr_owner_user
source_owner_password=stg_rr_owner_password

target_server=localhost
target_port=15432
target_db=mwl_rr_${target}
target_owner_password=${target}_rr_owner_password
target_owner_user=${target}_rr_owner_user
target_app_user=mwl_rr_app_${target}

review_schema=review
public_schema=public

export PGPASSWORD=${!source_owner_password}

pg_dump -h $source_server -p $source_port -U ${!source_owner_user} --no-owner --no-privileges --no-acl -n $review_schema -T 'review."ReviewRule"' -T 'review."UserConfig"' -T 'review."Shortcut"' -F p -Ft -b -v -f rr_source_review_dump.tar $source_db
pg_dump -h $source_server -p $source_port -U ${!source_owner_user} --no-owner --no-privileges --no-acl -n $public_schema -F p -Ft -b -v -f rr_source_public_dump.tar $source_db

export PGPASSWORD=${!target_owner_password}

psql -h $target_server -p $target_port -U ${!target_owner_user} -d $target_db -c 'DROP TABLE IF EXISTS review."LastActivity"'
psql -h $target_server -p $target_port -U ${!target_owner_user} -d $target_db -c 'DROP TABLE IF EXISTS review."MehlichOriginalResult"'
psql -h $target_server -p $target_port -U ${!target_owner_user} -d $target_db -c 'DROP TABLE IF EXISTS review."SampleComment"'
psql -h $target_server -p $target_port -U ${!target_owner_user} -d $target_db -c 'DROP TABLE IF EXISTS review."SampleHistory"'
psql -h $target_server -p $target_port -U ${!target_owner_user} -d $target_db -c 'DROP TABLE IF EXISTS review."SampleOriginalResult"'
psql -h $target_server -p $target_port -U ${!target_owner_user} -d $target_db -c 'DROP TABLE IF EXISTS review."SampleReRunReview"'
psql -h $target_server -p $target_port -U ${!target_owner_user} -d $target_db -c 'DROP TABLE IF EXISTS review."Test"'
psql -h $target_server -p $target_port -U ${!target_owner_user} -d $target_db -c 'DROP TABLE IF EXISTS review."WaterSolubleOriginalResult"'

psql -h $target_server -p $target_port -U ${!target_owner_user} -d $target_db -c 'DROP TABLE IF EXISTS public."__DbDeploy"'

pg_restore -U ${!target_owner_user} --no-owner --role=${!target_owner_user} -n $review_schema -Ft -v -h $target_server -p $target_port -d $target_db rr_source_review_dump.tar
pg_restore -U ${!target_owner_user} --no-owner --role=${!target_owner_user} -n $public_schema -Ft -v -h $target_server -p $target_port -d $target_db rr_source_public_dump.tar

psql -h $target_server -p $target_port -U ${!target_owner_user} -d $target_db -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA $review_schema TO $target_app_user;"
psql -h $target_server -p $target_port -U ${!target_owner_user} -d $target_db -c "GRANT USAGE ON SCHEMA $review_schema TO $target_app_user;"
