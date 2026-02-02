#!/bin/bash
mkdir -p helm
cd helm
git config --global user.name "Github Actions"
git config --global user.email "development@kvalitetsit.dk"
git clone https://github.com/KvalitetsIT/helm-repo
cd helm-repo
mkdir -p tang
ls -a
cp ../../tang-*.tgz tang
helm repo index . --url https://raw.githubusercontent.com/KvalitetsIT/helm-repo/master/
git add -A
git commit -m "Adding new tang chart"
git push https://$1@github.com/KvalitetsIT/helm-repo