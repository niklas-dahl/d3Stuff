#!/bin/sh

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

commit_website_files() {
  echo "Checkout branch"
  git checkout gh-pages
  git add ./dist
  echo "Commit"
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  echo "add remote"
  git remote add origin-pages https://${GH_TOKEN}@github.com/niklas-dahl/d3Stuff.git > /dev/null 2>&1
  echo "push"
  git push --force --quiet --set-upstream origin-pages gh-pages 
}

setup_git
commit_website_files
upload_files
