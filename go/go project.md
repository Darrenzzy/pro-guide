# go 项目中常遇到的事情

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

具体例子参考：TestPprofFunc
person-go/modgo/test/pprof_func_test.go 

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

