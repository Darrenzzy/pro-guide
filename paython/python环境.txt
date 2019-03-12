python 环境

brew install pypcap libdnet

echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> /Users/wolftail/Library/Python/2.7/lib/python/site-packages/homebrew.pth

mkdir -p /Users/wolftail/Library/Python/2.7/lib/python/site-packages
echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> /Users/wolftail/Library/Python/2.7/lib/python/site-packages/homebrew.pth


linux 安装
http://ruter.sundaystart.net/2015/12/03/Update-python/


https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz
tar -zxvf Python-2.7.13.tgz
cd Python-2.7.13
./configure 