项目中没有使用到,(选择性安装)
```
mysql安装
wget https://downloads.mariadb.org/interstitial/mariadb-10.0.17/source/mariadb-10.0.17.tar.gz/from/http%3A//ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb
tar -zxvf mariadb-10.0.17.tar.gz
cd mariadb-10.0.17
cmake .
make
sudo make install
```
```
配置：
 command: [
            '--character-set-server=utf8',
      '--collation-server=utf8_unicode_ci',
      ]
character_set_server、collation_server分别对应server字符集、server字符序
```