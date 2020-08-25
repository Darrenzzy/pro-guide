go安装

下载地址：https://golang.org/dl/

#mac安装
 下载go1.9.2.darwin-amd64.pkg包， 点击安装即可，默认安装到/usr/local/go

#linux安装
wget https://redirector.gvt1.com/edgedl/go/go1.9.2.linux-amd64.tar.gz
tar -zxvf go1.9.2.linux-amd64.tar.gz
把下载编译后的源码
放在/usr/local/go

PATH 添加 /usr/local/go/bin
声明两个变量
GOROOT=/usr/local/go
GOPATH=/usr/local/system/go

安装依赖x
git clone http://github.com/golang/tools
mkdir -p  $GOPATH/src/golang.org/x/
cp -r tools $GOPATH/src/golang.org/x/
安装
go get github.com/tools/godep



export GO111MODULE=on
export GOPROXY=https://goproxy.cn  or https://goproxy.io

tidy主要用来手动维护项目的包依赖，会检测项目当前的依赖，做相应的依赖添加或移除。
go mod tidy

依照某个命令 遍历当前目录下所有包
go [command] ./...
如: go get -d ./... （下载所有需要依赖包）

查看go的环境变量
# go env

生产文件：
brew install jq


//go rpc所需用的软件：
brew install protobuf

brew install protoc-gen-go
