2.20
 goland phpstorm远程配置库：
https://github.com/Darrenzzy/storm-config.git

2.17
指定配置文件更新composer 命令：
COMPOSER=composer-name.json composer install

若存在composer.lock文件 直接composer install
对目前以有依赖更新 composer update

1.16
将现在正在执行的linux命令放在后台执行
1.  通过命令： ctrl + z 来将当前的命令暂停。
2.  通过命令：bg 来启动后台暂停的任务。

1.14
交易所启动监听脚本
nohup go run /Users/darren/go/src/Futures-Go-demo/main/main.go >>test.log 2>&1 &

mac 执行文件 编译转成linux 可执行文件
gox -os="linux" -arch="amd64" -output="./game-server_linux_amd64"

12.24
redis统计大key
redis-cli  -h 127.0.0.1  -i 0.1  --bigkeys

批量删除
redis-cli -h 127.0.0.1 -a password keys PHP_GGV1* |xargs redis-cli -h 127.0.0.1 -a password del


8.20
laravel 启动队列任务 报错 apcu 不存在
需要在配置文件env中改用file式 和redis做驱动
BROADCAST_DRIVER=log
CACHE_DRIVER=file
SESSION_DRIVER=array
SESSION_LIFETIME=120
QUEUE_CONNECTION=redis
生产环境：
BROADCAST_DRIVER=log
CACHE_DRIVER=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=array
SESSION_LIFETIME=120

8.15由于8月laravel不再提供composer
所以替换阿里云的
  "url": "https://packagist.laravel-china.org"
  "url": "https://mirrors.aliyun.com/composer/"

7.3
redis锁 的调用：
1.setnx
2.expire
3.delete
解决的问题：
利用 setnx 原子操作，保证了并发场景下 redis 锁的安全性

方案二：
对 redis 的调用：
1.setnx
2.get
3.get_set
1.少了一次 expire 调用，redis 不需要去维护 key 的 expire 表，解锁依赖 expire 不靠谱
2.少了一次 delete 调用
3.redis value 值有效利用


分布式加锁：
核心代码：$redis->set("Lock:{$key}", 1, ['NX', 'EX' => $lockSecond]);

    /**
     * 尝试获取锁
     * @param \Predis\Client $redis     redis客户端
     * @param String $key               锁
     * @param String $requestId         请求id
     * @param int $expireTime           过期时间
     * @return bool                     是否获取成功
     */
   if (!$lock_redis->set($lock_key, $mobile, ['NX', 'EX' => 2])) {

            return $this->renderJSON(ERROR_CODE_FAIL, '请求速度太快,请稍后再试');
      }

分布式解锁：（为什么要用 Lua 脚本来实现，主要是为了保证原子性. Redis 的 eval 可以保证原子性，主要还是源于 Redis 的特性）
    function unlock($lock)
    {
        $this->del($lock);
    }


6.15
linux 磁盘使用情况
df -h /var

6.10
php字符串替换： 把3中的1全部替换为2 (数字代表参数)
$god_img = str_replace("/w0","",$god_img);

5.22
//忽略本地依赖
composer --ignore-platform-reqs require laoyuegou/smartnormalizer

5.8
批量删除redis keys
redis-cli -h 127....  -a password keys "GGV1:*" | xargs redis-cli -h 127.... -a password del

5.1 artisan  queue使用

php artisan queue:work --queue=testQueue  指定消费队列
php artisan queue:work --daemon 守护进程节省cup


4.30
redis监控实时日志
127.0.0.1:6379>monitor

4.24
连接redis
redis-cli -h 127... -p 6379 -a password -n db1
或者：
redis-cli -h 127... 连接池
auth password  验证密码
select 1 选择db1库


4.17
laravel查询多个字段 参数
$data = PlayGodAcceptSetting::query()
  ->select('*', 'pei_wan_uniprice_id as price_id')
  ->first();




4.10
php命令启动：php -S 127.0.0.1:9999 -t ./public
php -S 127.0.0.1:9998 -t ./public >> /usr/local/var/log/php7.log 2>&1 &



2.16
前端页面跳转 跳转上一页
 window.location.href = history.go(-1);


1.15

1:前端layui总结：
数据表格中编辑删除，不起作用，原因是一开始没有导入标记 （lay-filter）
<table class="layui-hide" id="member"  lay-filter="test"></table>

2：疑问： 为什么有时候对象方法使用数组作为参数传递就会不成功，（最后转为json才解决传递参数问题）


