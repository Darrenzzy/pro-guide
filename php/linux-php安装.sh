#!/bin/bash
yum -y install postgresql-devel libc-client readline-devel zlib-devel  libmcrypt libmcrypt-devel mcrypt mhash openssl-devel curl-devel bison autoconf libxml2-devel libedit-devel ImageMagick re2c pcre-devel libpng-devel libjpeg-devel freetype-devel libevent-devel git gcc-c++ zip unzip gmp-devel iptraf psmisc automake

mkdir /usr/local/system/log

wget https://ftp.postgresql.org/pub/source/v9.6.0/postgresql-9.6.0.tar.gz

tar -zxvf postgresql-9.6.0.tar.gz
cd postgresql-9.6.0
./configure
make
make install
cd ..

wget http://nginx.org/download/nginx-1.15.1.tar.gz
tar -zxvf nginx-1.15.1.tar.gz
cd nginx-1.15.1
./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_gzip_static_module --with-http_stub_status_module --with-http_sub_module --with-stream
# 报错信息如下：

# /bin/sh: line 2: ./config: No such file or directory
# make[1]: *** [/usr/local/ssl/.openssl/include/openssl/ssl.h] Error 127
# make[1]: Leaving directory `/usr/local/src/nginx-1.9.9'
# make: *** [build] Error 2
# 根据报错信息我们知道，出错是因为Nginx在编译时并不能在/usr/local/ssl/.openssl/ 这个目录找到对应的文件，
# 其实我们打开/usr/local/ssl/这个目录可以发现这个目录下是没有.openssl目录的，因此我们修改Nginx编译时对openssl的路径选择就可以解决这个问题了

# 解决方案：

# 打开nginx源文件下的/usr/local/src/nginx-1.9.9/auto/lib/openssl/conf文件：

# 找到这么一段代码：


# 1
# 2
# 3
# 4
# 5
# CORE_INCS="$CORE_INCS $OPENSSL/.openssl/include"
# CORE_DEPS="$CORE_DEPS $OPENSSL/.openssl/include/openssl/ssl.h"
# CORE_LIBS="$CORE_LIBS $OPENSSL/.openssl/lib/libssl.a"
# CORE_LIBS="$CORE_LIBS $OPENSSL/.openssl/lib/libcrypto.a"
# CORE_LIBS="$CORE_LIBS $NGX_LIBDL"
# 修改成以下代码：


# 1
# 2
# 3
# 4
# 5
# CORE_INCS="$CORE_INCS $OPENSSL/include"
# CORE_DEPS="$CORE_DEPS $OPENSSL/include/openssl/ssl.h"
# CORE_LIBS="$CORE_LIBS $OPENSSL/lib/libssl.a"
# CORE_LIBS="$CORE_LIBS $OPENSSL/lib/libcrypto.a"
# CORE_LIBS="$CORE_LIBS $NGX_LIBDL"
# 然后再进行Nginx的编译安装即可
make
make install
cd ..

wget http://cn2.php.net/distributions/php-7.2.1.tar.gz
tar -zxvf php-7.2.1.tar.gz
cd php-7.2.1
./configure --with-pgsql --with-pdo-pgsql --with-pdo-mysql --with-openssl --enable-zip --enable-mbstring --enable-fpm --enable-opcache  --with-curl --with-readline --enable-pcntl   --enable-sysvmsg  --with-zlib --with-gd --with-jpeg-dir  --with-png-dir --with-freetype-dir --enable-bcmath --with-gmp
make
make install
cd ..

https://github.com/phpredis/phpredis/archive/4.0.2.tar.gz  -O phpredis-4.0.2.tar.gz
tar -zxvf phpredis-4.0.2.tar.gz
cd phpredis-4.0.2
phpize
./configure
make
make install
cd ..


git clone https://github.com/jonnywang/phpssdb.git
cd phpssdb
git checkout php7
phpize
./configure
make
make install
cd ..

git clone https://github.com/phalcon/cphalcon.git
cd cphalcon/build
./install
cd ../..


curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

wget --no-check-certificate https://github.com/ideawu/ssdb/archive/master.zip  -O ssdb.zip
unzip ssdb.zip
cd ssdb-master/
make
make install
cd ..

wget http://download.redis.io/releases/redis-3.2.4.tar.gz
tar -zxvf redis-3.2.4.tar.gz 
cd redis-3.2.4
make
make install


wget http://git.365yf.com/linux_config/conf.tgz
tar -zxvf conf.tgz
cd conf


files=(
/usr/local/nginx/conf/nginx.conf
/usr/local/etc/php-fpm.conf
/usr/local/lib/php.ini
/usr/local/sbin/fpm
)
for file in ${files[@]};
do
	if [ -f "$file" ]; then
		rm $file
	fi
done

cp nginx.conf /usr/local/nginx/conf/nginx.conf
cp php-fpm.conf /usr/local/etc/php-fpm.conf
cp php.ini /usr/local/lib/php.ini
cp fpm /usr/local/sbin/fpm
chmod +x /usr/local/sbin/fpm

