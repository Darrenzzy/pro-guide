
### Redis 数据库keys 命令的模糊查询 支持的通配符
* 第一种：*   // key中含有keyword 的key
* keys *keyword*
* 第二种：？  // 你知道前面的一些字母，忘记了最后一个字母
* keys hell？
* 第三种：[]  // 你只记得第一个字母是h，他的长度是5
* keys h？？？？
* 可以避免redis阻塞的命令，通过轮询查看
* scan 0 match key* count 10
* 无阻塞
* scan 0 MATCH *key* COUNT 10000 


### 启动和停止ssdb服务
启动：ssdb-server /usr/local/etc/ssdb.conf
守护进程启动方式 ssdb-server -d /usr/local/etc/ssdb.conf
停止： ssdb-server /usr/local/etc/ssdb.conf -s stop
重启：停止： ssdb-server /usr/local/etc/ssdb.conf -s restart
启动客户端:ssdb-cli

支持数据类型
SSDB ⽀持三种数据类型, 别分是 KV(key-value), Hashmap(map), Zset(sorted set).

work_dir = /usr/local/var/db/ssdb/
pidfile = /usr/local/var/run/ssdb.pid

* redis是内存数据库，ssdb是面向硬盘的存储;ssdb默认也没有集群管理的支持它结合了redis和ssdb的优点，实现了基于LFU的热度统计和冷热交换，做到了低成本和高性能的高平衡



### redis已安装：
redis-server /usr/local/etc/redis.conf

### 12.24
redis统计大key
redis-cli  -h 127.0.0.1  -i 0.1  --bigkeys

批量删除
redis-cli -h 127.0.0.1 -a password keys PHP_GGV1* |xargs redis-cli -h 127.0.0.1 -a password del


### 7.3
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



### 4.30
redis监控实时日志
127.0.0.1:6379>monitor

### 4.24
连接redis
redis-cli -h 127... -p 6379 -a password -n db1
或者：
redis-cli -h 127... 连接池
auth password  验证密码
select 1 选择db1库

### 12.21
redis: 有序集（key score member）且不允许重复的成员
zset

哈希存储：Redis hash 是一个string类型的field和value的映射表，hash特别适合用于存储对象
集合：Redis 的 Set 是 String 类型的无序集合。集合成员是唯一的，这就意味着集合中不能出现重复的数据

String——字符串
Hash——字典
List——列表
Set——集合
Sorted Set——有序集合

