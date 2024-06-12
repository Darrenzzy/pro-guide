# linux 常用总结

### 数学库
bc 是一个命令行工具，用于进行任意精度的算术运算。-l 选项是 bc 的一个参数，它代表 "mathematical library"，即数学库。
```
10^2
100
sqrt(100)
10
quit
```

### 临时适用保持会话session 作用
```bash
# 新增
$ tmux   $ tmux new -s <your_session_name>

# 列出所有快捷键，及其对应的 Tmux 命令
$ tmux list-keys

# 列出所有 Tmux 命令及其参数
$ tmux list-commands

# 列出当前所有 Tmux 会话的信息
$ tmux info

# 重新加载当前的 Tmux 配置
$ tmux source-file ~/.tmux.conf
# session 列表
$ tmux ls
# 重新連線 session
$ tmux a -t 0# OR
$ tmux a -t <session_name>
# 刪除 session
$ tmux kill-session -t 0# OR
$ tmux kill-session -t <session_name>
# OR
$ tmux kill-session -a # 全部
# 刪除 tmux server
$ tmux kill-server
# 重新命名 session
$ tmux rename-session -t 0 <new_session_name>

```

### 删除目录下所有大约10Mb文件

```bash
find ./ -type f -size +100M -delete
#!/bin/bash

# 指定要清理的目录
target_dir="/path/to/your/directory"

# 设置文件大小限制，单位为 MB
size_limit=10

# 查找大于 size_limit 的文件并删除
find "$target_dir" -type f -size +"$size_limit"M -delete

echo "已删除 $target_dir 目录下所有大于 ${size_limit}MB 的文件。"
```

### 关键字搜索
    grep -E 'PATH\='/etc/profile  ~/.*


### 文本关键字搜索
 ag -i foo /bar/
 ag -i 'PATH\=' ~/.pro*

### 将现在正在执行的linux命令放在后台执行
1. 通过命令： ctrl + z 来将当前的命令暂停。
2. 通过命令：bg 来启动后台暂停的任务。

### 网络连接问题

列出所有的端口
netstat -ntlp |grep  port

诊断tcp连接统计命令
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'



### 执行bash命令好方案
```bash
_load config.sh

# 载入脚本目录，执行config.sh脚本
_load() {
    local _dir="/etc/XXXX/src/"
    . "${_dir}$@"
}

```

### 查看指定进程id
pgrep -f /usr/bin/httpd

### ubuntu使用cgo musl执行需要预安装
mkdir /tmp && apt install musl-tools

### 抓包
 sudo tcpdump -iany -vv -nn host xxxx.com

### nginx限制 请求header中key的长度大小
large_client_header_buffers number size;
其中，number 是缓冲区的数量，size 是每个缓冲区的大小。为了限制请求头部键（key）的长度，需要设置合适的缓冲区大小。
如果要将限制应用于特定的location模块，可以将配置添加到相应的模块中：
```
server {
    ...
    location /example {
        ...
        large_client_header_buffers 4 4k;
        ...
    }
    ...
}
```

请注意，当请求头部超出设置的限制时，Nginx将返回414 Request-URI Too Large错误。

### 查看当前linux系统版本
lsb_release -a
uname -a

### shell中可以快速搜索历史命令ctrl+r
安装fzf ，https://github.com/junegunn/fzf 
linux:
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

### shell中判断文件是否存在快捷方式
[ -f ~/.fzf.zsh ] && echo 'yup,exist!'

### 获取当前机器网络 io 请求 和各个进程流量
* 各个进程流量
sudo nethogs

* 打印所有请求 tcp 记录
sudo tcpdump -i en0 -n  port 80 -vv

###根据命令名以及参数找到 PID
pgrep -a php


## 查看磁盘 io 和使用情况：
 * vmstat 命令报告关于线程、虚拟内存、磁盘、陷阱和 CPU 活动的统计信息。由 vmstat 命令生成的报告可以用于平衡系统负载活动。系统范围内的这些统计信息(所有的处理器中)都计算出以百分比表示的平均值，或者计算其总和：

 * iostat -dx 显示磁盘扩展信息 r/s 和 w/s 分别是每秒的读操作和写操作，而rKB/s 和wKB/s 列以每秒千字节为单位显示了读和写的数据量

