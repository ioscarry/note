#!/bin/bash

./outline.sh

git pull

git add *

git commit --amend

git push
