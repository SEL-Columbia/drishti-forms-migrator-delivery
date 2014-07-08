#!/bin/bash

[[ -z "$1" ]] && echo "Usage: $0 version-of-json-to-xls-delivery-to-deploy" >&2 && exit 1
VERSION=$1
SNAPSHOT_VERSION=${VERSION}
FILENAME="json-to-xls-${VERSION}.tar"
SNAPSHOT_VERSION=`echo $VERSION | cut -d "-" -f1`
EXTRACTED_DIRECTORY="json-to-xls-'${SNAPSHOT_VERSION}'-SNAPSHOT/bin"

#copying json-to-xls.yml to Prod
scp json-to-xls.yml prod://home/motech/config-json-to-xls.yml
scp api.txt prod://home/motech/api.txt

echo "FETCHING FILE: ${FILENAME}"
ssh prod '\
    export time=`date +%F_%T`; \
    mkdir -p old/backup-json-to-xls-'${VERSION}'.'${time}' && \
	pg_dump -U postgres json_to_xls > old/backup-json-to-xls-'${VERSION}'.'${time}'/backup-json-to-xls-database-'${VERSION}'.'${time}' && \
    ([[ `ls | grep -q "json-to-xls.*"; echo $?` = 0 ]] && /bin/mv -f json-to-xls* old/backup-json-to-xls-'${VERSION}'.'${time}' || true) && \
    wget http://nexus.motechproject.org/content/repositories/json-to-xls/io/ei/jsontoxls/json-to-xls/'${SNAPSHOT_VERSION}'-SNAPSHOT/'${FILENAME}' && \
    tar -xvf '${FILENAME}' && \
	echo '${EXTRACTED_DIRECTORY}' && \
	cd '${EXTRACTED_DIRECTORY}' && \
	cp /home/motech/api.txt /home/motech/'${EXTRACTED_DIRECTORY}'/api.txt && \	
	export JAVA_HOME=/usr/java/default && \
	echo "Migrating Database"	&& \
	sh ./json-to-xls db migrate ../../config-json-to-xls.yml && \
	echo "Starting the service" && \
	sh ./json-to-xls server ../../config-json-to-xls.yml &'
