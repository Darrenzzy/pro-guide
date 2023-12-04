#!/bin/bash

# 检查是否提供了 URL
if [ "$#" -ne 1 ]; then
    echo "没有输入Url Usage: \$0 <url>"
    exit 1
fi

# 获取 URL
URL=$1
echo $URL

# 发送请求并获取时间指标
output=$(curl  -w "\
 time_namelookup=%{time_namelookup}\
 time_connect=%{time_connect}\
 time_appconnect=%{time_appconnect}\
 time_pretransfer=%{time_pretransfer}\
 time_starttransfer=%{time_starttransfer}\
 time_redirect=%{time_redirect}\
 time_total=%{time_total}" -o /dev/null -s "$URL")

echo $output

# 读取时间指标到变量
time_namelookup=$(echo $output | awk '{print $1}' | cut -d= -f2)
time_connect=$(echo $output | awk '{print $2}' | cut -d= -f2)
time_appconnect=$(echo $output | awk '{print $3}' | cut -d= -f2)
time_pretransfer=$(echo $output | awk '{print $4}' | cut -d= -f2)
time_starttransfer=$(echo $output | awk '{print $5}' | cut -d= -f2)
time_redirect=$(echo $output | awk '{print $6}' | cut -d= -f2)
time_total=$(echo $output | awk '{print $7}' | cut -d= -f2)

# 打印结果
echo "=================请求详细数据======================"

echo "从请求开始到域名解析完成的耗时 = $time_namelookup 秒"
echo "从请求开始到TCP三次握手完成耗时 = $time_connect 秒"
echo "从请求开始到TLS握手完成的耗时 = $time_appconnect 秒"
echo "从请求开始到向服务器发送第一个请求开始之前的耗时 = $time_pretransfer 秒"
echo "重定向时间，包括到内容传输前的重定向的 DNS 解析、TCP 连接、内容传输等时间 = $time_redirect 秒"
echo "从请求开始到内容传输前的时间 = $time_starttransfer 秒"
echo "总耗时 = $time_total 秒"

# 计算时间差值并格式化输出
tcp_handshake_time=$(echo | awk "{printf \"%.6f\", $time_connect - $time_namelookup}")
ssl_time=$(echo | awk "{printf \"%.6f\", $time_appconnect - $time_connect}")
server_processing_time=$(echo | awk "{printf \"%.6f\", $time_starttransfer - $time_pretransfer}")
ttfb=$(echo | awk "{printf \"%.6f\", $time_starttransfer - $time_appconnect}")

# 计算占比
time_namelookup_rate=$(echo "scale=4; ($time_namelookup/$time_total)*100" | bc)
tcp_handshake_time_rate=$(echo "scale=4; ($tcp_handshake_time/$time_total)*100" | bc)
ssl_time_rate=$(echo "scale=4; ($ssl_time/$time_total)*100" | bc)
server_processing_time_rate=$(echo "scale=4; ($server_processing_time/$time_total)*100" | bc)
ttfb_rate=$(echo "scale=4; ($ttfb/$time_total)*100" | bc)

# 打印结果
echo "================ 耗时分析========================"

printf "域名解析耗时 = %.6f 秒 ,占比 %.2f%%\n " "$time_namelookup" "$time_namelookup_rate"
printf "TCP 握手耗时 = %.6f 秒 ,占比 %.2f%%\n " "$tcp_handshake_time" "$tcp_handshake_time_rate"
printf "SSL 耗时 = %.6f 秒 ,占比 %.2f%%\n " "$ssl_time" "$ssl_time_rate"
printf "服务器处理请求耗时 = %.6f 秒 ,占比 %.2f%%\n " "$server_processing_time" "$server_processing_time_rate"
printf "TTFB = %.6f 秒 ,占比 %.2f%%\n " "$ttfb" "$ttfb_rate"
echo "总耗时 = $time_total 秒"
