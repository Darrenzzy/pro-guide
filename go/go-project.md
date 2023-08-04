# go 项目中实在遇到的坑和解决方案

### pprof
allocs 内存分配情况的采样信息
blocks 阻塞操作情况的采样信息
cmdline 显示程序启动命令及参数
goroutine 当前所有协程的堆栈信息
heap 堆上内存使用情况的采样信息
mutex 锁争用情况的采样信息
profile CPU 占用情况的采样信息
threadcreate 系统线程创建情况的采样信息
trace 程序运行跟踪信息

flat    本函数的执行耗时
flat%   flat 占 CPU 总时间的比例。程序总耗时 16.22s, Eat 的 16.19s 占了 99.82%
sum%    前面每一行的 flat 占比总和
cum 累计量。指该函数加上该函数调用的函数总耗时
cum%    cum 占 CPU 总时间的比例

具体例子参考：TestPprofFunc
person-go/modgo/test/pprof_func_test.go 

命令例子
```
go tool pprof http://localhost:6060/debug/pprof/profile   # 30-second CPU profile
go tool pprof http://localhost:6060/debug/pprof/heap      # heap profile
go tool pprof http://localhost:6060/debug/pprof/block     # goroutine blocking profile
```

首先摘取信息
go tool pprof  http://10.5.27.226:8882/debug/pprof/profile\?seconds\=30
进入后子命令：
查看 占用top：  top 20
查看 对象列表： list new

上面30s会分析处一个压缩文件gz 用web查看
go tool pprof --http=:3000  file.gz

指定端口 web 查看堆
go tool pprof  -http :8884 http://xxxx:8882/debug/pprof/heap

查看make申请内存占用的函数
go tool pprof http://localhost:6060/debug/pprof/allocs

获取当前情况拉倒本地二进制文件：
curl -o mem.out  http://127.0.0.1:9090/debug/pprof/allocs
curl -o heap.out  http://127.0.0.1:9090/debug/pprof/heap
curl -o cpu.out  http://127.0.0.1:9090/debug/pprof/profile?seconds=10

似于 diff 的方式找到前后两个时刻多出的 goroutine，进而找到 goroutine 泄露的原因，并没有直接使用 heap 或者 goroutine 的 profile 文件

对比两个结果 查看差异 以 001 为基，看 002
go tool pprof -base pprof.demo2.alloc_objects.alloc_space.inuse_objects.inuse_space.001.pb.gz pprof.demo2.alloc_objects.alloc_space.inuse_objects.inuse_space.002.pb.gz


### fgprof  【https://github.com/felixge/fgprof 】
    主要处理的是针对CPU性能分析，Golang的On-CPU和Off-CPU的性能，可以分析到有哪些线程明显发生IO阻塞，定位到函数。

go tool pprof --http=:6061 http://localhost:6060/debug/fgprof?seconds=3


### goland 编写 proto 引用 google 时需要用到的包

```proto

import "google/protobuf/duration.proto";
import "google/protobuf/struct.proto";
import "google/protobuf/timestamp.proto";
import "google/protobuf/wrappers.proto";

```

go交叉编译命令：
Mac 下编译 Linux 和 Windows 64位可执行程序
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build main.go -o ~/..(path)
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build main.go -o ~/..(path)

Linux 下编译 Mac 和 Windows 64位可执行程序
CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build main.go -o ~/..(path)
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build main.go -o ~/..(path)

GOOS：目标平台的操作系统（darwin、freebsd、linux、windows）
GOARCH：目标平台的体系架构（386、amd64、arm）
交叉编译不支持 CGO 所以要禁用它


go 初始化消息时候，记录日志信息
func logs()  {
	f, err := os.OpenFile("logfile.log", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("file open error : %v", err)
	}
	defer f.Close()
	log.SetOutput(f)
	//log.Println("This is a Darren test log entry"+time.Now().Format("2006/01/02 15:04:05"))
	log.Println("This is a Darren test log entry")

}


go  倒计时：
func (dao *Dao) GrabOrderLoop(user int64, exit chan struct{}) {
    ticker := time.NewTicker(time.Second)
    defer ticker.Stop()
    counts := 65
GL:
    for {
        select {
        case <-ticker.C:
            if counts < 0 {

            }
            counts--
        case <-exit:
            break GL
        }
    }
}

一个简单的 log 包

type log struct{}

func (log) Print(v ...interface{}) {
    s := []interface{}{"[sarama] "}
    glog.InfoDepth(1, append(s, v...))
}

func (log) Printf(format string, v ...interface{}) {
    glog.InfoDepth(1, fmt.Sprintf("[sarama] "+format, v...))
}

func (log) Println(v ...interface{}) {
    glog.InfoDepth(1, "[sarama] "+fmt.Sprintln(v...))
}


// 一个简单的 异常捕获
func NoPanic(fn func()) (err error) {
    defer func() {
        if e := recover(); e != nil {
            err = errors.New(e)
            stack := make([]byte, 4<<10)
            length := runtime.Stack(stack, false)
            glog.Errorf("[PANIC RECOVER] %v %s\n", e, stack[:length])
        }
    }()
    fn()
    return
}


单元测试其中一个 func：
go test go_test.go -v -run="TestFirst"

生成test二进制文件
go test -c

运行test二进制文件
go test -v -o leetcode.test


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

