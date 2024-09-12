#!/bin/bash
cd `dirname $0`
source ./.env

# dumpからlocalのDBをrestore

DBHOST=${LOCAL_1_DBHOST}
DBPORT=${LOCAL_1_DBPORT}
DBUSER=${LOCAL_1_DBUSER}
DBPASS=${LOCAL_1_DBPASS}
DBNAME=${LOCAL_1_DBNAME}

RESTORE_DUMP_FILE="./files/${REMOTE_1_DBNAME}_latest.dump"

mysql -h ${DBHOST} -P ${DBPORT} -u ${DBUSER} -p${DBPASS} ${DBNAME} < ${RESTORE_DUMP_FILE}

# SRDB_REPLACE_FROM=
# SRDB_REPLACE_TO=

# php ${SRDB_PATH} -h ${DBHOST} -P ${DBPORT} -u ${DBUSER} -p${DBPASS} -n ${DBNAME} -s "${SRDB_REPLACE_FROM}" -r "${SRDB_REPLACE_TO}" --exclude-cols="guid"
