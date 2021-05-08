wget http://nginx.org/download/nginx-1.14.0.tar.gz

tar -xzvf nginx-1.14.0.tar.gz
cd nginx-1.14.0

编译安装:
./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_gzip_static_module --with-http_stub_status_module --with-http_sub_module --with-stream

如果报错信息如下：

/bin/sh: line 2: ./config: No such file or directory
make[1]: *** [/usr/local/ssl/.openssl/include/openssl/ssl.h] Error 127
make[1]: Leaving directory `/usr/local/src/nginx-1.9.9'
make: *** [build] Error 2
根据报错信息我们知道，出错是因为Nginx在编译时并不能在/usr/local/ssl/.openssl/ 这个目录找到对应的文件，
其实我们打开/usr/local/ssl/这个目录可以发现这个目录下是没有.openssl目录的，因此我们修改Nginx编译时对openssl的路径选择就可以解决这个问题了

解决方案：

打开nginx源文件下的/usr/local/src/nginx-1.9.9/auto/lib/openssl/conf文件：

找到这么一段代码：


1
2
3
4
5
CORE_INCS="$CORE_INCS $OPENSSL/.openssl/include"
CORE_DEPS="$CORE_DEPS $OPENSSL/.openssl/include/openssl/ssl.h"
CORE_LIBS="$CORE_LIBS $OPENSSL/.openssl/lib/libssl.a"
CORE_LIBS="$CORE_LIBS $OPENSSL/.openssl/lib/libcrypto.a"
CORE_LIBS="$CORE_LIBS $NGX_LIBDL"
修改成以下代码：


1
2
3
4
5
CORE_INCS="$CORE_INCS $OPENSSL/include"
CORE_DEPS="$CORE_DEPS $OPENSSL/include/openssl/ssl.h"
CORE_LIBS="$CORE_LIBS $OPENSSL/lib/libssl.a"
CORE_LIBS="$CORE_LIBS $OPENSSL/lib/libcrypto.a"
CORE_LIBS="$CORE_LIBS $NGX_LIBDL"
然后再进行Nginx的编译安装即可
make
make install

events {
    use epoll;
    worker_connections  51200;
}

## Size Limits
large_client_header_buffers 8 12k;
client_body_buffer_size   32k;
client_header_buffer_size 8k;

## Timeouts
client_body_timeout   20s;
client_header_timeout 20s;
keepalive_timeout     50s;
send_timeout          20s;

#fastcgi参数设置
fastcgi_connect_timeout 300s;
fastcgi_send_timeout 300s;
fastcgi_read_timeout 300s;
fastcgi_buffer_size 128k;
fastcgi_buffers 8 128k;#8 128
fastcgi_busy_buffers_size 256k;
fastcgi_temp_file_write_size 256k;
fastcgi_intercept_errors on;

#上传文件大小
client_max_body_size 50m;

sendfile        on;


 server {
        listen       443 ssl reuseport;
        server_name  _;

        ssl_certificate      du91.cn.crt;
        ssl_certificate_key  du91.cn.key;

        ssl_session_cache        shared:SSL:50m;
        ssl_session_timeout      1d;

        ssl_session_tickets      on;

        ssl_stapling             on;
        ssl_stapling_verify      on;


       
        ssl_prefer_server_ciphers  on;
        ssl_protocols              TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers    EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
        resolver                   223.5.5.5 valid=300s;
        resolver_timeout           10s;  
        location / {
          proxy_pass   http://127.0.0.1:80;
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Real-Ip $remote_addr;
        }

    }

反向代理配置:

在http模块配置upstream

例如:
upstream proxy{
    server 192.168.1.2:80;
}
然后在server配置location:

location / {
    proxy_pass http://proxy;
    proxy_read_timeout 300;
    proxy_connect_timeout 300;
    proxy_redirect     off;

    proxy_set_header   Host              $host;
    proxy_set_header   X-Real-IP         $remote_addr;
    proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header   X-Forwarded-Proto $scheme;
}

或者不单独配置upstream，直接在location

location / {
    proxy_pass http://192.168.1.2;
}

可以通过获取到的http header动态代理到对应的host, 通过变量$http_name来获取header值
因为proxy_pass设置的是变量，需要单独设置dns解析

set $real_host $http_real_host;
location / {
    resolver 114.114.114.114 valid=300s;
    proxy_pass http://$real_host;
    proxy_set_header Host $real_host;
}

SSL 设置示例

先生成一个证书:
openssl dhparam -out /usr/local/nginx/conf/ssl/dhparam.pem 2048

server {
      listen 80;
      server_name _;
      rewrite ^(.*)$  https://$host$1 permanent;
}

server {
      server_name _;
      listen       443;

      ssl_certificate      /usr/local/nginx/conf/ssl/domian.pem;
      ssl_certificate_key  /usr/local/nginx/conf/ssl/domian.key;
      ssl_dhparam          /usr/local/nginx/conf/ssl/dhparam.pem;

      ssl                  on;
      ssl_session_timeout  5m;
      ssl_protocols  TLSv1.2;
      ssl_prefer_server_ciphers   on;
      ssl_ciphers  'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';


      server_tokens off;
      charset utf-8;
      root /usr/local/system/project/public;
      index index.php index.html;
      try_files $uri @rewrite;

      location @rewrite {
         rewrite ^/(.*)$ /index.php?_url=/$1;
      }

      location ~ \.php {
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_index index.php;
                include fastcgi_params;
                fastcgi_split_path_info       ^(.+\.php)(/.+)$;
                fastcgi_param PATH_INFO       $fastcgi_path_info;
                fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      }
}
