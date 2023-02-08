#!/bin/bash

cd /Users/darren/projects/guide/config-files
ssh-add /Users/darren/.ssh/id_rsa.darrenmac13
cd ..
git add .
git commit -m "feat: auto job"
git push origin master	

