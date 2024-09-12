#!/bin/bash
cd `dirname $0`
source ./.env

# テストサーバーへファイルをrsyncでdeploy

SSH_CONFIG=${REMOTE_2_SSH_CONFIG}
FROM_DIR=${LOCAL_1_DIR_PATH}
TO_DIR=${REMOTE_2_DIR_PATH}

CONFIRM_WORD=${REMOTE_2_NAME}

# 確認対話
echo "${CONFIRM_WORD} へファイルを送信します。確認のため ${CONFIRM_WORD} と入力してください。"
read input
if [ $input != $CONFIRM_WORD ] ; then
    echo "処理中止"
    exit
fi

# rsync -avz ${FROM_DIR}/ ${SSH_CONFIG}:${TO_DIR}/
rsync -avz --exclude={'.git','.htaccess','adminer.php','wp-config.php','node_modules','.env','config.php'} ${FROM_DIR}/ ${SSH_CONFIG}:${TO_DIR}/
