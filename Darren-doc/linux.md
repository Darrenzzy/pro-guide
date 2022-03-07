# linux 常用总结

### 2.5
启动服务 发现端口起不来报：socket: too many open files

临时解决改配置： ulimit -n 4096 

### 11.10
zip命令使用 解压指定文件输出结果
unzip -o name.zip  -d newname
-o 覆盖式解压
-d 重命名解压

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

7.12
压缩目录：
tar -zcvf test.tar.gz test
解压 
tar -zxvf test.tar.gz ./


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


12.6
nsq异常断开：
查看：supervisorctl status |grep nsq
重启nsq：supervisorctl restart nsqlookup: nsqd: nsqadmin:

9.6常用远程命令， 拷贝复制
ssh land@172.16.164.9999 "rm -f ~/bin/game-server"
scp game-server land@172.16.164.9999:~/bin 
ssh land@172.16.164.9999 "supervisorctl restart gameserver:"


8.22
linux权限分配
–rwxr-xr-x 转换成权限数字为755
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
 ps -ef | grep nginx

vim 多标签和多窗口
:tabs  显示已打开标签页的列表，并用“>”标识出当前页面，用“+”标识出已更改的页面。
关闭标签页
:tabc  关闭当前标签页。
:tabo  关闭所有的标签页。
切换标签
:tabn  移动到下一个标签页。 gt
:tabp  移动到上一个标签页。 gT
tabf * .txt  允许你在当前目录搜索文件，tabf 
:tabnew file  等价  :tabe file   在新标签页中打开或新建文件file 

ansible使用

/etc/ansible/hosts:
[test]  # test分组
192.168.0.1  ansible_user=xxx  # 远程服务器地址，指定主机用户名

测试：
ansible all -m ping -u xxx

下载包命令
curl -O http://openresty.org/download/drizzle7-2011.07.21.tar.gz
解压包命令
tar -xzvf openresty-1.13.6.2.tar.gz

输出进程号：用命令： （忽略大小写）
ps ax| grep -i 'get_orders_detail'  | grep -v grep
查看进程数量
ps aux |grep kafka | wc -l   
<!-- 倒序输出 sort -n是按照数值进行由小到大进行排序， -r是表示逆序，-t是指定分割符，-k是执行按照第几列进行排序-->
 |sort -nkr 1 -t 
 <!-- 去前五个 -->
 |head -n 5 
 <!-- 去除空行 -->
 |grep -v "^$"
<!-- 使用awk命令可以按照分割符将一行分割为多个列，第一列用$1表示，第二列用$2表示，依次类推
awk -F" " '{print $2} //表示用空格作为分隔符进行分割，打印出第2列 -->
 | awk '{print $1}'
    <!-- 关键字前 5 行 -->
less *2021012621.log |grep -B 5 AP010012
    <!-- 关键字前后5 行 -->
less *2021012621.log |grep -C 5 AP010012

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

列出当前目录下个文件大小 
du -d 1 -h

查找且排序
du -sh * | sort -rh | head -10

列出所有的端口
netstat -ntlp

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

12.3
linux中读写 权限 执行 chmod 命令
-rw------- (600)      只有拥有者有读写权限。
-rw-r--r-- (644)      只有拥有者有读写权限；而属组用户和其他用户只有读权限。
-rwx------ (700)     只有拥有者有读、写、执行权限。
-rwxr-xr-x (755)    拥有者有读、写、执行权限；而属组用户和其他用户只有读、执行权限。
-rwx--x--x (711)    拥有者有读、写、执行权限；而属组用户和其他用户只有执行权限。
-rw-rw-rw- (666)   所有用户都有文件读、写权限。
-rwxrwxrwx (777)  所有用户都有读、写、执行权限。


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

ps aux 和ps -ef 
两者的输出结果区别不大，但展示风格不同。aux是BSD风格，-ef是System V风格
 
7.24


linux重启命令
reboot



拨号，连接远程主机，带端口号
telnet 39.108.61.252 9092
 
 
 
12.3
linux中读写 权限 执行 chmod 命令
-rw------- (600)      只有拥有者有读写权限。
-rw-r--r-- (644)      只有拥有者有读写权限；而属组用户和其他用户只有读权限。
-rwx------ (700)     只有拥有者有读、写、执行权限。
-rwxr-xr-x (755)    拥有者有读、写、执行权限；而属组用户和其他用户只有读、执行权限。
-rwx--x--x (711)    拥有者有读、写、执行权限；而属组用户和其他用户只有执行权限。
-rw-rw-rw- (666)   所有用户都有文件读、写权限。
-rwxrwxrwx (777)  所有用户都有读、写、执行权限。
