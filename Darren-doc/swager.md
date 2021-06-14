swager 使用

```bash
 # 安装前置条件包：
  go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
  go get -u github.com/golang/protobuf/protoc-gen-go@v1.4.0
 # 之后可以执行：
protoc -I/usr/local/include  -I.  --swagger_out=logtostderr=true:../docs --go_out=plugins=grpc,paths=./pb  *.proto

```

快速生产：

1.首先在开发代码中写格式正确的 swager 代码

2.swager 生产 json 代码

此处需要拉去 swag 包 （https://github.com/swaggo/swag）

go get -u github.com/swaggo/swag/cmd/swag

3 在开发代码根路径执行命令： swag init

4 生成 json 文件在 docs 内 需要命令移动到 swager 项目下，

5 打开 swager 项目 发布代码：

cd /Users/darren/go/src/testgo/modgo/swag

./deploy.sh swag linux dev

6 若需要本地执行，局域网显示则直接：

./local_run.sh [项目目录名称]


7 去查看生成后的 api 文档地址：https://swag.darrenzzy.cn/swagger/index.html