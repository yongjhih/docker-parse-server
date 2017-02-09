#!/usr/bin/env bash

for i in 2.2.{23..25} 2.2.25-beta.1 2.3.{0..3}; do
  sed -i '' -e 's/"parse-server": "[^"]\+"/"parse-server": "'"$i"'"/' package.json
  git commit -am "Bump to $i"
  git tag -f "$i"
done

echo git push origin 2.2.{23..25} 2.2.25-beta.1 2.3.{0..3}
