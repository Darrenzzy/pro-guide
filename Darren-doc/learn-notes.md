# 学习笔记

### docker ldap-admin
docker pull osixia/phpldapadmin

docker run -dit \
-p 8081:80 \
--name ldapadmin \
--env PHPLDAPADMIN_HTTPS=false \
--env PHPLDAPADMIN_LDAP_HOSTS=ldap://10.7.69.198:389 \
--detach osixia/phpldapadmin

### 2021 6.1
本地启动 grpc 项目后不方便启动 client 来调试，于是选择用 grpcurl 工具方便调试；推荐姿势：
```
查看本地有哪些 grpc 服务
grpcurl -plaintext 127.0.0.1:{端口} list

查看本地 grpc 服务 下的 action
grpcurl -plaintext 127.0.0.1:{端口} list .....服务名

调用 grpc action
grpcurl -H 'token:cn01:a862a6eb-8c4' -d '{"params": "123456"}' -plaintext 127.0.0.1:{端口}  ....Service.HelloCoo
```

### 2021 5.10
遇到生产不打印非 fmt 类型日志，测试和开发环境正常，
代码一样，应该是配置原因，于是开始从启动 main排查，发现日志器 zap init 中没有配置 'stderr' 终端输出项，由于服务日志是终端输出重定向到日志文件的，这里加上以后解决。

### 2021 1.15
> iterm2快捷指令：
* cmd-opt-B 使用即时重播功能
* ctrl + a    到行首
* ctrl + e    到行尾
* ctrl + f/b  前进后退 (相当于左右方向键)
* ctrl + p    上一条命令
* ctrl + r    搜索命令历史
* ctrl + d    删除当前光标的字符
* ctrl + h    删除光标之前的字符
* ctrl + w    删除光标之前的单词
* ctrl + k    删除到文本末尾
* ctrl + t    交换光标处文本
* Command + / 查看当前终端中光标的位置

### 10.21 使用db2struct
```bash 
db2struct --host 192.168.1.1 --user root -p root --gorm --json -d database --package model --struct tablename -t table_name >table_name.go
```
### 12.31 php array

* 用于将一个数组  利用外来的arr的数据 更改其中的键值 并返回

>array_walk($list,function (&$a,$key,$arr){
            $a['state'] = $arr[$a['user_id']]["gouhao"];
            return $a;
        },$arr);

* 用户重新生成一个数组是有当前数组callback 生成的
 >array_map(function ($a){
            return $a['user_id'];
        },$list);


### goland phpstorm 
>远程配置setting：https://github.com/Darrenzzy/storm-config.git

### 8.1 判断标志符号：
* lt：less than 小于
* le：less than or equal to 小于等于
* eq：equal to 等于
* ne：not equal to 不等于
* ge：greater than or equal to 大于等于
* gt：greater than 大于


### 启动撮合引擎  几大步骤
* 先启动ssdb和redis （打开撮合引擎目录）
* redis-server /config/redis.conf
* ssdb-server -d /config/ssdb.conf
* 使用场景：前段时间交易所项目需要在服务器上用到 根据websocket推送价格数据，在交易所内进行下单撤单处理，但是由于有多个交易对，在服务器上部署时候，略显繁琐。
（撮合引擎同样有此问题，可以一并解决）

1. shell使用：在git项目后，这里每个交易对单独配一个文件，负责各自的交易处理，此处做项目下的目录轮询,并执行该目录下的shell脚本

    ```bash
    #!/bin/bash
    root=$(cd "$(dirname "$0")";pwd)

    #读取当前目录全部目录名
    dirs=`ls -a`
    for dir in ${dirs[@]}
    do
        #以下判断做去除非项目目录操作
      if [ -d ${root}/${dir} ];then
          if [ ${dir} == '.' ];then
              continue
          fi
          if [ ${dir} == ".." ];then
              continue
          fi
    if [ ${dir} == "logs" ];then
              continue
          fi
          #这里打开对应项目目录，做初始化配置
          cd ${root}/${dir} && ./update.sh

      fi
    done
    ```

