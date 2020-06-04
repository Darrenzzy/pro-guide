#!/bin/bash
#linux下 gcc升级脚本，支持c++11

wget ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.8.2/gcc-4.8.2.tar.bz2  
tar -jxvf gcc-4.8.2.tar.bz2  
cd gcc-4.8.2
./contrib/download_prerequisities

cd gmp  
mkdir build  
cd build  
../configure --prefix=/usr/local/gcc/gmp-4.3.2  
make
make install

cd ../../mpfr  
mkdir build  
cd build  
../configure --prefix=/usr/local/gcc/mpfr-2.4.2 --with-gmp=/usr/local/gcc/gmp-4.3.2  
make
make install

cd ../../mpc  
mkdir build  
cd build  
../configure --prefix=/usr/local/gcc/mpc-0.8.1 --with-mpfr=/usr/local/gcc/mpfr-2.4.2 --with-gmp=/usr/local/gcc/gmp-4.3.2  
make
make install

echo '/usr/local/gcc/gmp-4.3.2/lib'  >>  /etc/ld.so.conf
echo '/usr/local/gcc/mpfr-2.4.2/lib' >>  /etc/ld.so.conf
echo '/usr/local/gcc/mpc-0.8.1/lib'  >>  /etc/ld.so.conf

ldconfig

cd ../..  
mkdir build  
cd build  
../configure --prefix=/usr/local/gcc --enable-threads=posix --disable-checking --enable-languages=c,c++ --disable-multilib  
make
make install
yum remove gcc  
ln -s /usr/local/gcc/bin/gcc /usr/bin/gcc  
ln -s /usr/local/gcc/bin/g++ /usr/bin/g++   

rm -rf /usr/lib64/libstdc++.so.6
cp build/x86_64-unknown-linux-gnu/libstdc++-v3/src/.libs/libstdc++.so.6.0.18 /usr/lib64/
ln -s /usr/lib64/libstdc++.so.6.0.18 /usr/lib64/libstdc++.so.6
cd ..
wget http://www.cmake.org/files/v3.3/cmake-3.3.0.tar.gz
tar -zxvf cmake-3.3.0.tar.gz 
cd cmake-3.3.0
./configure
make 
make install

