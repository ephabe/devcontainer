#!/bin/bash
cd `dirname $0`
source ./.env

# 本番サーバーからファイルをrsync

SSH_CONFIG=${REMOTE_1_SSH_CONFIG}
FROM_DIR=${REMOTE_1_DIR_PATH}
TO_DIR=${LOCAL_1_DIR_PATH}

rsync -avz ${SSH_CONFIG}:${FROM_DIR}/ ${TO_DIR}/
