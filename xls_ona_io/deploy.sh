#!/bin/bash

[[ -z "$1" ]] && echo "Usage: $0 version-of-drishti-forms-migrator-delivery-to-deploy" >&2 && exit 1
VERSION=$1
SNAPSHOT_VERSION=${VERSION}
FILENAME="drishti-forms-migrator-${VERSION}.tar"
SNAPSHOT_VERSION=`echo $VERSION | cut -d "-" -f1`
EXTRACTED_DIRECTORY="drishti-forms-migrator-'${SNAPSHOT_VERSION}'-SNAPSHOT/bin"

#copying content-migrator.yml to Prod
scp content-migrator.yml xlsonaio://root/config-content-migrator.yml

echo "FETCHING FILE: ${FILENAME}"
ssh xlsonaio '\
    export time=`date +%F_%T`; \
    mkdir -p old/backup-drishti-forms-migrator-'${VERSION}'.'${time}' && \
	pg_dump -U forms_migration_user forms_migration > old/backup-forms-migration-'${VERSION}'.'${time}'/backup-forms-migration-database-'${VERSION}'.'${time}' && \
    ([[ `ls | grep -q "drishti-forms-migrator.*"; echo $?` = 0 ]] && /bin/mv -f json-to-xls* old/backup-drishti-forms-migrator-'${VERSION}'.'${time}' || true) && \
    wget http://nexus.motechproject.org/content/repositories/drishti-forms-migrator/app/drishti-forms-migrator/'${SNAPSHOT_VERSION}'-SNAPSHOT/'${FILENAME}' && \
    tar -xvf '${FILENAME}' && \
	echo EXTRACTED DIRECTORY '${EXTRACTED_DIRECTORY}' && \
	cd '${EXTRACTED_DIRECTORY}' && \
	echo "Migrating Database"	&& \
	sh ./drishti-content-migrator db migrate ../../config-content-migrator.yml && \
	echo "Starting the service" && \
	sh ./drishti-content-migrator server ../../config-content-migrator.yml &'