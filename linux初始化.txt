tip:

如果pvcreate命令不存在，运行以下命令安装
yum install lvm2

格式化硬盘：

fdisk /dev/vdb
n --新建分区
p --选择Primary partition
1 --选择主分区号
default --按回车默认
default --按回车默认
t  --选择分区格式
8e --选择lvm格式
wq --保存推出

pvcreate /dev/vdb1 --创建物理卷
vgcreate mygroup /dev/vdb1 --创建逻辑卷组
vgchange -ay mygroup --更改逻辑卷组状态为活动

#lvcreate -L 100%FREE data mygroup 创建逻辑卷
lvcreate -n data -l 100%FREE mygroup


mkfs.ext4 /dev/mapper/mygroup-data --格式化为ext4

mkdir /usr/local/system --创建system目录

vim /etc/fstab ---更改启动配置
/dev/mygroup/data       /usr/local/system       ext4    defaults        0 0

mount -a 挂载硬盘


############
GPT硬盘不支持fdisk分区，要用parted

parted /dev/vdb
mklabel gpt
mkpart
set 1 lvm on

pvcreate /dev/vdb1
vgcreate mygroup /dev/vdb1
vgchange -ay mygroup

lvcreate -n data -l 100%FREE mygroup


mkfs.ext4 /dev/mapper/mygroup-data --格式化为ext4

mkdir /usr/local/system --创建system目录

vim /etc/fstab ---更改启动配置
/dev/mygroup/data       /usr/local/system       ext4    defaults        0 0

mount -a 挂载硬盘


加载第二个硬盘：

1: 使用parted分区
2: pvcreate /dev/vdc1 ---创建物理卷
3: vgextend mygroup /dev/vdc1 ---扩展逻辑卷组
4: lvextend -l +100%FREE /dev/mygroup/data ---扩展逻辑卷
5: resize2fs /dev/mygroup/data ---resize-filesystem

yum install gcc gcc-c++ glibc-static -y
yum -y install readline-devel zlib-devel  libmcrypt libmcrypt-devel mcrypt mhash openssl-devel curl-devel bison autoconf libxml2-devel libedit-devel ImageMagick re2c pcre-devel libpng-devel libjpeg-devel freetype-devel libevent-devel git gcc-c++ zip unzip gmp-devel



