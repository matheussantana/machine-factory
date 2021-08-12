#!/usr/bin/env bash
set -x

# https://askubuntu.com/questions/28476/how-do-i-zip-up-a-folder-but-exclude-the-git-subfolder
# zip -r bitvolution.zip ./bitvolution -x '*.git*'

cd ../../

pwd
ls

zip -r ./pkg/v002.zip ./ -x '*.git'