2. shell的再次使用：在每个项目中需要替换一些配置文件中的个别字符串，作为当前项目的配置文件（解决了不需要再进入每一个项目中去修改配置文件的繁琐）

    ```bash
    #!/bin/bash
    root_dir=$(cd "$(dirname "$0")";pwd)

    #获取当前操作系统名称（用来区别linux和mac os系统）
    os=`uname -s`

    #获取文件名字
    file=${root_dir##*/}

    #配置文件所在位置
    config_file="${root_dir}/app/config/development/environment.ini"

    #开始轮询该文件
    while IFS= read -r line
    do

        if [[ ${line} == *"otc_pair ="* ]];then
        #取出要替换的字符串
            pair=$(echo ${line}|awk -F '=' '{print $2}'|sed 's/ //g')
        #替换该行字符串  这里的逻辑是将变量 $pair 替换为项目文件名 $file
            if [ ${os} == 'Darwin' ];then
              #此sed命令在macos上
                sed -i "" "s/$pair/$file/g" $config_file
            else
              #此sed命令在linux上
                sed -i "s/$pair/$file/g" $config_file
            fi
            break
        fi
    done <"${config_file}"
    ```

3. 至此完成shell的骚操作，其中关键可利用处我已贴出来，并做了注释，


### 11.30
>钱包 项目部署时需要额外部署icomet
git地址： https://github.com/ideawu/icomet

```bash
wget --no-check-certificate https://github.com/ideawu/icomet/archive/master.zip

unzip master.zip
cd icomet-master/
make
#start
./icomet-server -d icomet.conf
# stop
./icomet-server icomet.conf -s stop
```
 
 
### 10.24
* 今天了解了在公司框架中 model 自动保存到redis的逻辑
注：需要在model中加一个函数（getCacheEndpoint），然后在basemodel中save时会判断是否有需要缓存的逻辑，然后做缓存。

### 10.18
npm下载指定版本后面直接加版本号即可   npm install -g umi@1.3.11

### 9.7

百万级一万几数据库查询，已经添加索引后，查询还是很慢！！
解决方案： 原来是： order by id desc
修改后这么用： order by （id is not null ）desc
2亿条记录查询， 根本都是小问题

### 9.3
```bash
if [ -n "$(echo $1| sed -n "/^[0-9]\+$/p")" ];then
    echo "$1 is number."
else
    echo 'no.'
fi

echo 123123| sed -n "/^[0-9]\+$/p"
```

### 8.30

 * 市商项目快速开启检测api请求的任务 nohup php cli.php order_details start >> log/redis_orders.log 2>&1 &



### 8.24
* 今天启动本地otc项目，首页是白屏，进不去，看debug是500报错，但是后台可以进去。
解决： 启动项目，php cli.php env init    php cli.php env start    php cli.php async start    php cli.php db migrate
主要原因是，新拉的代码，更新了数据库字段，首页读取不到，导致报错。  按上面命令后，可以访问到主页了。

* 另外：重启电脑后，有时候fpm没有启动，导致otc项目无法使用，这里解决：fpm restart


### 8.23
* 修复bug  ： 市商中，当一个订单被成交部分量时，存入数据库的数据，应该是(deal_volume/deal_amount)的当前成交量   原来是直接存最新的deal...
导致数据库中一个订单被分为多个重复的量，用此量去火币下单，这样会亏损（在火币下的量太多）


### 8.16

* 今天部署市商项目时遇到坑，由于phalcon项目中未初始化启动，PHP cli.php env init 这个命令
导致nginx不能正常启动！！！立个flag，回头遇到来看看

### 8.11
* 使用快速查找进程id的命令：
 ```bash
 $taskid = shell_exec("ps ax | grep -i 'every_minutes' | grep -v grep | awk '{print $1}'");
 ```


* 终端发送消息，自定义操作：

```sh
curl -X POST --data-urlencode 'payload={"channel": "darren", "username": "darren", "text":"1111"}'  https://hooks.slack.com/services/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

https://hooks.slack.com/services/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

#在linux中使用curl在shall中发送请求，
curl -X POST --data-urlencode 'payload={"channel": "wc_test_server", "username": "bot", "text":"'"${MS}"'"}' https://hooks.slack.com/services/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

```


* pqsl给数据库增加字段，
php cli.php generate add_connect_weixin_to_product_channels
增加完文件后，生成数据即可：
PHP cli.php migrate

### 8.1

* 防火墙
启动：# systemctl start  firewalld
systemctl start firewalld.service
查看状态：# systemctl status firewalld 或者 firewall-cmd --state  systemctl status firewalld.service

* 停止：# systemctl disable firewalld

* 禁用：# systemctl stop firewalld

* 查看当前开了哪些端口
```
firewall-cmd --list-services
查看还有哪些服务可以打开
firewall-cmd --get-services
查看所有打开的端口
firewall-cmd --zone=public --list-ports

更新防火墙规则
firewall-cmd --reload
添加一个服务到firewalld
firewall-cmd --permanent --add-service=http


那怎么开启一个端口呢 添加

firewall-cmd --zone=public --add-port=3888/tcp --permanent

查看
firewall-cmd --zone= public --query-port=80/tcp
删除
firewall-cmd --zone= public --remove-port=80/tcp --permanent
```


