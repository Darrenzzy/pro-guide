```
Varnish 是一款高性能且开源的反向代理服务器和 HTTP 加速器

文档：https://www.ibm.com/developerworks/cn/opensource/os-cn-varnish-intro/index.html

安装依赖库
yum install -y libedit-devel  pcre-devel  ncurses-devel python-docutils make autoconf automake jemalloc-devel ibedit-devel ibtool pkgconfig python-sphinx

安装varnish
wget http://varnish-cache.org/_downloads/varnish-5.2.1.tgz 
tar zxvf varnish-5.2.1.tgz
cd varnish-5.2.1
./configure --prefix=/usr/local/system/varnish
make && make install

将/usr/local/system/varnish/bin 与 /usr/local/system/varnish/sbin 路径加入环境变量

创建varnish缓存文件
mkdir /usr/local/system/varnish/vcache/
touch /usr/local/system/varnish/vcache/varnish_cache.data

创建varnish配置文件
touch /usr/local/system/varnish/varnish_config.vcl

进入配置文件将下列代码复制进文件
vi /usr/local/system/varnish/varnish_config.vcl

*******************************************配置文件*******************************************
vcl 4.0;
import directors;
backend server1 {
    .host = "180.97.248.80";             # 该行为我们需要缓存的网址
    .port = "80";
}
backend server2 {
    .host = "180.97.248.82";             # 该行为我们需要缓存的网址
    .port = "80";
}
backend server3 {
    .host = "61.147.221.89";             # 该行为我们需要缓存的网址
    .port = "80";
}
backend server4 {
    .host = "61.147.221.90";             # 该行为我们需要缓存的网址
    .port = "80";
}
backend server5 {
    .host = "61.147.221.91";             # 该行为我们需要缓存的网址
    .port = "80";
}
backend server6 {
    .host = "61.147.221.93";             # 该行为我们需要缓存的网址
    .port = "80";
}
backend server7 {
    .host = "xiaomeihq.com";             # 该行为我们需要缓存的网址
    .port = "80";
}
# 该模块设置允许清除缓存的ip
acl purge {
    "localhost";
    "127.0.0.1";
}
# 初始化server对象
sub vcl_init{
    new server = directors.round_robin();
    server.add_backend(server1);
    server.add_backend(server2);
    server.add_backend(server3);
    server.add_backend(server4);
    server.add_backend(server5);
    server.add_backend(server6);
    new server_xiaomei = directors.round_robin();
    server_xiaomei.add_backend(server7);
}
# 该模块为请求入口
sub vcl_recv {
    # 如果请求类型为PURGE，并且用户ip可以匹配purge组中定义的ip，则清除缓存
    if (req.method == "PURGE") {
        if (!client.ip ~ purge)
        {
            #error 405 "Not allowed.";
            return(synth(405,"Not allowed for"+client.ip));
        }
        return(purge);
    }
    # 通过游览器请求的url地址指定我们的后台服务器
    if (req.http.host ~ "^cache.eaglewallet.io") {               # web1对应的域名
        #设置头信息host中的值(与我们需要缓存的网站ip一致)
        set req.http.host = "xiaomeihq.com";
        #指定使用我们前面配置好的后端
        set req.backend_hint = server_xiaomei.backend();
    }
    else {
        # 如果不匹配，向游览器页面输出的信息
        #error 404 "Caesar's cache-server ! Email:root@server110.com"; # 如果域名不在以上范围的出错提示
        return(synth(404,"Caesar's cache-server ! Email:root@server110.com"));
    }
    # 不合法的请求过滤掉
    if (req.method != "GET" &&
      req.method != "HEAD" &&
      req.method != "PUT" &&
      req.method != "POST" &&
      req.method != "TRACE" &&
      req.method != "OPTIONS" &&
      req.method != "DELETE") {
        return (pipe);
    }
    # 如果不是GET和HEAD就跳到pass 再确定是缓存还是穿透
    if (req.method != "GET" && req.method != "HEAD") {
        return(pass);
    }
    # 缓存通过上面所有判断的请求 (只剩下GET和HEAD了)
    return(hash);
}
# 定义pass模块
sub vcl_pass {
    # 有fetch,synth or restart 3种模式. fetch模式下 全部都不会缓存
    return (fetch);
}
# 定义hash模块(缓存事件)
sub vcl_hash {
    # 根据以下特征来判断请求的唯一性 并根据此特征来缓存请求的内容 特征为&关系
    # 1. 请求的url
    # 2. 请求的servername 如没有 就记录请求的服务器IP地址
    # 3. 请求的cookie
    hash_data(req.url);
    if (req.http.host) {
        hash_data(req.http.host);
    } else {
        hash_data(server.ip);
    }
    # 返回lookup , lookup不是一个事件(就是 并非指跳去sub vcl_lookup) 他是一个操作 他会检查有没有缓存 如没有 就会创建缓存
    return (lookup);
}
# 定义hit模块：缓存命中后执行的逻辑
sub vcl_hit {
    # 可以在这里添加判断事件(if) 可以返回 deliver restart synth 3个事件
    # deliver  表示把缓存内容直接返回给用户
    # restart  重新启动请求 不建议使用 超过重试次数会报错
    # synth    返回状态码 和原因 语法:return(synth(status code,reason))
    # 这里没有判断 所有缓存命中直接返回给用户
    return (deliver);
}
#缓存没有命中时执行的逻辑
sub vcl_miss
{
    # 此事件中 会默认给http请求加一个 X-Varnish 的header头 提示: nginx可以根据此header来判断是否来自varnish的请求(就不用起2个端口了)
    # 要取消此header头 只需要在这里添加 unset bereq.http.x-varnish; 即可
    # 这里所有不命中的缓存都去后端拿 没有其他操作 fetch表示从后端服务器拿取请求内容
    return (fetch);
}
####添加在页面head头信息中查看缓存命中情况########
sub vcl_deliver
{
    # set resp.http.*    用来添加header头 如 set resp.http.xxxxx = "haha"; unset为删除
    # set resp.status     用来设置返回状态 如 set resp.status = 404;
    # obj.hits        会返回缓存命中次数 用于判断或赋值给header头
    # req.restarts    会返回该请求经历restart事件次数 用户判断或赋值给header头
    if (obj.hits > 0)
    {
        set resp.http.X-Cache = "HIT";
    }
    else
    {
        set resp.http.X-Cache = "MISS";
    }
    #显示该资源缓存的时间 单位秒
    set resp.http.xxxxx_Age = resp.http.Age;
    #显示该资源命中的次数
    set resp.http.xxxxx_hit_count = obj.hits;
    #取消显示Age 为了不和CDN冲突
    unset resp.http.Age;
    return(deliver);
}
sub vcl_backend_response {
    # 后端返回如下错误状态码 则不缓存
    if (beresp.status == 499 || beresp.status == 404 || beresp.status == 502) {
        set beresp.uncacheable = true;
    }
    # 如请求php或jsp 则不缓存
    if(bereq.url ~ "\.(jpg|png)(\?|$)"){
        set beresp.ttl = 1d;
    }else{
        set beresp.uncacheable = true;
    }
    #开启grace模式 表示当后端全挂掉后 即使缓存资源已过期(超过缓存时间) 也会把该资源返回给用户 资源最大有效时间为6小时
    set beresp.grace = 6h;
    #返回给用户
    return (deliver);
}
********************************************************************************************

配置启动文件脚本
mkdir ~/bin
touch ~/bin/varnish
vi ~/bin/varnish
将下面启动脚本复制到文件中
#!/bin/bash
v_prefix="/usr/local/system/varnish"
v_retval=0
v_command="${v_prefix}/sbin/varnishd\
    -a 0.0.0.0:80\
    -f ${v_prefix}/varnish_config.vcl\
    -s file,${v_prefix}/vcache/varnish_cache.data,700G\
    -T 127.0.0.1:3000\
    -t 86400"

start() {
      echo -n "Starting Varnish: "
      $v_command
      v_retval=$?
}
stop() {
      echo -n "Stopping Varnish: "
      pkill varnishd
      v_retval=$?
}

case "$1" in
    start)
      start
  ;;
    stop)
      stop
  ;;
    *)
      echo "Usage: varnish {start|stop}"
      exit 1
  ;;
esac
exit $RETVA

将文件改为启动文件
chmod 777 ~/bin/varnish
启动 varnish start
停止 varnish stop

查看日志
varnishlog
查看缓存状态
varnishstat
进入后台管理
telnet 127.0.0.1 3000```