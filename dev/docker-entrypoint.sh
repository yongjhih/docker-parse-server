#!/usr/bin/env bash

set -e

/etc/init.d/ssh start

if [ ! -d /parse-cloud-code ]; then
  mkdir -p /parse-cloud-code
fi

if [ ! -d /parse/cloud ]; then
  mkdir -p /parse/cloud
fi

pushd /parse-cloud-code
git init --bare

cat << EOF > /parse-cloud-code/hooks/post-receive
#!/bin/bash
unset GIT_INDEX_FILE
git --work-tree=/parse/cloud clean -df
git --work-tree=/parse/cloud checkout -f
EOF

chown -R git:git /parse-cloud-code
chown -R git:git /parse/cloud
chmod a+x /parse-cloud-code/hooks/post-receive
popd

npm run build

npm start -- --appId $APP_ID --masterKey $MASTER_KEY --serverURL http://localhost:1337/parse --cloud /parse/cloud/main.js
