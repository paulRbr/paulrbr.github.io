#!/bin/bash -e

# Commit middleman build directory
git clean -dfx -e public -e deploy_key.pem
mv public/* .
git add .
git commit -m "deploy: publishing github pages $(date)"

ssh_repo="git@github.com:paulRbr/paulrbr.github.io.git"

# Push to gh-pages branch!
git remote set-url origin $ssh_repo
git push -f origin HEAD:master
