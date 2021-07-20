# 项目中实在遇到的坑和解决方案


### 7.7 结构体 json 表示

```golang
    type Some struct {
        CreatedAt time.Time `sql:"created" json:"created,omitempty"`
    }
```
* omitempty 表示该字段在序列化和反序列化时不是强一致显示，当变量中该字段为空|默认，则序列化成 json后，没有该字段。

### cmd收不到排查问题：
tail -f /mnt/logs/lemon.00.log
发现 消息都失败了
于是重启这个lemon服务即可
每个im消息的情况： tail -f /alidata/logs/warden.00.log

内网请求 没有定义直接form表单
gameInfo, err := gamepb.Info(frame.TODO(), nil, frame.Form(map[string]string{
        "game_id": fmt.Sprint(req.GetGameId()),
    }))

记录一次编译失败问题：  由于proto里定义了一个接口，可是代码里没有实现该接口，所以编译时候出现问题。
1 errors occurred:
--> linux/amd64 error: exit status 2
Stderr: # plorder
./main.go:37:33: cannot use s (type *api.PLOrder) as type plorderpb.PLOrderServer in argument to plorderpb.RegisterPLOrderServer:
    *api.PLOrder does not implement plorderpb.PLOrderServer (missing OrderCoupon method)


gorm数据操作

DATE_FORMAT( `create_time`, '%Y%m%d') < '20190701'  是把2019-08-20 17:40:14 转换过去的

DATE_FORMAT(from_unixtime( `create_time` ), '%Y%m%d') < '20190701'")  是把 1566340543转换过去的

deploy发布脚本
#/bin/sh
date
gox -os="linux" -arch="amd64" -output="./game-server_linux_amd64"
ssh land@172.16.164.248 "rm -f /home/land/beast/bin/game-server_linux_amd64"
scp game-server_linux_amd64 land@172.16.164.248:~/beast/bin
ssh land@172.16.164.248 "supervisorctl restart game-server:"

supervisorctl 本身的配置
/home/land/etc/conf.d
supervisorctl 中项目的配置文件目录：
/home/land/beast/conf.d
重启 需要先切到home目录下
supervisorctl update

在服务下调用db数据库 ，需要生产sql客户端，
一般跨服务调用，建议用RPC内部接口方式调用

查看当前服务所用分支
./beast/bin/plorder_linux_amd64 -h
./beast/bin/plorder_linux_amd64 -v

项目发布 到测试环境
./deploy.sh purse linux ddt_qa >> ~/tmp 2>&1 &

./deploy.sh godgame linux qa
staging 环境
./deploy.sh live linux stag

日志位置：
tailf /alidata/logs/live.00.log

配置位置
/home/land/beast/conf.d/godgame.json

 框架内自己的 protoc3 找不到位置：
 解决： 去除系统目录bin下的，
 应该在/Users/darren/go/src/vendor/iceberg/frame/protoc-gen-go下
 运行 go build
 生成可执行文件后 mv到 ~/go/bin
 查看which protoc-gen-go
 若在系统目录/usr/local/bin下 则进去删掉或改名字
 在查看，即可解决

写api 服务位置
/Users/darren/go/src/vendor/laoyuegou.pb/godgame/pb/services.proto
