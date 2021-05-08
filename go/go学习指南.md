#Go文档
https://golang.org/
#Go中文文档
https://go-zh.org/

#Go指南文档(在线)
https://tour.golang.org/welcome/1
#Go中文指南文档(在线)
https://tour.go-zh.org/welcome/1
 
#mac指南文档离线安装的方法，安装前，需要先安装好go的开发环境，配置好$GOPATH路径
1.首先需要下载教程的离线包
 wget https://bitbucket.org/mikespook/go-tour-zh/get/d850789fb984.zip

2.建立工作空间的路径
  <1>.需要建立教程指定的安装路径才能编译运行;
  <2>.将下载的go-tour-zh放在$GOPATH/src/bitbucket.org/mkiespook目录下

3.编译安装
  切换到$GOPATH/src/bitbucket.org/mikespook/go-tour-zh/gotour
  编译安装命令：go install
  此时，gotour二进制程序放在了bin目录下，此时可以运行这个程序了.

4.访问教程(两种方式)
  <1>.终端输入命令: gotour ,自动跳转到浏览器打开教程链接；(注意：需要新开启终端窗口)
  <2>.在浏览器地址中输入地址：http://127.0.0.1:3999