1.9开通https顺序：

1：现在阿里云开通安全组，
2：再添加443端口，
3：宝塔上添加放行记录

1.7
php 配置文件php.ini文件的动态设置与获取
ini_get正好和ini_set相反




1.5
我自己的电脑启动项目流程：

sudo nginx
sudp php-fpm start
数据库
pg_ctl -D /Users/darren/postgresql/data -l logfile start


1.3
秒杀架构设计理念
限流，削峰（消息队列）（异步处理），内存缓存（减少对数据库的读写io，），可扩展（做负载均衡集群）

实现日志切割脚本：
#!/bin/bash
#Rotate the Nginx logs to prevent a single logfile from consuming too much disk space.
LOGS_PATH=/usr/local/nginx/logs
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
mv ${LOGS_PATH}/access.log ${LOGS_PATH}/access_${YESTERDAY}.log
mv ${LOGS_PATH}/error.log ${LOGS_PATH}/error_${YESTERDAY}.log
## 向 Nginx 主进程发送 USR1 信号。USR1 信号是重新打开日志文件
kill -USR1 $(cat /usr/local/nginx/logs/nginx.pid)

将上面的脚本开启到crontab中，每天来运行


12.29
实现php类的多继承：trait
<?php
trait myTrait{
  function traitMethod1(){}
  function traitMethod2(){}
}
//然后是调用这个traits,语法为：
class myClass{
  use myTrait;
}
//这样就可以通过use myTraits，调用Traits中的方法了，比如：
$obj = new myClass();
$obj-> traitMethod1 ();
$obj-> traitMethod2 ();



composer 工作原理：
1：加载文件 vendor/composer/autoload_real.php文件
2：实例化类Composer\Autoload\ClassLoader
该类实现了：读取目录下所有文件，返回class目录映射关系

接下来加载类与文件的对应关系,将其放到内存内；
核心语句：使用php提供的函数spl_autoload_register注册loadClass方法


12.21
redis: 有序集（key score member）且不允许重复的成员
zset

哈希存储：Redis hash 是一个string类型的field和value的映射表，hash特别适合用于存储对象
集合：Redis 的 Set 是 String 类型的无序集合。集合成员是唯一的，这就意味着集合中不能出现重复的数据

String——字符串
Hash——字典
List——列表
Set——集合
Sorted Set——有序集合


12.17实现sql注入的基本：
关键语句：
  $key = "or 1=1 --";
  即可实现注入手段



12.10

1，linux中 ！字符 默认被忽略历史命令，到时命令中含有该字符时不起作用

-H Shell：可利用"!"加<指令编号>的方式来执行history中记录的指令。

例如:
echo "Reboot your instance!"
会报 ！not found
需要在环境配置中加
set  +H
来解决关闭忽略命令


