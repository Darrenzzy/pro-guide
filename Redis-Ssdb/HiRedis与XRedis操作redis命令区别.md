# SSDB实现

### 具体代码在  https://github.com/Darrenzzy/Redis-Ssdb


```

//安装HiRedis扩展：

//参考文档
https://github.com/redis/hiredis
https://github.com/nrk/phpiredis

//安装hiredis
git clone https://github.com/redis/hiredis.git
make
sudo make install 

//安装 phpiredis 
git clone https://github.com/nrk/phpiredis.git
cd phpiredis
phpize && ./configure --enable-phpiredis
make 
sudo make install

修改PHP.ini 
extension=phpiredis.so



//HiRedis.php 与 XRedis.PHP 操作redis命令区别汇总：
1>.set返回值不同；OK 1 （OK已改为1）
2>.setnx返回值不同，当key值存在时； 0 空字符串
3>.exists当判断多个key时，xredis报错，iredis返回值与客户端命令行返回值不同<多个key值未添加命名空间作为前缀>(已改), xredis参数不支持数组<多个key值>；   
4>.setex 返回值不同；OK 1 （OK已改为1）
5>.mset返回值不同； OK 1 （OK已改为1）
6>.mget返回值不同，当key值不存在时，null false 
7>.hmset 返回值不同；OK 1  OK已改为1）
8>.hmget 返回值不同；键值对数据 数组 （已改）, 当field不存在时， null false,   hiredis参数支持字符串|数组，而xredis参数只支持数组；
9>.hgetall 返回值不同； 键值对数据，数组 （已改）
10>.lset返回值不同； 当成功时：OK 1，OK已改为1）当失败时 空字符串 报(ERR index out of range)  （已改）
11>.ltrim 返回值不同； OK 1 OK已改为1）
12>.lrem  iredis 中拼接命令参数顺序有误  且xredis返回值与客户端命令行返回值不一致； （已改）
13>.zadd: hiredis 支持数组批量添加，xredis不支持；
14>. lpush、rpush： xredis参数不支持数组，hiredis参数支持数组；

15>.批量操作：
    <1>. set、mset返回值不同；OK true（已改）；
    <2>. hmget 返回值不同；键值对数据 数组 （已改）, 当field不存在时， null false
    <3>. hgetall 返回值不同； 键值对数据，数组 （已改）;
    <4>. setnx 返回值不同： true 1 , false 0；
    <5>. expire 返回值不同： true 1；
    <6>. exists 返回值不同： true 1， false 0；
    <7>. mget返回值不同，当key值不存在时，null false ;
    <8>. hget返回值不同，当key值不存在时，null false ;
    <9>. hexists 返回值不同： true 1， false 0；
    <10>.lset 返回值不同： 当设置失败时 ERR no such key false  (已改);
    <11>.zscore 返回值不同：当member不存在时， null false,  当member存在时， 字符串、整型 如： "2016" 2016 ;
    <12>.zadd返回值不同： 
         a:多元素值添加时，报 "ERR value is not a valid float"  空字符；(已改)；
         b:hiredis参数支持数组，xredis参数不支持数组；
    <13>.zincrby 返回值不同: 字符串、整型 如： "2016" 2016 ;
    <14>.zrevrank 不存在； 


//测试执行速度(作为参考数据)
 以100000条为例：       单个命令操作
  1>.set:    hiredis：5.429s，   xredis：6.285s;
  2>.get：   hiredis：5.293s，   xredis：6.266s;
  3>.incr：  hiredis：5.223s，   xredis：6.063s;
  4>.mset:   hiredis: 6.877s,   xredis: 7.202s;
  5>.mget:   hiredis: 6.687s,   xredis: 6.462s;
  6>.hset:   hiredis: 5.62s,    xredis: 6.897s;
  7>.hget:   hiredis: 5.494s,   xredis: 6.675s;
  8>.zadd:   hiredis: 6.277s,   xredis: 6.914s;
  9>.zscore: hiredis: 6.027s,   xredis: 7.019s;
  10>.sadd:  hiredis: 6.438s,   xredis: 6.951s;
  11>.hmset: hiredis: 7.007s,   xredis: 6.664s;
  12>.hmget: hiredis: 6.845s,   xredis: 6.757s;
  13>.lpush: hiredis: 5.505s,   xredis: 6.311s;
  14>.rpush: hiredis: 5.674s,   xredis: 6.427s;


  以10000条为例：       单个命令操作                      批量命令操作
  1>.set:    hiredis：0.576s，   xredis：0.618s;    hiredis: 0.039s, xredis: 0.059s;
  2>.get：   hiredis：0.543s，   xredis：0.627s;    hiredis: 0.045s, xredis: 0.061s;
  3>.incr：  hiredis：0.555s，   xredis：0.619s;
  4>.mset:   hiredis: 0.617s,   xredis: 0.67s;
  5>.mget:   hiredis: 0.587s,   xredis: 0.617s;
  6>.hset:   hiredis: 0.592s,   xredis: 0.653s;
  7>.hget:   hiredis: 0.587s,   xredis: 0.616s;
  8>.zadd:   hiredis: 0.597s,   xredis: 0.715s;
  9>.zscore: hiredis: 0.583s,   xredis: 0.658s;
  10>.sadd:  hiredis: 0.595s,   xredis: 0.705s;
  11>.hmset: hiredis: 0.647s,   xredis: 0.791s;
  12>.hmget: hiredis: 0.646s,   xredis: 0.708s;
  13>.lpush: hiredis: 0.571s,   xredis: 0.665s;
  14>.rpush: hiredis: 0.566s,   xredis: 0.673s;




//HiRedis.php 与 ssdb 命令返回值区别 汇总：
1>.bitcount: ssdb当参数范围为空, 默认为（0，-1），返回值不同;
2>.ttl返回值相差1；
3>.hvals->hscan 返回值不同;如：["1200","1300","1400"]  ->  {"hmf":"1200","hmf1":"1300","hmf2":"1400"}
4>.zadd->zset : ssdb 不能批量添加；
5>.zrem->zdel : ssdb 不能批量删除;
8>.zrangebyscore : ssdb 中不存在;
9>.zremrangebyscore : ssdb 中不存在 ;
10>.zrevrangebyscore : ssdb 中不存在 ; 
11>.lpush->qpush_front | rpush ->qpush_back : 如果值为数组时，iredis、ssdb 添加正常，xredis则把数组当成一个元素  ;
12>.lrange->qslice : 如果参数为-100，100时，返回结果不同； 如果参数为0，100时，返回结果相同；
13>.sadd : ssdb 中不存在;

```