linux参数调优


诊断tcp连接统计命令
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'


vi /etc/security/limits.conf 追加以下内容，增加打开文件数量
* soft nofile 1020000
* hard nofile 1020000
* soft nproc 655360
* hard nproc 655360
* soft stack unlimited
* hard stack unlimited
* soft memlock    250000000
* hard memlock    250000000

#  增加并发支持
vi /etc/rc.local 增加网络链接track, 有可能导致性能会大幅下降

/usr/sbin/modprobe nf_conntrack
/usr/sbin/modprobe ip_conntrack

# 若要立即生效，直接shell 运行  modprobe nf_conntrack


# TCP优化
# 在虚拟机下overcommit_memory，必须为0，不然程序容易崩溃

vi /etc/sysctl.conf #追加在最后

#回收TIME_WAIT连接
#不过这里隐藏着一个不易察觉的陷阱
#当多个客户端通过NAT方式联网并与服务端交互时，服务端看到的是同一个IP，也就是说对服务端而言这些客户端实际上等同于一个，
#可惜由于这些客户端的时间戳可能存在差异，于是乎从服务端的视角看，便可能出现时间戳错乱的现象，进而直接导致时间戳小的数据包被丢弃,connect失败
#所以一般建议php业务服务器不要开启
#net.ipv4.tcp_tw_recycle = 1
#TIME_WAIT连接复用,tcp_timestamps激活才有效, 连接发起方才有用
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1



net.ipv4.tcp_max_tw_buckets = 500000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_timestamps = 1
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 262144
net.ipv4.tcp_max_orphans = 262144
net.ipv4.tcp_max_syn_backlog = 819200

net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.ip_local_port_range = 9000 65500
net.ipv4.tcp_keepalive_time = 1200
fs.file-max = 1020000
vm.overcommit_memory = 0
fs.inotify.max_user_watches = 100000

net.nf_conntrack_max = 1020000
net.netfilter.nf_conntrack_max = 1020000
net.netfilter.nf_conntrack_tcp_timeout_established = 1200


kernel.shmall = 2097152
kernel.shmmax = 2147483648
kernel.shmmni = 4096
kernel.sem = 250 512000 100 2048
fs.aio-max-nr = 1048576
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 4194304

立即生效
sysctl -p

redis服务器
需要关闭THP
在/etc/re.local下面
echo never > /sys/kernel/mm/transparent_hugepage/enabled


时间校对
yum install ntp # 安装ntp, 已有忽略

#校对时间
ntpdate pool.ntp.org
定时校对
crontab -e
0 0 * * * /usr/sbin/ntpdate pool.ntp.org

#如果时间不对，检查时区
date -R 
中国在东八区， 应该类似的提示
Thu, 16 Apr 2015 11:02:48 +0800

更改时区 需要root权限
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime


线上服务器最好关闭密码登录, 仅使用证书登录, 注意配置此项时保留一个session会话，防止配置错误链接不上。
vim /etc/ssh/sshd_config
PasswordAuthentication no
#启用密钥验证
RSAAuthentication yes
PubkeyAuthentication yes
#指定公钥数据库文件
AuthorsizedKeysFile .ssh/authorized_keys
重启服务
service sshd restart
centos7 改为
systemctl restart sshd.service