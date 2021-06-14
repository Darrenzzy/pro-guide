灰度流程
./jump phpgray
/var/www/env.master.prod/app/app.git

3.26 开启opcache后 发上去代码，要重新刷缓存
php artisan opcache:clear

11.20
访问接口：
开发环境 API_ROOT = 172.16....164.220:3201

测试环境 API_ROOT = 172.16....164.248:3201

STAG 172.16....164.182:3201

VPC生产环境  API_ROOT = 172.16....163.178:8001

客户端访问地址
开发环境 API_ROOT = http://gateway-dev.ly  gou.cc

测试环境 API_ROOT = http://gateway-test.ly   g  ou.cc

预发布  API_ROOT = http://gateway-stag.ly  gou.cc

生成环境 API_ROOT = http://gateway.ly   gou.cc

9.20
查询redis 及时约派单大神池 的数据 {品类id  性别id}
zrange JSYPaiDan:{44}:{1}:Gods 0 -1

8.31
app仓库，php灰度机标识  IS_HUIDU=1
位置：~/.bash_profile


8.26
查看当前服务器php版本信息
phpbrew list

laravel 线上添加异步队列queue 库 
步骤如下：
php artisan queue:table  
php artisan queue:failed-table
注意：这里写到了app数据库中
php artisan migrate
Php artisan  queue:work
Php artisan  queue:restart

8.15
删除服务器发布脚本的缓存目录：
rm -rf /alidata/neutronbuild.....
 
 
   7.31

删除下架品类缓存数据
PHP order仓库  app/Models/PlayGame.php
在artisan 中执行 php artisan tinker  =》   PlayGame::resetRedisGames()

   7.23
   重启phpbrew
   sudo service phpbrew-fpm-56 restart
   当前有哪些版本：
   phpbrew list
 
   
   5.21
   supervisor日志目录：
   /var/log/supervisor/supervisord.log

   4.21
   1 读取redis 要选对应库，还要注意key的前缀，不然导致后果就是查不到数据!!!

   2 连接 测试服务器的redis需要在服务器上连接，本地是没有权限的。

   3 连接go服务器 api 返回有信息，要注意请求方式get / post

   4  http_proxy=http://172.31.0.82:9090 https_proxy=http://172.31.0.82:9090
   代理忽略： 192.168.0.0/16、10.0.0.0/8、127.0.0.1、localhost、*.local、172.16.0.0/12

   
   5、数据库连接不上，请用curl ip 检查当前网络，可能不是公司内网

   6 ios 接收不到消息解决方案 1、将当前设备重启下，使得用户token绑定成功，  2、 在app设置中将消息通知开关打开即可。

   队列系统：
   // 以下的任务将被委派到默认队列...
   dispatch(new Job);

   // 以下任务将被委派到 "emails" 队列...
   dispatch((new Job)->onQueue('emails'));

   默认到high高优先级队列中  先高级后低级
   php artisan queue:work --queue=high,low

   创建任务
   php artisan make:job ProcessPodcast

   延时分发任务
    ProcessPodcast::dispatch($podcast)->delay(now()->addMinutes(10));

   分发到指定队列
    ProcessPodcast::dispatch($podcast)->onQueue('processing');

   最大失败次数
    php artisan queue:work --tries=3
   或者在job类中加变量

        * The number of times the job may be attempted.
        *
        * @var int
        */
       public $tries = 5;

   
   php artisan queue:restart

   删除所有失败任务
   php artisan queue:flush
   
   根据订单查对应游戏账户id
   get O:{20190508145129485411129066371}:GameAccount
 