#!/bin/bash -e

ssh_repo="git@github.com:paulRbr/paulrbr.github.io.git"

# Commit middleman build directory
git clean -dfx -e public -e deploy_travis.pem
cd public && ls -la
git init
git add .
git config --global user.email "deploy@paul.bonaud.fr"
git config --global user.name "Deploy bot"
git commit -m "deploy: publishing github pages $(date)"

# Push to gh-pages branch!
git remote add origin $ssh_repo
git push -f origin HEAD:master