### 字符串截取

a=123
echo ${a#2}
3

### 任务后台

&  加在一个命令的最后，可以把这个命令放到后台执行： watch  -n 10 sh  test.sh  &  #每10s在后台执行一次test.sh脚本
ctrl + z  可以将一个正在前台执行的命令放到后台，并且处于暂停状态。
jobs 查看当前有多少在后台运行的命令
fg 将后台中的命令调至前台继续运行。如果后台中有多个命令，可以用fg %jobnumber（是命令编号，不是进程号）
bg 将一个在后台暂停的命令，变成在后台继续执行。如果后台中有多个命令，可以用bg %jobnumber将选中的命令调出。
kill 通过jobs命令查看job号（假设为num），然后执行kill %num


### hexo
hexo clean //清除缓存文件 db.json 和已生成的静态文件 public

npm install hexo-deployer-git –save // 安装发布插件

hexo g == hexo generate //生成网站静态文件到默认设置的 public 文件夹
 
hexo d == hexo deploy //自动生成网站静态文件，并部署到设定的仓库。
 
hexo s == hexo server
 
hexo n == hexo new



### emac
文字删除
^ + k 删除光标后面所有字符（有剪切功能）
^ + u 删除整行字符(有剪切功能)
^ + w 向前删除一个单词
alt +d 删除后面一个单词
^ + q 删除整行字符
^ + y （粘贴）
^ + h 删除光标之前的字符


### 7.1
内存耗用：VSS/RSS/PSS/USS 的介绍:
一般来说内存占用大小有如下规律：VSS >= RSS >= PSS >= USS

VSS - Virtual Set Size 虚拟耗用内存（包含共享库占用的内存） （用处不大）
RSS - Resident Set Size 实际使用物理内存（包含共享库占用的内存）  （用处不大）
PSS - Proportional Set Size 实际使用的物理内存（比例分配共享库占用的内存）（仅供参考）
USS - Unique Set Size 进程独自占用的物理内存（不包含共享库占用的内存）（非常有用）

### 5.9
防火墙 解封ip：
# iptables -D INPUT -s xxx.xxx.xxx.xxx -j DROP
# iptables -D INPUT -s 121.0.0.0/8 -j DROP
封禁单个IP
# iptables -I INPUT -s xxx.xxx.xxx.xxx -j DROP
封禁IP段：
# iptables -I INPUT -s 121.0.0.0/8 -j DROP
清空已有规则
# iptables --flush
或者是
# iptables -F
保存规则
# service iptables save

  iptables -t nat -D PREROUTING -d 10.******.15.164/32 -p tcp -m tcp --dport 5432 -j DNAT --to-destination ******.114:5432
  iptables -t nat -D POSTROUTING -d ******.114/32 -p tcp -m tcp --dport 5432 -j SNAT --to-source ******.164
  iptables -S -t nat
  iptables -D -t nat -A PREROUTING -d ******.164/32 -p tcp -m tcp --dport 5432 -j DNAT --to-destination ******.100:5432
  iptables -t nat -A PREROUTING -d ******.164/32 -p tcp -m tcp --dport 5432 -j DNAT --to-destination ******.100:5432
  iptables -t nat -A POSTROUTING -d ******.100/32 -p tcp -m tcp --dport 5432 -j SNAT --to-source ******.164
  nginx -t

### 拉黑
iptables 常用命令
-A  追加规则    iptables -A INPUT

-D  删除规则    iptables -D INPUT 1(编号)

-R  修改规则    iptables -R INPUT 1(位置)  -s  IP地址  -j  DROP 取代现行规则顺序不变

禁用网宿：iptables -I INPUT -s 36.250.86.12 -j DROP

docker 处理容器网络命令：https://docs.docker.com/network/iptables/
假如我们只希望开放本机的服务给192.168.1.1-192.168.1.3这3个IP进行访问，本机的业务网卡为eth0：
iptables -I DOCKER-USER -m iprange -i eth0 ! --src-range 192.168.1.1-192.168.1.3 -j DROP

假如我们只希望开放本机的3306端口给192.168.1.0/24这个网段进行访问，本机的业务网卡为eth0：
iptables -I DOCKER-USER -i eth0 -p tcp --dport 3306 ! -s 192.168.1.0/24 -j DROP




ufw allow 54321/tcp # 注意：54321要改成你的端口
ufw allow 54321/udp # 注意：54321要改成你的端口
### 4.27
bash 日期显示
datetime=$(date  "+%Y%m%d_%H%M%S")
mv log/X.log log/X${datetime}.log


### 3.19
1.查看防火墙状态
      查看防火墙状态 systemctl status firewalld
      开启防火墙 systemctl start firewalld  
      关闭防火墙 systemctl stop firewalld
      开启防火墙 service firewalld start 
      若遇到无法开启
      先用：systemctl unmask firewalld.service 
      然后：systemctl start firewalld.service

2.查看对外开放的端口状态
      查询已开放的端口 netstat  -ntulp | grep 端口号：可以具体查看某一个端口号
      查询指定端口是否已开 firewall-cmd --query-port=666/tcp
      提示 yes，表示开启；no表示未开启。

3.对外开发端口
      查看想开的端口是否已开：firewall-cmd --query-port=6379/tcp
      添加指定需要开放的端口：firewall-cmd --add-port=123/tcp --permanent
      重载入添加的端口：firewall-cmd --reload
      查询指定端口是否开启成功：firewall-cmd --query-port=123/tcp
      移除指定端口：firewall-cmd --permanent --remove-port=123/tcp



### 3.17
显示当前文件的文件树：
```
find . -print | sed -e "s;[^/]*/;|__;g;s;__|;  |;g"

# 显示当前目录下所有匹配的文件
find . -name '*.pb.go'

```

### 3.10
linux 找出2天以前的文件
find ./  -type f -mtime +2 -exec ls -lh {} \;

linux 删除指定日期之前的文件
两种方法：
1. 在一个目录中保留最近三个月的文件，三个月前的文件自动删除。
find ~ -mtime +92 -type f -name *.mail[12] -exec rm -rf {} \;
find .  -mtime +92 -type f -name '*.log' |xargs rm -rf

2. 删除 指定文件 10分钟以前的文件
find ./  -name '*.out' -amin +10 -ls -exec rm -rf {} \;
```
/email/v1_bak --设置查找的目录；
-mtime +92 --设置时间为91天前；
-type f --设置查找的类型为文件；
-name *.mail[12] --设置文件名称中包含mail1或者mail2；
-exec rm -f --查找完毕后执行删除操作；
```
### 2.5
启动服务 发现端口起不来报：socket: too many open files
临时解决改配置： ulimit -n 4096 
### 11.10
zip命令使用 解压指定文件输出结果
 zip XXX.zip XXX
unzip -o name.zip  -d newname
-o 覆盖式解压
-d 重命名解压

压缩目录：
tar -zcvf test.tar.gz test
压缩多个目录
tar -zcvf archive.tar.gz folder1 folder2

解压 
tar -zxvf test.tar.gz ./


###6.8 查找文件批量条件复制  10 个小时内的文件复制到本地
find /ssd -name 'key-*.log' -mmin +600 -exec cp {} /home/ssd/ \;

### 12.5 ls ll 时间排序

* ls -alt # 按修改时间排序

* ls --sort=time -la # 等价于
* ls -alt

* ls -alc # 按创建时间排序

* ls -alu # 按访问时间排序
### 以上均可使用-r实现逆序排序
* ls -alrt # 按修改时间排序
* ls -alrc # 按创建时间排序
* ls -alru # 按访问时间排序


4.16
top 排行排序：
各进程（任务）的状态监控，项目列信息说明如下：
PID — 进程id
USER — 进程所有者
PR — 进程优先级
NI — nice值。负值表示高优先级，正值表示低优先级
VIRT — 进程使用的虚拟内存总量，单位kb。VIRT=SWAP+RES
RES — 进程使用的、未被换出的物理内存大小，单位kb。RES=CODE+DATA
SHR — 共享内存大小，单位kb
S — 进程状态。D=不可中断的睡眠状态 R=运行 S=睡眠 T=跟踪/停止 Z=僵尸进程
%CPU — 上次更新到现在的CPU时间占用百分比
%MEM — 进程使用的物理内存百分比
TIME+ — 进程使用的CPU时间总计，单位1/100秒
COMMAND — 进程名称（命令名/命令行）

快捷键：
x 列高亮 sort field;
通过”shift + >”或”shift + <”可以向右或左改变排序列
P 键 按照cpu使用率排序
M 键 按照内存使用率排序
l 键 切换显示平均负载和启动时间信息
m 键 切换显示内存信息
t 键 切换显示进程和cpu状态信息
c 键 切换显示命令名称和完成命令行信息


8.28
ubuntu  apt 自更新 确保资源最新
sudo apt-get update

8.13
CentOS 7/Red Hat 7/Aliyun Linux 2 [https://help.aliyun.com/knowledge_detail/175507.html?spm=5176.11065259.1996646101.searchclickresult.57944310ilrqMk]
在CentOS 7系统中，关于如何开启防火墙，关闭防火墙，查看防火墙运行状态，请参考以下信息：
开启防火墙
systemctl start firewalld.service
关闭防火墙
systemctl stop firewalld.service
查看防火墙运行状态
firewall-cmd --state


8.11
命令行安装 apk
查到在线设备，根据设备号emulator-5554 安装 app
./adb devices
./adb -s emulator-5554 install -t ~/Downloads/honour_wallet.apk



5.9
Linux如何查看IO读写很高(yum install sysstat)
iostat -x 1 10
找到 IO 占用高的进程
iotop -oP
3.1
命令:ls -lrt
-l     use a long listing format  以长列表方式显示（详细信息方式）
-t     sort by modification time 按修改时间排序（最新的在最前面）
-r     reverse order while sorting （反序）


9.6常用远程命令， 拷贝复制
ssh land@172.16.164.9999 "rm -f ~/bin/game-server"
scp game-server land@172.16.164.9999:~/bin 
ssh land@172.16.164.9999 "supervisorctl restart gameserver:"



7.24
查看systemctl的相关信息
whereis systemctl
列出所有可用单元
systemctl list-unit-files
列出所有运行中单元
systemctl list-units

```shell

 systemctl start httpd.service
 systemctl restart httpd.service
 systemctl stop httpd.service
 systemctl reload httpd.service
 systemctl status httpd.service
 systemctl kill httpd

```

 命令
 whereis 文件或者目录名称 
 which 可执行文件名称
 
7.12
将目前目录下的所有档案与子目录的拥有者皆设为 users 群体的使用者 lamport :
chmod -R lamport:users *
-rw------- (600) – 只有属主有读写权限。
-rw-r–r-- (644) – 只有属主有读写权限；而属组用户和其他用户只有读权限。
-rwx------ (700) – 只有属主有读、写、执行权限。
-rwxr-xr-x (755) – 属主有读、写、执行权限；而属组用户和其他用户只有读、执行权限。
-rwx–x--x (711) – 属主有读、写、执行权限；而属组用户和其他用户只有执行权限。
-rw-rw-rw- (666) – 所有用户都有文件读、写权限。这种做法不可取。
-rwxrwxrwx (777) – 所有用户都有读、写、执行权限。更不可取的做法。
以下是对目录的两个普通设定:

drwx------ (700) - 只有属主可在目录中读、写。
drwxr-xr-x (755) - 所有用户可读该目录，但只有属主才能改变目录中的内容。

linux权限分配
–rwxr-xr-x 转换成权限数字为755

6.26
crontab跑脚本  指定服务器
curl https://.....?user_id=9 --resolve ".........cc:443:172.1.1.1"

6.16
#### 环境变量 export命令

```shell
export -p #列出全部环境变量

export PATH=$PATH:123...  #临时导入，若永久的，请在bash_file脚本中添加

```

4.11
shell挂起命令  

```shell
nohup php artisan make:console  start >> log/redis_orders.log 2>&1 &

```

12.31
shell生产32位随机密码
date | md5sum |cut -c-32
pro
linux在shell中获取文件目录地址、全地址
root_dir=$(cd "$(dirname "$0")";pwd)

重定向目录文件，移动
mv -f dir1 dir2

利用命令grep在文件中搜索字符串
grep -rni broker.address.family /

ansible使用

/etc/ansible/hosts:
[test]  # test分组
192.168.0.1  ansible_user=xxx  # 远程服务器地址，指定主机用户名

测试：
ansible all -m ping -u xxx

下载包命令
curl -O http://openresty.org/download/drizzle7-2011.07.21.tar.gz

下载内容直接到指定文件中
curl -fLo demo.yaml http://XXXX.com/json
解压包命令
tar -xzvf openresty-1.13.6.2.tar.gz

ps aux | grep -v grep | grep IndicatorSentinel 
=>  zzy 4183126 87.1  0.4 6425240 3332104 pts/80 SNl 11:44  62:47 command
返回内容每一列含义：
USER (zha): 正在运行该进程的用户名。
PID (4183126): 进程的唯一标识符（Process ID）。
%CPU (87.1): 进程使用的 CPU 百分比。
%MEM (0.4): 进程使用的内存百分比。
VSZ (6425240): 进程的虚拟内存大小（单位：KB）。
RSS (3332104): 进程占用的实际物理内存大小（单位：KB）。
TTY (pts/80): 终端类型，指示进程是否与终端关联。在这里，"pts/80" 表示一个伪终端（pseudo terminal）。
STAT (SNl): 进程的状态信息，包括进程的状态标志，其中：
S: 进程处于休眠状态。
N: 进程没有关联的终端。
l: 进程是多线程的（使用 CLONE_THREAD，像 Python 这样的解释型语言通常会以多线程方式执行）。
START (11:44): 进程启动的时间。
TIME (62:47): 进程已经消耗的 CPU 时间。
COMMAND (/....): 正在执行的命令，包括命令及其参数。


输出进程号：用命令： （忽略大小写）
ps ax| grep -i 'get_orders_detail'  | grep -v grep
查看进程数量
ps aux |grep kafka | wc -l   
 倒序输出 sort -n是按照数值进行由小到大进行排序， -r是表示逆序，-t是指定分割符，-k是执行按照第几列进行排序
 |sort -nkr 1 -t 
  取前五个 显示前5行
 |head -n 5 
  取除空行 
 |grep -v "^$"
 使用awk命令可以按照分割符将一行分割为多个列，第一列用$1表示，第二列用$2表示，依次类推
awk -F" " '{print $2} //表示用空格作为分隔符进行分割，打印出第2列 
 
 | awk '{print $1}' // （第一列）
     关键字前 5 行 

awk去重
awk '{array[$1]++} END {for(key in array) printkey,array[key]}' 1.txt 
10.0.0.3 35
10.0.0.4 5

Linux命令行中使用管道查看列表的总数
command | wc -l
```
less *2021012621.log |grep -B 5 AP010012
//     关键字前后5 行 
less *2021012621.log |grep -C 5 AP010012

less -D 显示行号

```

more ./file  与less 作用差不多


查看cpu数量：
cat /proc/cpuinfo| grep "processor"| wc -l
全部杀掉kafka进程
ps aux |grep kafka |grep start |grep -v grep |awk '{print $2}' |xargs kill
查看进程树
pstree -p 2500

1.CPU占用最多的前10个进程：
ps auxw|head -1;ps auxw|sort -rn -k3|head -10
2.内存消耗最多的前10个进程
ps auxw|head -1;ps auxw|sort -rn -k4|head -10
3.虚拟内存使用最多的前10个进程
ps auxw|head -1;ps auxw|sort -rn -k5|head -10

查看端口，监听端口
sudo lsof -Pni4 | grep LISTEN | grep php

比较两个目录下的文件（目录比较命令）
diff -r dir1 dir2 
复制目录时，使用-r选项即可递归拷贝，如下：
cp -r dir1 dir2

如果dir2目录已存在，则需要使用
cp -r dir1/. dir2

linux 查找目录或文件
查找目录：find /（查找范围） -name '查找关键字' -type d
查找文件：find /（查找范围） -name 查找关键字 -print
 
 find ~ -iname  "*说明*"

linux 查找某目录下包含关键字内容的文件
grep -rn "test"  /data/reports
find /root/ –type f |xargs grep “www”  (linux)

 –type f : 文件类型是普通文件

lsof -i:5001 
 最后再：./restart.sh

查看端口：
lsof -i:80

查找大文件 
find / -type f -size +1G 
按文件大小 查找文件大小
find . -type f -size +50M  -print0 | xargs -0 du -h | sort -nr  

查看Linux查看内核版本
cat /proc/version
uname -a
查看linux版本
lsb_release -a

查看最后倒数500行的日志文件
 tail -n 500 /tmp/kafka_check_logs.log
 
查看关键字后的40行数据
 tail -n 500 /tmp/kafka_check_logs.log |grep "key" -C40

一次性递归新建目录命令
mkdir -p

linux定时任务

编辑： crontab -e   查看 crontab  -l

```shell

#以下是编辑中常用的：

#every 10s
#* * * * * sleep 10; /schdule_every_ten_sec.sh

#every min
* * * * * /schedule_every_min.sh

#every five min
*/5 * * * * /schedule_five_min.sh

#every ten min
*/10 * * * * /schedule_ten_min.sh

#every hour
0 * * * * /schedule_every_hour.sh

#every day
0 0 * * * /schedule_every_day.sh

#every 12:00
0 12 * * * /schedule_every_noon.sh

 # 每月的最后1天
    0 0 L * * *

    说明：
    Linux
    *    *    *    *    *
    -    -    -    -    -
    |    |    |    |    |
    |    |    |    |    +----- day of week (0 - 7) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
    |    |    |    +---------- month (1 - 12) OR jan,feb,mar,apr ...
    |    |    +--------------- day of month (1 - 31)
    |    +-------------------- hour (0 - 23)
    +------------------------- minute (0 - 59)

```

12.27
shell rm命令：
rm -r :删除目录
rm -f : 删除文件
-i ：执行前做个提醒


2:检索所有文件中匹配的字符串(find)
我一般使用: grep -nri key_word ./*
grep -i pattern files ：不区分大小写地搜索。默认情况区分大小写， 

grep -l pattern files ：只列出匹配的文件名， 

grep -L pattern files ：列出不匹配的文件名， 

grep -w pattern files ：只匹配整个单词，而不是字符串的一部分（如匹配‘magic’，而不是‘magical’）， 

grep -C number pattern files ：匹配的上下文分别显示[number]行， 

grep pattern1 | pattern2 files ：显示匹配 pattern1 或 pattern2 的行， 

grep pattern1 files | grep pattern2 ：显示既匹配 pattern1 又匹配 pattern2 的行。 

sed -n 4p file #打印file中的第4行


7.31 
查看当前目录每个文件夹的情况
du --max-depth=1 -h   /usr/
当前目录下大于500M目录
du -sh * -t +500M
列出当前文件夹下所有文件对应的大小
du -sh  *
指定目录磁盘使用情况
df -h /var
当前文件夹大小排序 
du -s * | sort -rn

 //目录空间占用
linux: du -h --max-depth=1
macos: du -h -d 1

df -hl 查看磁盘剩余空间
df -h 查看每个根路径的分区大小
du -sh [目录名] 返回该目录的大小
du -sm [文件夹] 返回该文件夹总M数

列出当前目录下个文件大小 
du -d 1 -h

查找且排序
du -sh * | sort -rh | head -10

ps aux 和ps -ef 
两者的输出结果区别不大，但展示风格不同。aux是BSD风格，-ef是System V风格
 
7.24
linux重启命令
reboot

拨号，连接远程主机，带端口号
telnet 39.108.61.252 9092
 