2:检索所有文件中匹配的字符串(find)
我一般使用: grep -nri key_word ./*
grep -i pattern files ：不区分大小写地搜索。默认情况区分大小写，

grep -l pattern files ：只列出匹配的文件名，

grep -L pattern files ：列出不匹配的文件名，

grep -w pattern files ：只匹配整个单词，而不是字符串的一部分（如匹配‘magic’，而不是‘magical’），

grep -C number pattern files ：匹配的上下文分别显示[number]行，

grep pattern1 | pattern2 files ：显示匹配 pattern1 或 pattern2 的行，

grep pattern1 files | grep pattern2 ：显示既匹配 pattern1 又匹配 pattern2 的行。



12.1 今天重新安装nginx 开始报错openssl找不到
于是发现是路径没有写对，在configuer时候 后面加了 ./configure  --with-openssl=/usr/local/opt/openssl/bin  就解决了路径问题
再次make后，又报错,  方案 : make clean  解决
后面直接成功 以下是成功后的显示结果：

Configuration summary
  + using system PCRE library
  + using OpenSSL library: /usr/local/opt/openssl
  + using system zlib library

  nginx path prefix: "/usr/local/nginx"
  nginx binary file: "/usr/local/nginx/sbin/nginx"
  nginx modules path: "/usr/local/nginx/modules"
  nginx configuration prefix: "/usr/local/nginx/conf"
  nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
  nginx pid file: "/usr/local/nginx/logs/nginx.pid"
  nginx error log file: "/usr/local/nginx/logs/error.log"
  nginx http access log file: "/usr/local/nginx/logs/access.log"
  nginx http client request body temporary files: "client_body_temp"
  nginx http proxy temporary files: "proxy_temp"
  nginx http fastcgi temporary files: "fastcgi_temp"
  nginx http uwsgi temporary files: "uwsgi_temp"
  nginx http scgi temporary files: "scgi_temp"



9.18
社会一小步，没有同情，没有怜悯，你强任你行，你弱就闭嘴，
这都是闲的，导致大家发生争执
以后多一事不如少一事
少说几句话，做事走走心，不要傻不拉几
哎


9.15

 $no = shell_exec("ps ax| grep -i 'order_details'  | grep -v grep | awk '{print $1}'");
            if (!isBlank($no)) {
                exec("kill -9 " . $no);
            }
            exec("nohup php " . APP_ROOT . "cli.php order_details start >> log/redis_orders.log 2>&1 &");



#no=`ps ax| grep -i 'order_details' |grep ${file}  | grep -v grep | awk '{print $1}'`
#if [ -n "$no" ]; then
#    kill -9 $no
#fi


9.14
//        $kafkaid = shell_exec("ps ax | grep -i kafka| grep -v 'restart' | grep -v grep |grep -v 'stop' |grep -v 'tail'  |grep -v 'product'  |grep -v 'src/kafka'  | awk '{print $1}'");
//        if(!isBlank($kafkaid)){
//            $arrs = explode("\n",$kafkaid);
//            foreach ($arrs as $arr){
//                if(!isBlank($arr)){
//                    exec("kill -9 " . $arr);
//                }
//            }
//        }


9.11
市商 ：监控重启措施，完善运行手册


9.5
学习model中存储数据方式：ssdb/redis 切换，
仅限xphalcon ：在model中配置方法放回存储路径  ssdb://127.0.0.1:8888 redis://127.0.0.1:6379

 #该函数返回此model要存储的方式 ssdb或者redis 在basemodel中会判断该函数，调用存储方式地址
    static function getFastCacheEndpoint($id)
    {
        $endpoints = 'redis://127.0.0.1:6379';
        return $endpoints;
    }

9.4
服务器端错误日志位置：
tail -f /usr/local/system/log/error.log


8.28
今天在本机上运行了一个原来的网站项目，部署上去，发现服务器配置一直不对，导致网站不能访问，
在网上找来找去，终于找到一个合适的nginx/conf
server {
             listen 80;
             server_name wutuobang.com;
             set $root /Users/apple/projects/photo_album2/public;

             location ~ .*\.(gif|jpg|jpeg|bmp|png|ico|txt|js|css)$
             {
                 root $root;
             }
             location / {
                 root    $root;
                 index    index.html index.php;
                 if ( -f $request_filename) {
                     break;
                 }
                 if ( !-e $request_filename) {
                     rewrite ^(.*)$ /index.php/$1 last;
                     break;
                 }
             }
             location ~ .+\.php($|/) {
                 fastcgi_pass 127.0.0.1:9002;
                 fastcgi_split_path_info ^((?U).+.php)(/?.+)$;    # 支持path_info
                 fastcgi_param PATH_INFO $fastcgi_path_info;
                 fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
                 fastcgi_param    SCRIPT_FILENAME    $root$fastcgi_script_name;
                 include        fastcgi_params;
             }

    }



8.3
今天运行机器人，一直显示下单失败，和参数错误

解释下：要看日志，下单失败，可能是下单后发到撮合引擎，但是撮合那边的交易对与当前下单的不匹配，导致下单失败，只需剪当前下单交易对修改为撮合引擎那边有的即可  修改位置： getAvailableCoinTrades() 其中只需要在result中写入需要交易的对，即可~   $result = ['BTC_CNY' => 'bitcoin'];

参数错误 ：我的坑是在下单时，存入数据库时候，核验数据规格上出了错，是在后台配置当前交易对要精确位数的事情，我这里做了限制，导致最后的数据为0
是空的，所以报错。解决是在后台将交易对的精度进行修改，改为小数点后四位，保存，再下单，就没有错了。


8.6
今天使用phalcon-ext mail扩展，当我composer update后，发现其中的类不能实例化，一直显示not found，导致不能使用这个扩展，
从网上找来找去都没有得到解决。索性我就删除vender目录，重新安装，后来发现是可以用的。
最后经过排查，发现我之前修改过config文件，因为xphalcon配置环境变量的事情，因此修改过后，发现是没问题的。