zsh不存储历史记录的问题
解决：将~/目录下的这个文件加上权限，就ok了~
sudo chmod 777 .zsh_history
.zshrc 中添加 setopt HIST_IGNORE_DUPS  #可以消除重复记录


记录下新的坑！！！设置了每次开机fpm，导致启动后，并没有加载到后面启动的bash_profile 以至于里面的环境变量没有被加载到，
所以在web中取不到环境变量。

解决办法：将开机启动的fpm，设置到全部环境变量读取完毕后，在启动，或者改为手动启动。



7.28
今天解决交易所前端404报错，问题，是在nginx配置中，需要报错404重写
error_page 404 '/home';
加上这句就可以了！！！


7.27
今天大坑，自从拉取最新xphalcon后，框架里面的配置文件也更新了，导致网页数据库连不上，检查过后，发现数据库名称不正确，取不到env中的变量，于是将xphalcon中配置数据库名称改掉后，解决问题~

本地添加新币种，方便覆盖使用
 $arr = ['BTC_CNY' => 'bitcoin', 'BTC_OMG' => 'bitcoin_omisego'];

devops
DevOps 的主要内容是：跟谁共同工作、如何共同工作。它最吸引我的地方就是致力于把不同部门不同分工的人召集到一起，共同努力解决问题。这样的工作环境，是我所憧憬的乐园


7.26
php安装好swoole后，需要检查命令：
php --ri swoole


今天遇到的一个问题，就是开机重启后，发现zookeeper服务也在，导致src包里的zookeeper不能正常的启动和关闭。查了半天，不是自己src包里的服务，那想必就是原来安装的brew里面，
然后仔细  ps aux |grep zookeeper 之后，发现确实是，然后就打开开启预启动目录：cd ~/Library/LaunchAgents/
一眼看到这个zookeeper 然后果断删除，后面有brew uninstall zookee...  卸载成功后，重新启动电脑，看到已经没有这个服务了，完美解决了


输出该端口的详细信息
echo status | nc 127.0.0.1 2181

强制杀任务
kill -9 ***

7.21

开启交易对流程：
首先开启全部日志监听：
cd /Users/apple/projects/exchange_engine
tail -f log/http.log
tail -f log/engine.log
tail -f log/async.log
tail -f log/trade_worker.log
首先启动撮合引擎
/Users/apple/projects/exchange_engine/restart.sh

查看日志正常后开始开启交易所
cd /Users/apple/projects/otc_php
检查启动ssdb和redis
php cli.php  env start

检查是否启动ssdb
pstree |grep ssdb
pstree |grep redis

开启后，再开始机器人下单
./order.sh


每次重启电脑后，redis和ssdb有两个端口没有启动
在otc项目下运行这个，（先stop）然后就启动了
 php cli.php env start

  每次使用撮合引擎时候先查看进程在不在！！！redis和ssdb
没有就先启动下环境：
 php cli.php env start

(一共3个redis 2个ssdb)

历史操作命令；
redis-server /usr/local/etc/redis6378.conf
 redis-cli -p 6378

 ssdb-server -d /usr/local/etc/ssdb8801.conf

http://btc_cny.engine.com/api/market?pair=BTC_CNY


远程拷贝文件和目录(将此文件或目录内的文件，移动到对面文件或目录内部 **需要自己定义文件名称或者目录名**)

scp -r land@118.178.128.61://var/www/env.zhibo.test/app/app.git/modules/app/controllers/GoodController.php ./

scp -r server-1.properties root@47.95.7.124:/usr/local

sudo scp -r -P 55429 zookeeper_kafka_start.sh root@192.168.81.168:/usr/local/system/src/kafka_2.11-1.1.0


7.20

MAc开机启动命令，导入配置
sudo launchctl load /Library/LaunchDaemons/io.redis.redis-server.plist
关闭
sudo launchctl stop io.redis.redis-server

7.19
php_sapi_name — 返回 web 服务器和 PHP 之间的接口类型

7.18

 composer清理缓存
 rm -rf ~/.composer/cache/
composer clearcache
composer clear-cache


7月17日
当有成交量时候打开redis
127.0.0.1:6378> keys depth*

环境变量中撮合引擎域名(交易撮合引擎域名)
export trade_host='btc_omg.engine.com'
记着！！！！！！
要改host文件，要配置环境变量，要


