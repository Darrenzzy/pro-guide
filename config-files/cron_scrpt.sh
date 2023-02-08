#!/bin/bash

cd /Users/darren/projects/guide/config-files
echo $PWD
cd ..
echo $PWD
git add .
git commit -m "feat: auto job"
git push origin master	

