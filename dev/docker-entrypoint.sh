#!/usr/bin/env bash

set -e

/etc/init.d/ssh start

if [ ! -d /parse-cloud-code ]; then
  mkdir -p /parse-cloud-code
fi

if [ ! -d /parse/cloud ]; then
  mkdir -p /parse/cloud
fi

if [ ! -d /parse/lib/parse-cloud-code ]; then
  mkdir -p /parse/lib/parse-cloud-code
fi

pushd /parse-cloud-code
git init --bare

cat << EOF > /parse-cloud-code/hooks/post-receive
#!/bin/bash
unset GIT_INDEX_FILE
git --work-tree=/parse/lib/parse-cloud-code clean -df
git --work-tree=/parse/lib/parse-cloud-code checkout -f
EOF

chmod a+x /parse-cloud-code/hooks/post-receive
popd

chown -R git:git /parse-cloud-code
chown -R git:git /parse/cloud

npm run build

cp -a /parse/cloud/* /parse/lib/parse-cloud-code/
chown -R git:git /parse/lib/parse-cloud-code

npm start -- --appId $APP_ID --masterKey $MASTER_KEY --serverURL http://localhost:1337/parse --cloud /parse/lib/parse-cloud-code/main.js