撮合引擎数据库配置
 return [
            'adapter' => 'postgres',
            'dbname' => 'otc' . '_' . env('env', 'php'),
            'host' => env('otc_db_host', '127.0.0.1'),
            'port' => env('otc_db_port', 5432),
            'user' => env('otc_db_username', 'postgres'),
            'password' => env('otc_db_password', 'aaaa')
        ];

{"sell":{"user_id":92,"trade_id":63},"buy":{"user_id":99,"trade_id":64}}


https://ex.haobtc.io/trade_engine/orders/trade


7月16号笔记

php显示所有参数
    info(func_get_args(), '.........');
func_get_args()



7月2号开始
1 phpstorm
2 navicat
3 sourcetree ,charles, istat menu


目录区别作用：
/usr/local下一般是你安装软件的目录，这个目录就相当于在windows下的programefiles这个目录
/opt这个目录是一些大型软件的安装目录，或者是一些服务程序的安装目录


ffmpeg安装(音频视频转换包)

查询端口占用情况
lsof -i:8000
通过某个进程号显示该进程打开的文件
lsof -p 11968
列出某个程序进程所打开的文件信息
lsof -c mysql

mac调出进程管理快捷键  alt+cmd+esc
 

今天安装php7：
相应的位置
php, phpize, php-config /usr/local/opt/php70/bin
php-fpm /usr/local/opt/php70/sbin/php-fpm   //   /usr/local/opt/php@7.0/sbin/php-fpm  //二级显示  /usr/local/etc/php/7.0/php-fpm.d/

php.ini /usr/local/etc/php/7.0/php.ini
   当前配置文件在：  /usr/local/lib/php.ini
查找 php.ini命令 ： php --ini


php-fpm.conf /usr/local/etc/php/7.0/php-fpm.conf

 /usr/local/etc/php-fpm.conf

