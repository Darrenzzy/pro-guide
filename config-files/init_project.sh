#!/bin/bash
yum install  -y readline-devel libevent-devel iotop zlib-devel iptraf libmcrypt libmcrypt-devel mcrypt mhash openssl-devel curl-devel bison autoconf libxml2-devel libedit-devel ImageMagick re2c pcre-devel  pcre-devel

wget http://私有的仓库/postgresql-9.6.0.tar.gz
wget http://私有的仓库/nginx-1.8.0.tar.gz
wget http://私有的仓库/php-5.6.28.tar.gz
wget http://私有的仓库/phpredis.tar.gz
wget http://私有的仓库/phpssdb.tar.gz
wget http://私有的仓库/phalcon-v2.0.13.tar.gz
wget http://私有的仓库/composer_installer 
wget http://私有的仓库/redis-3.2.4.tar.gz
wget http://私有的仓库/ssdb.zip
wget http://私有的仓库/es2.4.1.tar.gz
wget http://私有的仓库/icomet.zip
wget http://私有的仓库/jdk-8u111-linux-x64.tar.gz
wget http://私有的仓库/nginx.conf
wget http://私有的仓库/php-fpm.conf
wget http://私有的仓库/php.ini
wget http://私有的仓库/fpm
wget http://私有的仓库/nginx.conf


tar -zxvf postgresql-9.6.0.tar.gz
cd postgresql-9.6.0
./configure
make
make install
cd ..


tar -zxvf nginx-1.8.0.tar.gz
cd nginx-1.8.0
./configure --with-http_ssl_module
make 
make install
cd ..



tar -zxvf php-5.6.28.tar.gz
cd php-5.6.28
./configure --with-pgsql --with-pdo-pgsql --with-openssl --with-mcrypt --enable-zip --enable-mbstring --enable-fpm --enable-opcache  --with-curl --with-readline --enable-pcntl   --enable-sysvmsg  --with-zlib
make
make install
cd ..


tar -zxvf phpredis.tar.gz
cd phpredis
phpize
./configure
make
make install
cd ..


tar -zxvf phpssdb.tar.gz
cd phpssdb
phpize
./configure
make
make install
cd ..


tar -zxvf phalcon-v2.0.13.tar.gz
cd cphalcon-phalcon-v2.0.13
cd build
./install
cd ..



php composer_installer
mv composer.phar /usr/local/bin/composer


unzip ssdb.zip 
cd ssdb-master/
make
make install
cd ..


tar -zxvf redis-3.2.4.tar.gz 
cd redis-3.2.4
make
make install
cd ..

tar  -zxvf jdk-8u111-linux-x64.tar.gz
mv jdk1.8.0_111 /usr/local/
ln -s /usr/local/jdk1.8.0_111/bin/java /usr/bin/java

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

tar -zxvf es2.4.1.tar.gz
mv elasticsearch-2.4.1 /usr/local/system/



