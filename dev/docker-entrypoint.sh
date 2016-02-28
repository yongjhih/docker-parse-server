#!/usr/bin/env bash

set -e

/etc/init.d/ssh start > /dev/null

if [ ! -d /parse-cloud-code ]; then
  mkdir -p /parse-cloud-code > /dev/null
fi

if [ ! -d /parse/cloud ]; then
  mkdir -p /parse/cloud > /dev/null
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

# Allow update /parse/cloud via git
sed -i 's#"start": "./bin/parse-server"#"start": "nodemon --watch /parse/cloud ./bin/parse-server"#' package.json > /dev/null

npm run build > /dev/null 2>&1
eval "$@"
