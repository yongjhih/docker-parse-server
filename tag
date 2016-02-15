#!/usr/bin/env bash

for i in 2.0.{0..8}; do
  sed -i 's/"parse-server": "[^"]\+"/"parse-server": "~'"$i"'"/' package.json
  git commit -am "Bump to $i"
  git tag -f "$i"
done

echo git push origin 2.0.{0..8}
