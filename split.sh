#!/bin/bash

root_dir=$(cd "$(dirname "$0")";pwd)
os=`uname -s`
coin_connection_env=$(printenv coin_connection_env)
config_file="${root_dir}/config/development/environment.ini"
if [[ -z "${coin_connection_env// }" ]];then
    coin_connection_env=development
fi
if [[ ${coin_connection_env} == *"production"* ]]; then
    config_file="${root_dir}/config/production/environment.ini"
fi

pair='default';
while IFS= read -r line
do
    if [[ ${line} == *"otc_pair"* ]];then
        pair=$(echo ${line}|awk -F '=' '{print $2}'|sed 's/ //g')
    fi
done <"${config_file}"
