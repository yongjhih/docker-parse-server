#!/usr/bin/env bash

for i in 2.3.{0..1}; do
  sed -i 's/"parse-server": "[^"]\+"/"parse-server": "'"$i"'"/' package.json
  git commit -am "Bump to $i"
  git tag -f "$i"
done

echo git push origin 2.3.{0..1}
