#!/bin/bash
cd `dirname $0`
source ./.env

# テストサーバーにSSHトンネルで入ってdumpからDBをrestore

LOCAL_PORT=3307

DBHOST=${REMOTE_2_DBHOST}
DBPORT=${REMOTE_2_DBPORT}
DBUSER=${REMOTE_2_DBUSER}
DBPASS=${REMOTE_2_DBPASS}
DBNAME=${REMOTE_2_DBNAME}

RESTORE_DUMP_FILE=./files/local_latest.dump

CONFIRM_WORD=${REMOTE_2_NAME}

# 確認対話
echo "${CONFIRM_WORD} のDBをリストアします。確認のため ${CONFIRM_WORD} と入力してください。"
read input
if [ $input != $CONFIRM_WORD ] ; then
    echo "処理中止"
    exit
fi

# SSHトンネル開始
ssh -L ${LOCAL_PORT}:${DBHOST}:${DBPORT} ${SSH_CONFIG} -f -N

#restore
mysql -h ${DBHOST} -P ${DBPORT} -u ${DBUSER} -p${DBPASS} ${DBNAME} < ${RESTORE_DUMP_FILE}


# SRDB_REPLACE_FROM=
# SRDB_REPLACE_TO=

# php ${SRDB_PATH} -h ${DBHOST} -P ${DBPORT} -u ${DBUSER} -p${DBPASS} -n ${DBNAME} -s "${SRDB_REPLACE_FROM}" -r "${SRDB_REPLACE_TO}" --exclude-cols="guid"


# SSHトンネル終了
# SSHトンネルのプロセスIDを取得し、killコマンドで終了させる
SSH_PID=$(pgrep -f "ssh -f -L ${LOCAL_PORT}:${DBHOST}:${DBPORT} ${SSH_CONFIG} -N")
kill ${SSH_PID}

echo "テストサーバーのDBをリストアしました。"