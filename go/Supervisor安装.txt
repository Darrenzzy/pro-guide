
mac安装Supervisor

brew install supervisor


不想让supervisor作为后台服务随系统启动，可以通过用指定配置文件的方式来启动：
supervisord -c /usr/local/etc/supervisord.ini


如果要让supervisor随系统自启动，用一下命令就可以了：
brew services start supervisor


默认的配置文件：/usr/local/etc/supervisord.ini



bin下输出配置信息命令：echo_supervisord_conf


//配置文件目录：
/usr/local/etc/supervisor.d


8.21

### supervisor常用命令
查看程序状态
sudo supervisorctl status
读取新增配置（不启动）
sudo supervisorctl reread
### 控制所有进程
sudo supervisorctl start all
sudo supervisorctl stop all
sudo supervisorctl restart all
### 控制指定进程
sudo supervisorctl stop testgroup:*
sudo supervisorctl start testgroup:*
sudo supervisorctl restart testgroup:*
sudo supervisorctl stop test
sudo supervisorctl restart test
载入最新的配置文件，停止原有进程并按新的配置启动、管理所有进程：
supervisorctl reload
根据最新的配置文件，启动新配置或有改动的进程，配置没有改动的进程不会受影响而重启：
supervisorctl update
配置文件位置：vim /etc/supervisor.d/....
go服务 /home/land/etc/conf.d/.....
编辑后记得要 supervisorctl reload
最后在重启任务  supervisorctl restart order-test:


建议其本身配置：
cat etc/supervisord.conf
[unix_http_server]
file=/home/land/tmp/supervisor.sock   ; (the path to the socket file)

[supervisord]
logfile=/alidata/logs/supervisord/supervisord.log ; (main log file;default $CWD/supervisord.log)
logfile_maxbytes=50MB        ; (max main logfile bytes b4 rotation;default 50MB)
logfile_backups=5           ; (num of main logfile rotation backups;default 10)
loglevel=info                ; (log level;default info; others: debug,warn,trace)
pidfile=/home/land/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
nodaemon=false               ; (start in foreground if true;default false)
minfds=1024                  ; (min. avail startup file descriptors;default 1024)
minprocs=200                 ; (min. avail process descriptors;default 200)

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///home/land/tmp/supervisor.sock ; use a unix:// URL  for a unix socket

[include]
files = /home/land/etc/conf.d/*.conf



supervis 本身配置文件路径：
files = /etc/supervisor/conf.d/*.conf
eg:conf.d/xxx.conf

[program:follow]
command=/home/land/beast/bin/follow_linux_amd64 -config-path=/home/land/beast/conf.d/follow.toml -loglevel=INFO
numprocs=1
priority=67
process_name=%(program_name)s_%(process_num)02d
autostart = true
autorestart = true
startsecs = 5
user = land
redirect_stderr = true
stdout_logfile = /alidata/logs/follow.%(process_num)02d.log


[program:etcd]
command=/home/land/etcd/bin/etcd -data-dir=/alidata/data/etcd  -listen-client-urls=http://0.0.0.0:2379 -advertise-client-urls=http://0.0.0.0:2379
numprocs=1
priority=1
process_name=%(program_name)s_%(process_num)02d
autostart = true
autorestart = true
startsecs = 5
user = land
redirect_stderr = true
stdout_logfile = /logs/etcd1.%(process_num)02d.log