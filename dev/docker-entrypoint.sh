#!/usr/bin/env bash

set -e

/etc/init.d/ssh start > /dev/null

if [ ! -d /parse-cloud-code ]; then
    mkdir -p /parse-cloud-code

    git init --bare /parse-cloud-code > /dev/null

    cat << EOF > /parse-cloud-code/hooks/post-receive
#!/bin/bash
unset GIT_INDEX_FILE
git --work-tree="${CLOUD_CODE_HOME}" clean -df
git --work-tree="${CLOUD_CODE_HOME}" checkout -f
EOF

    chmod a+x /parse-cloud-code/hooks/post-receive > /dev/null

    chown -R git:git /parse-cloud-code > /dev/null
    chown -R git:git "$CLOUD_CODE_HOME" > /dev/null
fi

# mapping from cli-definitions.js
export PARSE_SERVER_APPLICATION_ID="${PARSE_SERVER_APPLICATION_ID:-$APP_ID}"
export PARSE_SERVER_MASTER_KEY="${PARSE_SERVER_MASTER_KEY:-$MASTER_KEY}"
export PARSE_SERVER_DATABASE_URI="${PARSE_SERVER_DATABASE_URI:-$DATABASE_URI}"
export PARSE_SERVER_SERVER_URL="${PARSE_SERVER_URL:-$SERVER_URL}"
export PARSE_SERVER_CLIENT_KEY="${PARSE_SERVER_CLIENT_KEY:-$CLIENT_KEY}"
export PARSE_SERVER_JAVASCRIPT_KEY="${PARSE_SERVER_JAVASCRIPT_KEY:-$JAVASCRIPT_KEY}"
export PARSE_SERVER_REST_API_KEY="${PARSE_SERVER_REST_API_KEY:-$REST_API_KEY}"
export PARSE_SERVER_DOT_NET_KEY="${PARSE_SERVER_DOT_NET_KEY:-$DOT_NET_KEY}"
export PARSE_SERVER_CLOUD_CODE_MAIN="${PARSE_SERVER_CLOUD_CODE_MAIN:-$CLOUD_CODE_MAIN}"
export PARSE_SERVER_PUSH="${PARSE_SERVER_PUSH:-$PUSH}"
export PARSE_SERVER_OAUTH_PROVIDERS="${PARSE_SERVER_OAUTH_PROVIDERS:-$OAUTH_PROVIDERS}"
export PARSE_SERVER_FILE_KEY="${PARSE_SERVER_FILE_KEY:-$FILE_KEY}"
export PARSE_SERVER_FACEBOOK_APP_IDS="${PARSE_SERVER_FACEBOOK_APP_IDS:-$FACEBOOK_APP_IDS}"
export PARSE_SERVER_ENABLE_ANON_USERS="${PARSE_SERVER_ENABLE_ANON_USERS:-$ENABLE_ANON_USERS}"
export PARSE_SERVER_ALLOW_CLIENT_CLASS_CREATION="${PARSE_SERVER_ALLOW_CLIENT_CLASS_CREATION:-$ALLOW_CLIENT_CLASS_CREATION}"
export PARSE_SERVER_MOUNT_PATH="${PARSE_SERVER_MOUNT_PATH:-$PARSE_MOUNT}"
export PARSE_SERVER_DATABASE_ADAPTER="${PARSE_SERVER_DATABASE_ADAPTER:-$DATABASE_ADAPTER}"
export PARSE_SERVER_FILES_ADAPTER="${PARSE_SERVER_FILES_ADAPTER:-$FILES_ADAPTER}"
export PARSE_SERVER_LOGGER_ADAPTER="${PARSE_SERVER_LOGGER_ADAPTER:-$LOGGER_ADAPTER}"
export PARSE_SERVER_MAX_UPLOAD_SIZE="${PARSE_SERVER_MAX_UPLOAD_SIZE:-$MAX_UPLOAD_SIZE}"

# Allow update /parse/cloud via git
sed -i 's#"start": "./bin/parse-server"#"start": "nodemon --watch /parse/cloud ./bin/parse-server"#' package.json > /dev/null

npm run build > /dev/null 2>&1
exec "$@"
