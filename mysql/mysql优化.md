

mysql中 ，in语句中参数个数是不限制的。不过对整段sql语句的长度有了限制
官方解释看这 https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_max_allowed_packet 5
报文大小限制默认4M。

在tidb的代码中也有类似的限制：
// Run reads client query and writes query result to client in for loop, if there is a panic during query handling,
// it will be recovered and log the panic error.
// This function returns and the connection is closed if there is an IO error or there is a panic.
func (cc *clientConn) Run(ctx context.Context) {
  const size = 4096



feed.sql innodb_buffer_pool_size默认值是128M，
  最小5M(当小于该值时会设置成5M)，最大为LLONG_MAX。
  当innodb_buffer_pool_instances设置大于1的时候，buffer pool size最小为1GB。
  同时buffer pool size需要是innodb_buffer_pool_chunk_size*innodb_buffer_pool_instances的倍数。
  innodb_buffer_pool_chunk_size默认为128M，最小为1M，实例启动后为只读参数。

  在专用的数据库服务器上一般设置为服务器内存的70-80%

innodb_buffer_pool_size=5G
sort_buffer_size=16M

innodb_flush_log_at_trx_commit = 1
#关键参数，0代表大约每秒写入到日志并同步到磁盘，数据库故障会丢失1秒左右事务数据。
1为每执行一条SQL后写入到日志并同步到磁盘，I/O开销大，执行完SQL要等待日志读写，效率低。2代表只把日志写入到系统缓存区，再每秒同步到磁盘，效率很高，如果服务器故障，才会丢失事务数据。
对数据安全性要求不是很高的推荐设置2，性能高，修改后效果明显。

log_queries_not_using_indexes=1/0; # 1表示未使用索引的sql都会打印慢日志
innodb_buffer_pool_instances=1; #跟你innodb_buffer_pool_size配合使用，当innodb_buffer_pool_size大于1G的时候设置大于1


## 设计表接口行格式时候 推荐用 dynamic ，默认也是这个 
  ROW_FORMAT 的值如下: 从上到下一次变得严谨， 

  FIXED 每个字段动态大小，比如一行数据大于一个页的量会发生塞不进去

  DYNAMIC 其实就存储一个指针，数据都放在溢出页里 ，代表将长字段(发生行溢出)完全off-page存储。

  COMPRESSED 和上面dynamic一样模式，只是会用zlib的算法进行压缩，对于BLOB、TEXT、VARCHAR这类大长度数据能够进行有效的存储（减少40%，但对CPU要求更高）

  REDUNDANT 行数据都记录在叶子节点页里面。

  COMPACT  溢出列存储前768字节

  参考：https://www.cnblogs.com/wilburxu/p/9435818.html