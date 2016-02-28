#!/usr/bin/env bash

set -e

/etc/init.d/ssh start > /dev/null

if [ ! -d /parse-cloud-code ]; then
  mkdir -p /parse-cloud-code
fi

if [ ! -d /parse/cloud ]; then
  mkdir -p /parse/cloud
fi

pushd /parse-cloud-code > /dev/null
git init --bare > /dev/null

cat << EOF > /parse-cloud-code/hooks/post-receive
#!/bin/bash
unset GIT_INDEX_FILE
git --work-tree=/parse/cloud clean -df
git --work-tree=/parse/cloud checkout -f
EOF

chown -R git:git /parse-cloud-code > /dev/null
chown -R git:git /parse/cloud > /dev/null
chmod a+x /parse-cloud-code/hooks/post-receive > /dev/null
popd > /dev/null

exec "$@"
