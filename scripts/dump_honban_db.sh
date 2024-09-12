#!/bin/bash
cd `dirname $0`
source ./.env

# 本番サーバーにSSHトンネルで入ってDBダンプを取得する

LOCAL_PORT=3307

SSH_CONFIG=${REMOTE_1_SSH_CONFIG}
DBHOST=${REMOTE_1_DBHOST}
DBPORT=${REMOTE_1_DBPORT}
DBUSER=${REMOTE_1_DBUSER}
DBPASS=${REMOTE_1_DBPASS}
DBNAME=${REMOTE_1_DBNAME}

CURRENT_DUMP_FILE="./files/log/${REMOTE_1_NAME}_$(date +%Y%m%d_%H%M%S).dump"
LATEST_DUMP_FILE="./files/${REMOTE_1_NAME}_latest.dump"

# SSHトンネル開始
ssh -L ${LOCAL_PORT}:${DBHOST}:${DBPORT} ${SSH_CONFIG} -f -N

# データベースダンプ
mysqldump -h 127.0.0.1 -P ${LOCAL_PORT} -u ${DBUSER} -p${DBPASS} ${DBNAME} --ssl-mode=DISABLED > ${CURRENT_DUMP_FILE}

# SSHトンネル終了
# SSHトンネルのプロセスIDを取得し、killコマンドで終了させる
SSH_PID=$(pgrep -f "ssh -f -L ${LOCAL_PORT}:${DBHOST}:${DBPORT} ${SSH_CONFIG} -N")
kill ${SSH_PID}

cp ${CURRENT_DUMP_FILE} ${LATEST_DUMP_FILE}

echo "ダンプファイルが保存されました: ${CURRENT_DUMP_FILE}"
echo "ダンプファイルが保存されました: ${LATEST_DUMP_FILE}"
