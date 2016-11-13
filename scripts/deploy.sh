#!/bin/bash -e

# Commit middleman build directory
git clean -dfx -e public -e deploy_key.pem
mv public/* .
git add .
git commit -m "deploy: publishing github pages $(date)"

repo="$(git config --get remote.origin.url)"
ssh_repo="${repo/https:\/\/github.com\//git@github.com:}"

# Push to gh-pages branch!
git remote set-url origin $ssh_repo
git push -f origin HEAD:gh-pages
