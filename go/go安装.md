# 安装部署常用到的

### go安装 
    下载地址：https://golang.org/dl/

### mac安装
    下载go*.darwin-amd64.pkg包， 点击安装即可，默认安装到/usr/local/go

### linux安装
    wget http...go1.*.linux-amd64.tar.gz
    tar -zxvf go1.16.linux-amd64.tar.gz
    把下载编译后的源码
    放在/usr/local/go


### 本地安装依赖x
    git clone http://github.com/golang/tools
    mkdir -p  $GOPATH/src/golang.org/x/
    cp -r tools $GOPATH/src/golang.org/x/



### tidy主要用来手动维护项目的包依赖，会检测项目当前的依赖，做相应的依赖添加或移除。
    go mod tidy

### 依照某个命令 遍历当前目录下所有包
    go [command] ./...
    如: go get -d ./... （下载所有需要依赖包）

###查看go的环境变量
    go env

### 常用 json show 组件
    brew install jq


### go rpc所需用的软件：
brew install protobuf
brew install protoc-gen-go