非用户目录下应该在/etc目录下的配置文件！！！
include=/usr/local/etc/php-fpm.d/*.conf

配置完成后，测试，显示成功！
php-fpm -t
[03-Jul-2018 12:49:52] NOTICE: configuration file /private/etc/php-fpm.conf test is successful
停止fpm:
 sudo killall php-fpm

当我配置完成后报错说没有当前用户所属的组：经过查找后：staff是当前mac用户的组
查找命令：
id -a user  // 可以查到指定用户所属组更详细的信息
groups // 查看当前用户所属组
groups user_name // 查看指定用户所属组

安装phalcon时候成功了：

Build complete.
Don't forget to run 'make test'.

Installing shared extensions:     /usr/lib/php/extensions/no-debug-non-zts-20160303/
cp: /usr/lib/php/extensions/no-debug-non-zts-20160303/#INST@4276#: Operation not permitted
make: *** [install-modules] Error 1

Thanks for compiling Phalcon!
Build succeed: Please restart your web server to complete the installation

查看安装情况：
php -m|grep phalcon


nginx相关路径
/usr/local/etc/nginx/nginx.conf （配置文件路径）

/usr/local/etc/nginx/servers  ( 虚拟主机记录值~~ )

/usr/local/var/www （服务器默认路径）

/usr/local/Cellar/nginx/1.8.0 （安装路径）

 重启（如果端口小于1000则需要在前面加sudo）
# 重新加载配置|重启|停止|退出


nginx -s reload|reopen|stop|quit
#测试配置是否有语法错误
sudo nginx -t
nginx: the configuration file /usr/local/etc/nginx/nginx.conf syntax is ok
nginx: configuration file /usr/local/etc/nginx/nginx.conf test is successful


开机自动启动任务目录：
~/Library/LaunchAgents

7.4工作日志：
Linux 的软件安装目录是也是有讲究的，理解这一点，在对系统管理是有益的
/usr：系统级的目录，可以理解为C:/Windows/，

/usr/lib理解为C:/Windows/System32。

/usr/local：用户级的程序目录，可以理解为C:/Progrem Files/。用户自己编译的软件默认会安装到这个目录下。

/opt：用户级的程序目录，可以理解为D:/Software，opt有可选的意思，这里可以用于放置第三方大型软件（或游戏），当你不需要时，直接rm -rf掉即可。在硬盘容量不够时，也可将/opt单独挂载到其他磁盘上使用。


php目录
/usr/local/etc/pear.conf
/usr/local/lib/php



改变mac环境变量
 vim ~/.bash_profile    编辑环境变量
source ~/.bash_profile   更新环境变量

echo $PATH
开机启动顺序，执行顺序为：/etc/profile -> (~/.bash_profile | ~/.bash_login | ~/.profile) -> ~/.bashrc -> /etc/bashrc -> ~/.bash_logout

Mac系统的环境变量，加载顺序为：
/etc/profile /etc/paths ~/.bash_profile ~/.bash_login ~/.profile ~/.bashrc



brew常用命令:
brew update                        　　#更新brew可安装包，建议每次执行一下
brew search php55                   #搜索php5.5
brew tap josegonzalez/php        #安装扩展<gihhub_user/repo>   ,可以获得更多的资源
brew tap                            #查看安装的扩展列表
brew install php55                 #安装php5.5
brew remove  php55                 #卸载php5.5
brew upgrade            升级所有可以升级的软件们

brew options php55                 #查看php5.5安装选项
brew info    php55                 #查看php5.5相关信息
brew home    php55                  #访问php5.5官方网站
brew services list                  #查看系统通过 brew 安装的服务
brew services cleanup               #清除已卸载无用的启动配置文件
brew services restart php55       #重启php-fpm

$ brew search git        // 搜索软件包
$ brew install git        // 安装软件包
$ brew unistall git        // 卸载软件包
$ brew list        // 显示已经安装的所有软件包
$ brew update        // 同步远程最新更新情况，对本机已经安装并有更新的软件用*标明
$ brew outdated        // 查看本机需要更新的软件包
$ brew upgrade        // 更新所有软件包
$ brew upgrade git        // 更新单个软件包
$ brew cleanup -n        // 查看可以清理的旧版本包
$ brew cleanup        // 清理所有包的旧版本的缓存
$ brew cleanup git        // 清理指定包的旧版本


7.5学习笔记

编辑php文件，做测试
vi html/t.php
    echo 'hello world!';

访问 php 脚本
curl localhost/t.php

每次访问的时候报错502 是因为php没有开启，没有监听
需要查看下端口9000
netstat -antp
然后启动 php-cgi -b 127.0.0.1:9000  以后用fpm不用这个进程管理


查看当前程序运行目录命令：
appledeiMac-2:nginx apple$ which php-fpm
/usr/local/bin/php-fpm


查看phalcon版本信息
appledeiMac-2:phalcon-devtools apple$ phalcon -v

Phalcon DevTools (3.4.0)

Environment:
  OS: Darwin appledeiMac-2.local 17.4.0 Darwin Kernel Version 17.4.0: Sun Dec 17 09:19:54 PST 2017; root:xnu-4570.41.2~1/RELEASE_X86_64 x86_64
  PHP Version: 7.2.1
  PHP SAPI: cli
  PHP Bin: /usr/local/bin/php
  PHP Extension Dir: /usr/local/lib/php/extensions/no-debug-non-zts-20170718
  PHP Bin Dir: /usr/local/bin
  Loaded PHP config: /usr/local/lib/php.ini
Versions:
  Phalcon DevTools Version: 3.4.0
  Phalcon Version: 3.3.2
  AdminLTE Version: 2.3.6



7.6学习笔记：


打开php报错提示：
php-fpm
在配置文件中：/etc/php-fpm.d/www.conf
display_errors  on

错误日志目录
error_log
; Example:
error_log = /usr/local/var/log/php_errors.log

php_admin_value[error_log] =/usr/local/var/log/fpm-php.www.log

vim /usr/local/var/log/fpm-php.www.log


mac开机启动：
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

mac取消开机启动
$ launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
$ rm -rf ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist


为mac系统中建立软连接：file1是源文件
ln -s file1 file2




7月七日


 学习模版volt
 {% for i in 0..100 %}
  <div>{{i}}</div>
{% endfor %}、


{{ url('user/detail?uid='~user['uid']) }}

查看版本信息 brew
 brew info openresty

使用配置如下 ~/openresty-test
 nginx -p `pwd`/ -c conf/nginx.conf




7月9号


  获取客户端ip
   function remoteIp()
    {
        $remote_ip = $_SERVER["REMOTE_ADDR"];

        $forwarded_for = $this->headers("X-Forwarded-For");
        if ($forwarded_for) {
            foreach (explode(",", $forwarded_for) as $ip) {
                $ip = trim($ip);
                if (preg_match("/^(127|192|10)\./i", $ip)) {
                    continue;
                }
                return $ip;
            }
        }

        $real_ip = $this->headers("X-Real-Ip");
        if ($real_ip) {
            return $real_ip;
        }
        return $remote_ip;
    }


7月10号

apache相对nginx的优点
rewrite，比nginx 的rewrite 强大
模块超多，基本想到的都可以找到
少bug，nginx的bug相对较多
超稳定
Apache对PHP支持比较简单，Nginx需要配合其他后端用


java8
/usr/local/Caskroom


otc项目中kafka脚本的使用：

在kafka服务器中：

kafka_list.sh 脚本 ：将当期分组中所有分区的消费信息一一列出来

kafka-consumer-groups.sh --bootstrap-server 127.0.0.1:9092 --describe --group kafka_otc

kafka_check_logs.sh  ：将所有分区中未消费消息，加和，若超过3000 就报警，（注意！一般不要执行）

tail -f /tmp/kafka_check_logs.log  查看当前日志中的未消费总量

暂时启动临时消费模式：
nohup php test/test_kafka_consumer1.php  >> log/kafka.log 2>&1 &


研究Kafka
分布式的消息系统

kafka节点之间如何复制备份的？
kafka消息是否会丢失？为什么？
kafka最合理的配置是什么？
kafka的leader选举机制是什么？
kafka对硬件的配置有什么要求？
kafka的消息保证有几种方式？


/usr/local/etc/kafka/
安装的配置文件位置

kafka数据存储在了(kafka日志)
/usr/local/var/lib/kafka-logs/


新建session，查看kafka的topic
在kafka的bin目录下：
执行命令：./kafka-topics --list --zookeeper localhost:2181

启动zookeeper系统
zookeeper-server-start /usr/local/etc/kafka/zookeeper.properties
启动kafka系统
kafka-server-start.sh /usr/local/etc/kafka/server-1.properties

快捷命令（每次开机都都需要启动）
 zookeeper-server-start.sh /usr/local/etc/kafka/zookeeper.properties

kafka-server-start.sh /usr/local/etc/kafka/server.properties
kafka-server-start.sh /usr/local/etc/kafka/server-1.properties
kafka-server-start.sh /usr/local/etc/kafka/server-2.properties
kafka-server-start.sh /usr/local/etc/kafka/server-3.properties

/usr/local/system/src/kafka_2.11-1.1.1/bin/kafka-server-start.sh /usr/local/system/src/kafka_2.11-1.1.1/config/server.properties

新建topic
 tail -f /usr/local/system/src/kafka_2.11-1.1.1/logs/zookeeper.log
 /usr/local/system/src/kafka_2.11-1.1.1/bin/kafka-topics.sh --create --zookeeper 192.168.81.167:2181,192.168.81.168:2181 --replication-factor 2 --partitions 1 --topic test1


 kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic zzyk
 kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 10 --topic otc-dev

  #--zookeeper是集群列表，可以指定所有节点，也可以指定为部分列表
  #--replication-factor 为复制数目，数据会自动同步到其他broker上，防止某个broker宕机数据丢失
  #--partitions 一个topic可以切分成多个partition，一个消费者可以消费多个partition，但一个partition只能被一个消费者消费

生产消息
kafka-console-producer.sh --broker-list localhost:9092 --topic otc-dev
kafka-console-producer.sh --broker-list localhost:9092 --sync --topic zzy0

kafka-console-producer.sh --broker-list 192.168.1.181:9092,192.168.1.181:9093,192.168.1.181:9094  --topic topic_1
消费消息
kafka-console-consumer.sh --zookeeper 127.0.0.1:2182   --from-beginning   --topic otc-dev

kafka-console-consumer.sh --bootstrap-server localhost:2181 --from-beginning  --topic LTC-ETH




查看当前全部主题
kafka-topics.sh --list --zookeeper localhost:2181
查看当前主题详细信息
kafka-topics.sh --zookeeper 127.0.0.1:2182  --describe --topic zzy10


查看全部主题信息
kafka-topics.sh --describe --zookeeper localhost:2181


查看consumer group列表（新版命令）
kafka-consumer-groups.sh --new-consumer --bootstrap-server 127.0.0.1:9092 --list

指定消费组开始消费。
./bin/kafka-console-consumer.sh  --bootstrap-server XXXXXX:9092  --topic topic_t_base_organize --group metasso_center_organize_tag_ms
查看consumer group列表（老命令）
kafka-consumer-groups.sh --zookeeper 127.0.0.1:2181 --list

查看组信息中的分区使用情况
kafka-consumer-groups.sh --bootstrap-server 127.0.0.1:9092 --describe --group  test2

删除主题：
kafka-topics.sh --delete --zookeeper localhost:2181 --topic zzyk
  此时你若想真正删除它，可以如下操作：

     （1）登录zookeeper客户端：命令：./bin/zookeeper-client

     （2）找到topic所在的目录：ls /brokers/topics

     （3）找到要删除的topic，执行命令：rmr /brokers/topics/【topic name】即可，此时topic被彻底删除。
    另外被标记为marked for deletion的topic你可以在zookeeper客户端中通过命令获得：ls /admin/delete_topics/【topic name】，

    如果你删除了此处的topic，那么marked for deletion 标记消失
删除 消费者组
kafka-consumer-groups.sh --zookeeper 127.0.0.1:2181 --delete --group <group-name>


增加topic分区数
kafka-topics.sh --zookeeper 127.0.0.1:2181  --alter  --partitions 60 --topic otc-dev


重新分区
kafka-reassign-partitions.sh --zookeeper 127.0.0.1:2181 --topics-to-move-json-file ./top.json  --broker-list  "0,1,2"  --generate
kafka-reassign-partitions.sh --zookeeper 127.0.0.1:2181 --reassignment-json-file ./top.json --execute
kafka-reassign-partitions.sh --zookeeper 127.0.0.1:2181 --reassignment-json-file ./top.json --verify
127.0.0.1:9092,127.0.0.1:9093,127.0.0.1:9094
查看某个组中的topic信息
kafka-consumer-groups.sh --zookeeper 127.0.0.1:2181 --group test2 --describe

kafka-consumer-groups.sh --new-consumer --bootstrap-server 127.0.0.1:9092 --group kafka_otc1 --describe

指定消费组消费信息

分别打开配置文件进行如下修改：
broker.id=0  #三个broker的id不能相同，因此改为不同的id
listeners=PLAINTEXT://192.168.10.152:9092 #服务器监听的地址，如果不配置从java.net.InetAddress.getCanonicalHostName()获得
host.name=192.168.10.152 #broker 机器ip
zookeeper.connect=192.168.10.152:2181,192.168.10.153:2181,192.168.10.170:2181




备注：要挂到后台使用：（挂载）("2>"表示把标准错误(stderr)重定向，标准输出(stdout)是1。)
nohup php cli.php kafka start >> log/kafka.log 2>&1 &

nohup  <命令>  >> log/conf.log 2>&1 &
nohup /usr/local/system/src/kafka_2.11-1.1.0/bin/zookeeper-server-start.sh /usr/local/system/src/kafka_2.11-1.1.0/config/zookeeper.properties  >> /usr/local/system/src/kafka_2.11-1.1.0/logs/zookeeper.log &

nohup /usr/local/system/src/kafka_2.11-1.1.0/bin/kafka-server-start.sh /usr/local/system/src/kafka_2.11-1.1.0/config/server.properties >> /usr/local/system/src/kafka_2.11-1.1.0/logs/service-run.log &
nohup /usr/local/system/src/kafka_2.11-1.1.0/bin/kafka-server-start.sh /usr/local/system/src/kafka_2.11-1.1.0/config/server-1.properties >> /usr/local/system/src/kafka_2.11-1.1.0/logs/service-run.log &
nohup /usr/local/system/src/kafka_2.11-1.1.0/bin/kafka-server-start.sh /usr/local/system/src/kafka_2.11-1.1.0/config/server-2.properties >> /usr/local/system/src/kafka_2.11-1.1.0/logs/service-run.log &


zookeeper-server-start /usr/local/etc/kafka/zookeeper.properties >> /Users/apple/src/kafka2.11-1.1.1/log_run/zookeeper.log &
sleep 10s
kafka-server-start.sh /usr/local/etc/kafka/server.properties >> /Users/apple/src/kafka2.11-1.1.1/log_run/kafka.log &
kafka-server-start.sh /usr/local/etc/kafka/server-1.properties >> /Users/apple/src/kafka2.11-1.1.1/log_run/kafka.log &
kafka-server-start.sh /usr/local/etc/kafka/server-2.properties >> /Users/apple/src/kafka2.11-1.1.1/log_run/kafka.log &
kafka-server-start.sh /usr/local/etc/kafka/server-3.properties >> /Users/apple/src/kafka2.11-1.1.1/log_run/kafka.log &


上午连接新的服务器搭建kafka集群线上的环境。
/usr/local/system/src/kafka_2.11-1.1.0/bin/zookeeper-server-start.sh /usr/local/system/src/kafka_2.11-1.1.0/config/zookeeper.properties

/usr/local/system/src/kafka_2.11-1.1.0/bin/kafka-server-start.sh /usr/local/system/src/kafka_2.11-1.1.0/config/server.properties
/usr/local/system/src/kafka_2.11-1.1.0/bin/kafka-server-start.sh /usr/local/system/src/kafka_2.11-1.1.0/config/server-1.properties
/usr/local/system/src/kafka_2.11-1.1.0/bin/kafka-server-start.sh /usr/local/system/src/kafka_2.11-1.1.0/config/server-2.properties
/usr/local/system/src/kafka_2.11-1.1.0/bin/kafka-server-start.sh /usr/local/system/src/kafka_2.11-1.1.0/config/server-3.properties



"-daemon" 参数代表以守护进程的方式启动kafka server。
官网及网上大多给的启动命令是没有"-daemon"参数，如：“bin/kafka-server-start.sh config/server.properties &”，但是这种方式启动后，如果用户退出的ssh连接，进程就有可能结束，具体不清楚为什么。


kafka-manager启动
已经添加快捷操作命令：
~/kafka_manager
nohup bin/kafka-manager -Dconfig.file=conf/application.conf -Dhttp.port=9001 &


最小配置是要用于kafka管理器状态的zookeeper主机。这可以在conf目录中的application.conf文件中找到。相同的文件将打包在分发zip文件中; 您可以在解压缩所需服务器上的文件后修改设置。

kafka-manager.zkhosts="my.zookeeper.host.com:2181"
您可以通过逗号分隔多个zookeeper主机，如下所示：

kafka-manager.zkhosts="my.zookeeper.host.com:2181,other.zookeeper.host.com:2181"
或者，ZK_HOSTS如果您不想对任何值进行硬编码，请使用环境变量。

ZK_HOSTS="my.zookeeper.host.com:2181"




7月10日

php安装扩展时候先phpize然后在配置安装并指定安装配置文件
./configure --with-php-config=/usr/bin/php-config  （ /Users/apple/src/php-7.2.1/scripts/php-config(优先使用这个)  ）


本人今天下午刚好遇到同样的问题，现象：
1.在命令行下面查看php版本是: PHP 5.6.29
2.使用浏览器访问,php版本是:PHP 5.5.27

原因：
我的机子是之前在一个文件(org.php.php-fpm.plist)里设置过开机启动php-fpm，那个时候的php-fpm指定路径使用的是php自带的；
后来我又新装了PHP 5.6.29,没有及时修改这个文件里的php-fpm路径。

解决办法：将文件(org.php.php-fpm.plist)里的php-fpm路径修改为php5.6的php-fpm对应路径，然后重启机子即可解决

 /usr/local/bin/php-fpm   7.2
/usr/sbin/php-fpm  7.1

解决方案2：我发现  ~/Library/LaunchAgents/ 目录下的开机自动启动文件中fpm的配置是原来本机自带php的fpm路径，忽然恍然大悟~我就查看了下当前使用的fpm路径   (which php-fpm）然后将该目录复制到配置文件中，最后重启电脑后，每次启动的php就是我想要的哪个7.2.1了，没问题了~

flag今天apache占用80导致不能用nginx
梁哥先查了下状态，在运行
nginx -t
sudo nginx
然后就好了！！！


nginx配置location

location  = / {
  # 只匹配"/".
  [ configuration A ]
}
location  / {
  # 匹配任何请求，因为所有请求都是以"/"开始
  # 但是更长字符匹配或者正则表达式匹配会优先匹配
  [ configuration B ]
}
location ^~ /images/ {
  # 匹配任何以 /images/ 开始的请求，并停止匹配 其它location
  [ configuration C ]
}
location ~* .(gif|jpg|jpeg)$ {
  # 匹配以 gif, jpg, or jpeg结尾的请求.
  # 但是所有 /images/ 目录的请求将由 [Configuration C]处理.
  [ configuration D ]
}

@location 例子
error_page 404 = @fetch;

location @fetch(
proxy_pass http://fetch;
)


openresty最后成功编译安装的配置信息
./configure --with-cc-opt="-I/usr/local/opt/openssl/include/ -I/usr/local/opt/pcre/include/" --with-ld-opt="-L/usr/local/opt/openssl/lib/ -L/usr/local/opt/pcre/lib/" --with-http_drizzle_module --with-http_iconv_module --with-http_postgres_module



7月12日

 nginx日志
 /usr/local/Cellar/nginx/1.15.0/logs

 /usr/local/var/log/nginx
撮合引擎配置文件
 /Users/apple/projects/exchange_engine

pstree |grep server.php
  pstree | grep server
  tail -f error.log
  tail -f /usr/local/Cellar/nginx/1.15.0/logs/error.log


tail -f /usr/local/var/log/nginx/error.log
  查看nginx版本信息详细信息
  nginx -V


7月13日

xdebug日志：
tail -f /usr/local/var/log/xdebug.log


kafka

系统启动路径：()
/usr/local/etc/kafka/server.properties
(启动Zookeeper server)
/usr/local/etc/kafka/zookeeper.properties

Mac OS X 清理 DNS 缓存
sudo killall -HUP mDNSResponder

Linux 清理 DNS 缓存
sudo rcnscd restart
