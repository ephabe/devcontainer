#!/bin/bash
cd `dirname $0`
source ./.env

# ローカルDBダンプ

DBHOST=${LOCAL_1_DBHOST}
DBPORT=${LOCAL_1_DBPORT}
DBUSER=${LOCAL_1_DBUSER}
DBPASS=${LOCAL_1_DBPASS}
DBNAME=${LOCAL_1_DBNAME}

CURRENT_DUMP_FILE="./files/log/local_$(date +%Y%m%d_%H%M%S).dump"
LATEST_DUMP_FILE="./files/local_latest.dump"

# データベースダンプ
mysqldump -h ${DBHOST} -P ${DBPORT} -u ${DBUSER} -p${DBPASS} ${DBNAME} --ssl-mode=DISABLED > ${CURRENT_DUMP_FILE}

cp ${CURRENT_DUMP_FILE} ${LATEST_DUMP_FILE}

echo "ダンプファイルが保存されました: ${CURRENT_DUMP_FILE}"
echo "ダンプファイルが保存されました: ${LATEST_DUMP_FILE}"
