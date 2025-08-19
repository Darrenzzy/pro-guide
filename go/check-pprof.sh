#!/usr/bin/env bash

#每分钟 检查pprof 方便 随时定位问题


datetime=$(date  "+_%d_%H%M_")

arr=( "xxxxxx:8882" "xxxxxx:3011" "xxxxxx:3043" "xxxxxx:3051" )

#dir=/home/baseuser/
dir=~/

#mkdir ~/pprof
for i in "${arr[@]}"
do

# echo $i 123
curl --connect-timeout 2 -sK -v http://$i/debug/pprof/goroutine > ${dir}goroutine${datetime}$i.out
curl --connect-timeout 2 -sK -v http://$i/debug/pprof/heap > ${dir}heap${datetime}$i.out
curl --connect-timeout 2 -sK -v http://$i/debug/pprof/allocs > ${dir}allocs${datetime}$i.out

done
