1. swoole的redis异步客户端依赖hiredis
git clone https://github.com/redis/hiredis.git
cd hiredis
make

将编译生成的libhiredis.so文件放到系统函数库目录中(并更新系统动态链接库，不然会找不到这个库)
cp libhiredis.so /usr/lib/
/sbin/ldconfig

将解压后的hiredis的源代码文件，即第一步解压后的文件放到系统函数库引用目录/usr/include或者/usr/local/include
mkdir /usr/local/include/hiredis
mv ./hiredis/*  /usr/local/include/hiredis/

2. 安装swoole
wget https://github.com/swoole/swoole-src/archive/master.zip -O swoole.zip
unzip swoole.zip
cd swoole-src-master
phpize
./configure --enable-async-redis --enable-openssl
make
sudo make install

3. 将编译好的so文件放到php.ini 里面




配置文件说明见官方文档
https://github.com/swoole/swoole-src/blob/master/examples/server.php

以下为swoole配置介绍

<?php
//文件名 setConfig.php
//来源http://wiki.swoole.com/wiki/page/274.html
//以下内容有不对的请告诉我，万分感谢
$setConfig = array();

// reactor线程数，reactor_num => 2，通过此参数来调节主进程内事件处理线程的数量，以充分利用多核。默认会启用CPU核数相同的数量。
// reactor_num一般设置为CPU核数的1-4倍，在swoole中reactor_num最大不得超过CPU核数*4。
// swoole的reactor线程是可以利用多核，如：机器有128核，那么swoole会启动128线程。每个线程能都会维持一个EventLoop。线程之间是无锁的，
// 指令可以被128核CPU并行执行。考虑到操作系统调度存在一定程度的偏差，可以设置为CPU核数*2，以便最大化利用CPU的每一个核。
$setConfig['reactor_num']=2;




// 设置启动的worker进程数。
// 业务代码是全异步非阻塞的，这里设置为CPU的1-4倍最合理
// 业务代码为同步阻塞，需要根据请求响应时间和系统负载来调整
// 比如1个请求耗时100ms，要提供1000QPS的处理能力，那必须配置100个进程或更多。
// 但开的进程越多，占用的内存就会大大增加，而且进程间切换的开销就会越来越大。所以这里适当即可。不要配置过大。
// 每个进程占用40M内存，那100个进程就需要占用4G内存
$setConfig['worker_num']=4;





// 设置worker进程的最大任务数。一个worker进程在处理完超过此数值的任务后将自动退出。这个参数是为了防止PHP进程内存溢出。
// 如果不希望进程自动退出可以设置为0
// 当worker进程内发生致命错误或者人工执行exit时，进程会自动退出。主进程会重新启动一个新的worker进程来处理任务
$setConfig['max_request']=2000;





// 服务器程序，最大允许的连接数，如max_conn => 10000, 此参数用来设置Server最大允许维持多少个tcp连接。超过此数量后，新进入的连接将被拒绝。
// max_connection最大不得超过操作系统ulimit -n的值，否则会报一条警告信息，并重置为ulimit -n的值
// max_connection默认值为ulimit -n的值
// WARN    swServer_start_check: serv->max_conn is exceed the maximum value[100000].
// 此参数不要调整的过大，根据机器内存的实际情况来设置。Swoole会根据此数值一次性分配一块大内存来保存Connection信息
$setConfig['max_conn']=10000;











// 配置task进程的数量，配置此参数后将会启用task功能。所以swoole_server务必要注册onTask/onFinish2个事件回调函数。如果没有注册，服务器程序将无法启动。
// task进程是同步阻塞的，配置方式与worker同步模式一致。
// task进程内不能使用swoole_server->task方法
// task进程内不能使用mysql-async/redis-async/swoole_event等异步IO函数
$setConfig['task_worker_num']=2;








// 设置task进程与worker进程之间通信的方式。
// 1, 使用unix socket通信
// 2, 使用消息队列通信
// 3, 使用消息队列通信，并设置为争抢模式
// 设置为3后，task/taskwait将无法指定目标进程ID
$setConfig['task_ipc_mode']=3;




// 设置task进程的最大任务数。一个task进程在处理完超过此数值的任务后将自动退出。
// 这个参数是为了防止PHP进程内存溢出。如果不希望进程自动退出可以设置为0。
// task_max_request默认为5000，受swoole_config.h的SW_MAX_REQUEST宏控制
// 1.7.17以上版本默认值调整为0，不会主动退出进程
$setConfig['task_max_request']=5000;








// 设置task的数据临时目录，在swoole_server中，如果投递的数据超过8192字节，
// 将启用临时文件来保存数据。这里的task_tmpdir就是用来设置临时文件保存的位置。
// 需要swoole-1.7.7+
$setConfig['task_tmpdir']="/tmp/tasl_tmpdir/";//路径我是随便写的







// 数据包分发策略。可以选择3种类型，默认为2
// 1，轮循模式，收到会轮循分配给每一个worker进程
// 2，固定模式，根据连接的文件描述符分配worker。这样可以保证同一个连接发来的数据只会被同一个worker处理
// 3，抢占模式，主进程会根据Worker的忙闲状态选择投递，只会投递给处于闲置状态的Worker
// 4，IP分配，根据TCP/UDP连接的来源IP进行取模hash，分配给一个固定的worker进程。
// 可以保证同一个来源IP的连接数据总会被分配到同一个worker进程
// 5，UID分配，需要用户代码中调用$serv->bind() 将一个连接绑定1个uid。然后swoole根据UID的值分配到不同的worker进程
// dispatch_mode 4,5两种模式，在 1.7.8以上版本可用
// dispatch_mode=1/3时，底层会屏蔽onConnect/onClose事件，原因是这2种模式下无法保证onConnect/onClose/onReceive的顺序
// 非请求响应式的服务器程序，请不要使用模式1或3
// SWOOLE_BASE模式
// dispatch_mode 配置在BASE模式是无效的，因为BASE不存在投递任务。
// 当reactor收到客户端发来的数据后会立即回调onReceive，不需要投递Worker进程。
$setConfig['dispatch_mode']=2;










// 设置消息队列的KEY，仅在ipc_mode = 2或task_ipc_mode = 2时使用。
// 设置的Key仅作为队列的基数。此参数的默认值为ftok($php_script_file, 1)。实际使用的消息队列KEY为：
// recv数据消息队列KEY为 message_queue_key
// send数据消息队列KEY为 message_queue_key + 1
// task数据消息队列KEY为 message_queue_key + 2
// recv/send数据队列在server结束后，会自动销毁。
// task队列在server结束后不会销毁，重新启动程序后，task进程仍然会接着处理队列中的任务。
// 1.7.8以前的版本，KEY会+serv->master_pid。增加pid是为了防止服务器程序重启，导致复用上一次的消息队列数据，读取到错误的数据
$setConfig['message_queue_key']=2;








// 守护进程化。设置daemonize => 1时，程序将转入后台作为守护进程运行。长时间运行的服务器端程序必须启用此项。
// 如果不启用守护进程，当ssh终端退出后，程序将被终止运行。
// 启用守护进程后，标准输入和输出会被重定向到 log_file
// 如果未设置log_file，将重定向到 /dev/null，所有打印屏幕的信息都会被丢弃
$setConfig['daemonize']=1;





// Listen队列长度，如backlog => 128，此参数将决定最多同时有多少个等待accept的连接。
// 与php-fpm/apache等软件不同，swoole并不依赖backlog来解决连接排队的问题。所以不需要设置太大的backlog参数。
$setConfig['backlog']= 128;




// log_file => '/data/log/swoole.log', 指定swoole错误日志文件。
// 在swoole运行期发生的异常信息会记录到这个文件中。默认会打印到屏幕。
// 注意log_file不会自动切分文件，所以需要定期清理此文件。
// 观察log_file的输出，可以得到服务器的各类异常信息和警告。
// log_file中的日志仅仅是做运行时错误记录，没有长久存储的必要。
// 开启守护进程模式后(daemonize => true)，标准输出将会被重定向到log_file。
// 在PHP代码中echo/var_dump/print等打印到屏幕的内容会写入到log_file文件
$setConfig['log_file']='/data/log/swoole.log';




// 启用心跳检测，此选项表示每隔多久轮循一次，单位为秒。
// 如 heartbeat_check_interval => 60，表示每60秒，遍历所有连接，如果该连接在60秒内，没有向服务器发送任何数据，此连接将被强制关闭。
// swoole_server并不会主动向客户端发送心跳包，而是被动等待客户端发送心跳。
// 服务器端的heartbeat_check仅仅是检测连接上一次发送数据的时间，如果超过限制，将切断连接。
// heartbeat_check仅支持TCP连接
$setConfig['heartbeat_check_interval']=60;


// 与heartbeat_check_interval配合使用。表示连接最大允许空闲的时间。如
// array(
// 'heartbeat_idle_time' => 600,
// 'heartbeat_check_interval' => 60,
// );
// 表示每60秒遍历一次，一个连接如果600秒内未向服务器发送任何数据，此连接将被强制关闭。
$setConfig['heartbeat_idle_time']=600;





// 打开EOF检测，此选项将检测客户端连接发来的数据，当数据包结尾是指定的字符串时才会投递给Worker进程。
// 否则会一直拼接数据包，直到超过缓存区或者超时才会中止。当出错时swoole底层会认为是恶意连接，丢弃数据并强制关闭连接。
// array(
// 'open_eof_check' => true, //打开EOF检测
// 'package_eof' => "\r\n", //设置EOF
// )
// 常见的Memcache/SMTP/POP等协议都是以\r\n结束的，就可以使用此配置。
//开启后可以保证Worker进程一次性总是收到一个或者多个完整的数据包。

// EOF检测不会从数据中间查找eof字符串，所以Worker进程可能会同时收到多个数据包，
// 需要在应用层代码中自行explode("\r\n", $data) 来拆分数据包
// 1.7.15版本增加了open_eof_split，支持从数据中查找EOF，并切分数据
$setConfig['open_eof_check']=1;



// package_eof
// 与open_eof_check配合使用，设置EOF字符串。
// package_eof最大只允许传入8个字节的字符串
$setConfig['package_eof']="\r\n";






// open_eof_split
// 启用EOF自动分包。当设置open_eof_check后，底层检测数据是否以特定的字符串结尾来进行数据缓冲。
// 但默认只截取收到数据的末尾部分做对比。这时候可能会产生多条数据合并在一个包内。

// 启用open_eof_split参数后，底层会从数据包中间查找EOF，并拆分数据包。
// onReceive每次仅收到一个以EOF字串结尾的数据包。
// open_eof_split在1.7.15以上版本可用
$setConfig['open_eof_split']=1;



// 打开包长检测特性。包长检测提供了固定包头+包体这种格式协议的解析。
// 启用后，可以保证Worker进程onReceive每次都会收到一个完整的数据包。
$setConfig['open_length_check']=1;





// s ：有符号、主机字节序、2字节短整型
// S：无符号、主机字节序、2字节短整型
// n：无符号、网络字节序、2字节短整型
// N：无符号、网络字节序、4字节整型
// l：有符号、主机字节序、2字节短整型（小写L）
// L：无符号、主机字节序、2字节短整型（大写L）

$setConfig['package_length_type']='s';




// 设置最大数据包尺寸，开启open_length_check/open_eof_check/open_http_protocol等协议解析后。
// swoole底层会进行数据包拼接。这时在数据包未收取完整时，所有数据都是保存在内存中的。

// 所以需要设定package_max_length，一个数据包最大允许占用的内存尺寸。
// 如果同时有1万个TCP连接在发送数据，每个数据包2M，那么最极限的情况下，就会占用20G的内存空间。

// open_length_check，当发现包长度超过package_max_length，将直接丢弃此数据，并关闭连接，不会占用任何内存。
// open_eof_check，因为无法事先得知数据包长度，所以收到的数据还是会保存到内存中，持续增长。
// 当发现内存占用已超过package_max_length时，将直接丢弃此数据，并关闭连接
// open_http_protocol，GET请求最大允许8K，而且无法修改配置。
// POST请求会检测Content-Length，如果Content-Length超过package_max_length，将直接丢弃此数据，发送http 400错误，并关闭连接
// 此参数不宜设置过大，否则会占用很大的内存
$setConfig['package_max_length']=2;




// 启用CPU亲和性设置。在多核的硬件平台中，启用此特性会将swoole的reactor线程/worker进程绑定到固定的一个核上。
//可以避免进程/线程的运行时在多个核之间互相切换，提高CPU Cache的命中率。
// 使用taskset命令查看进程的CPU亲和设置：
// taskset -p 进程ID
// pid 24666's current affinity mask: f
// pid 24901's current affinity mask: 8
// mask是一个掩码数字，按bit计算每bit对应一个CPU核，如果某一位为0表示绑定此核，进程会被调度到此CPU上，为0表示进程不会被调度到此CPU。
// 示例中pid为24666的进程mask = f 表示未绑定到CPU，操作系统会将此进程调度到任意一个CPU核上。
// pid为24901的进程mask = 8，8转为二进制是 1000，表示此进程绑定在第4个CPU核上。
// 仅推荐在全异步非阻塞的Server程序中启用
$setConfig['open_cpu_affinity']=1;




// IO密集型程序中，所有网络中断都是用CPU0来处理，如果网络IO很重，CPU0负载过高会导致网络中断无法及时处理，那网络收发包的能力就会下降。
// 如果不设置此选项，swoole将会使用全部CPU核，底层根据reactor_id或worker_id与CPU核数取模来设置CPU绑定。
// 如果内核与网卡有多队列特性，网络中断会分布到多核，可以缓解网络中断的压力
// 此选项必须与open_cpu_affinity同时设置才会生效
// array('cpu_affinity_ignore' => array(0, 1))
// 接受一个数组作为参数，array(0, 1) 表示不使用CPU0,CPU1，专门空出来处理网络中断。
$setConfig['cpu_affinity_ignore']=array(0, 1);





// open_tcp_nodelay
// 启用open_tcp_nodelay，开启后TCP连接发送数据时会关闭Nagle合并算法，
// 立即发往客户端连接。在某些场景下，如http服务器，可以提升响应速度
$setConfig['open_tcp_nodelay']=1;





//启用tcp_defer_accept特性，可以设置为一个数值，表示当一个TCP连接有数据发送时才触发accept。
$setConfig['tcp_defer_accept']=5;




// 设置SSL隧道加密，设置值为一个文件名字符串，制定cert证书和key的路径。
$setConfig['ssl_cert_file']='/config/ssl.crt';
$setConfig['ssl_key_file']='/config//ssl.key';




// 设置worker/task子进程的所属用户。服务器如果需要监听1024以下的端口，
// 必须有root权限。但程序运行在root用户下，代码中一旦有漏洞，攻击者就可以以root的方式执行远程指令，风险很大。
// 配置了user项之后，可以让主进程运行在root权限下，子进程运行在普通用户权限下。
// 此配置在swoole-1.7.9以上版本可用
// 仅在使用root用户启动时有效
$setConfig['user']='apache';
// 设置worker/task子进程的进程用户组。与user配置相同，此配置是修改进程所属用户组，提升服务器程序的安全性。
$setConfig['group']='www-data';
// 重定向Worker进程的文件系统根目录。此设置可以使进程对文件系统的读写与实际的操作系统文件系统隔离。提升安全性
$setConfig['chroot']='/data/server/';







// 调整管道通信的内存缓存区长度。swoole的reactor线程与worker进程之间使用unix socket进行通信，
// 在收发大量数据的场景下，需要启用内存缓存队列。此函数可以修改内存缓存的长度。
// 此参数在1.7.17以上版本默认为32M，1.7.17以下版本默认为8M
$setConfig['pipe_buffer_size']=2;







// 此配置影响swoole 2个方面
// 数据发送缓存区
// 调整连接发送缓存区的大小。TCP通信有拥塞控制机制，服务器向客户端发送大量数据时，并不能立即发出。这时发送的数据会存放在服务器端的内存缓存区内。此参数可以调整内存缓存区的大小。
// 如果发送数据过多，客户端阻塞，数据占满缓存区后Server会报如下错误信息：
// swFactoryProcess_finish: send failed, session#1 output buffer has been overflowed.
// swoole_server->send大小
// 调用 swoole_server->send， swoole_http_server->end/write，swoole_websocket_server->push 时，最大发送的数据不得超过 buffer_output_size 配置。
// buffer_output_size默认为2M，缓存区塞满后send将会失败
// 注意此函数不应当调整过大，避免拥塞的数据过多，导致吃光机器内存
// 开启大量worker进程时，将会占用worker_num * buffer_output_size 字节的内存
$setConfig['buffer_output_size']=2;//




// enable_unsafe_event
// swoole在配置dispatch_mode=1或3后，因为系统无法保证onConnect/onReceive/onClose的顺序，默认关闭了onConnect/onClose事件。

// 如果应用程序需要onConnect/onClose事件，并且能接受顺序问题可能带来的安全风险，
//可以通过设置 enable_unsafe_event = true，启用onConnect/onClose事件

// enable_unsafe_event配置在1.7.18以上版本可用

$setConfig['enable_unsafe_event']=1;




// swoole在配置dispatch_mode=1或3后，系统无法保证onConnect/onReceive/onClose的顺序，因此可能会有一些请求数据在连接关闭后，才能到达Worker进程。
// discard_timeout_request配置默认为true，表示如果worker进程收到了已关闭连接的数据请求，将自动丢弃。
// discard_timeout_request如果设置为false，表示无论连接是否关闭Worker进程都会处理数据请求。
$setConfig['discard_timeout_request']=1;