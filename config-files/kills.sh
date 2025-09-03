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
echo ""

for process in $processes; do
    # 检查进程是否仍然存在
    if ! kill -0 "$process" 2>/dev/null; then
        echo "进程 $process 已不存在，跳过。"
        continue
    fi
    
    echo "PID: $process"
    
    # 获取进程启动时间
    start_time=$(ps -o lstart= -p "$process" 2>/dev/null | sed 's/^[[:space:]]*//')
    echo "启动时间: $start_time"
    
    # 获取 COMMAND 内容（与 ps aux 中相同）
    command=$(ps -o comm= -p "$process" 2>/dev/null | sed 's/^[[:space:]]*//')
    echo "命令: $command"
    
    echo "-------------------------------------------"
done

echo ""

for process in $processes; do
    # 再次检查进程是否存在
    if ! kill -0 "$process" 2>/dev/null; then
        echo "进程 $process 已不存在，跳过。"
        continue
    fi
    
    # 获取 COMMAND 信息用于确认提示
    command=$(ps -o comm= -p "$process" 2>/dev/null | sed 's/^[[:space:]]*//')
    
    read -p "是否结束进程 $process ($command)? (Y/N): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        kill -2 "$process"
        if [ $? -eq 0 ]; then
            echo "已发送终止信号给进程：$process"
            sleep 1
            # 检查进程是否真的被终止了
            if kill -0 "$process" 2>/dev/null; then
                echo "进程 $process 仍在运行，可能需要强制终止 (kill -9)"
            else
                echo "进程 $process 已成功终止"
            fi
        else
            echo "无法结束进程：$process"
        fi
    else
        echo "跳过进程：$process"
    fi
    echo ""
done

echo "脚本执行完毕。"
