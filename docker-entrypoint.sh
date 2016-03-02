#!/usr/bin/env bash

set -e

/etc/init.d/ssh start > /dev/null

useradd -m git
chown -R git:git "$CLOUD_CODE_HOME" > /dev/null

su git -c 'mkdir -p /home/git/.ssh > /dev/null > /dev/null'
su git -c 'touch /home/git/.ssh/authorized_keys > /dev/null'

mkdir -p /parse-cloud-code

git init --bare /parse-cloud-code

cat << EOF > /parse-cloud-code/hooks/post-receive
#!/bin/bash
unset GIT_INDEX_FILE
git --work-tree="$CLOUD_CODE_HOME" clean -df
git --work-tree="$CLOUD_CODE_HOME" checkout -f
EOF

chmod a+x /parse-cloud-code/hooks/post-receive > /dev/null
chown -R git:git /parse-cloud-code

exec "$@"
