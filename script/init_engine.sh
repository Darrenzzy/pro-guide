#!/bin/bash
for arg in "$@"
do 
    case ${arg} in
        -pair=*|--exchange_pair=*)
            pair="${arg#*=}"
            shift
            ;;
        --redis-port=*)
            redis_port="${arg#*=}"    
            shift
            ;;
        --redis-host=*)
            redis_host="${arg#*=}"
            shift
            ;;
        --ssdb-host=*)
            ssdb_host="${arg#*=}"
            shift
            ;;
        --ssdb-port=*)
            ssdb_port="${arg#*=}"    
            shift
            ;;
        --default)
            shift
        ;;
        *)    
    esac    
done
if [ -z ${redis_host} ];then
    redis_host=127.0.0.1
fi
if [ -z ${redis_port} ];then
    redis_port=6378
fi    
if [ -z ${ssdb_host} ];then
    ssdb_host=127.0.0.1
fi    
if [ -z ${ssdb_port} ];then
    ssdb_port=8801
fi    

echo ${pair}, ${redis_host}, ${redis_port}, ${ssdb_host}, ${ssdb_port}

exit

cd /usr/local/system/engine

upcase_pair="${pair^^}"
echo ${upcase_pair}

/usr/bin/git clone git@code.365yf.cc:sh_coin_server/exchange_engine.git
mv exchange_engine ${upcase_pair}
cd ${upcase_pair} && /usr/local/bin/composer install

environment=printenv env
if [ -z ${environment} ];then
    environment=development
fi

environment_path=config/${environment}/environment.ini

echo [engine] >> ${environment_path}
echo exchange_pair = ${upcase_pair} >> ${environment_path}
echo "" >> ${environment_path}

echo [redis] >> ${environment_path}
echo host = ${redis_host} >> ${environment_path}
echo port = ${redis_port} >> ${environment_path}
echo "" >> ${environment_path}

echo [ssdb] >> ${environment_path}
echo host = ${ssdb_host} >> ${environment_path}
echo port = ${ssdb_port} >> ${environment_path}
echo "" >> ${environment_path}

echo [async] >> ${environment_path}
echo trade_worker_num = 4 >> ${environment_path}
echo async_worker_num = 4 >> ${environment_path}

cd ..