1: 先安装ruby版本管理工具rvm
 1) curl -sSL https://get.rvm.io | bash
    $rvm_path 是rvm的安装路径
    source /etc/profile.d/rvm.sh

 #替换成淘宝的源
 2) linux: sed -i 's!cache.ruby-lang.org/pub/ruby!ruby.taobao.org/mirrors/ruby!' $rvm_path/config/db
    macos: sed -i '' 's!cache.ruby-lang.org/pub/ruby!ruby.taobao.org/mirrors/ruby!' $rvm_path/config/db

2: 安装rails, 我们现在使用2.1.3版本
   rvm install 2.1.3