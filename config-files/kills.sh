#!/bin/bash

if [ -z "$1" ]; then
    echo "请提供一个关键字作为参数。"
    exit 1
fi

keyword=$1
processes=$(pgrep -f "$keyword")

if [ -z "$processes" ]; then
    echo "没有找到与关键字相关的进程。"
    exit 1
fi

echo "找到以下进程："
echo "$processes"

for process in $processes; do
    read -p "是否结束进程 $process? (Y/N): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        kill $process
        if [ $? -eq 0 ]; then
            echo "已结束进程：$process"
        else
            echo "无法结束进程：$process"
        fi
    else
        echo "跳过进程：$process"
    fi
done

echo "脚本执行完毕。"

