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

6.10
php字符串替换： 把3中的1全部替换为2 (数字代表参数)
$god_img = str_replace("/w0","",$god_img);

5.22
//忽略本地依赖
composer --ignore-platform-reqs require laoyuegou/smartnormalizer

5.1 artisan  queue使用

php artisan queue:work --queue=testQueue  指定消费队列
php artisan queue:work --daemon 守护进程节省cup


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
