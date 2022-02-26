

### 位运算使用：
```
3>>2  表示 3除以 2 的 2 次方
3<<2  表示 3乘以 2 的 2 次方
^3 表示按位取反 结果永远是这个数+1的相反数 ： -4  ^5==-6

&	与	两个位都为1时，结果才为1
|	或	两个位都为0时，结果才为0
^	异或	两个位相同为0，相异为1
~	取反	0变1，1变0
```
### go test 常用项：
```
性能压测：
go test -v filename_test.go -bench=. -benchtime 5s -benchmem -cpu=1   -run=none -cpuprofile=cpu.profile
-v 显示跑了那些 case
file_test.go 指定文件
参数说明： 
-benchtime 默认是 1 秒内， 可指定时间范围内。
-benchmem 显示每次 op 分配内存次数
-bench   
=. ：全部压测 case
="funcName" ：测试压测名称为funcName的方法自动模糊匹配后面的字符串。 例如（func Benchmark_sliceOnce()）

-run=none 表示只测试 bench 相关 case ，其他忽略
-cpu=1 表示用几个核数



压侧结果 -8 表示当前机器使用GOMAXPROCS
```
### 逃逸
```
1  临时变量 的指针返回给外部调用
2  初始化变量过大 make99999len
3  interface作为形参接收 到的变量都会逃逸
4  闭包
逃逸分析：
go test -gcflags '-m -l'  -v -run TestPractice
go build -gcflags '-m -l' main.go
```


### 随机数：
    rnd := rand.New(rand.NewSource(time.Now().UnixNano()))
    println(rnd.Int31n(1000000))

### ascii 码：
```
var c rune = 'a'
var i int = 98

'a'=97 'z'=122 'A'=65  'Z'=90 '0'=48 '9'=57

```
### golang字符串：
```
strArrayOld:=[]string{"aa","bb"}
//implode
strTotal:=strings.Join(strArrayOld,"-")

//explode
strArrayNew:=strings.Split(strTotal,"-")

字符串截取
str := "XHelloWorldX"
content := str[1 : l˜˜en(str)-1]
fmt.Println(content)


string转float64
s := "3.1415926535"
f, _ := strconv.ParseFloat(s, 8)
fmt.Printf("%T, %v\n", f, f)

float to string
 1:fmt.Sprintf("%g", v.MaxLimit),
 2:strconv.FormatFloat(v.DealAmount, 'g', -1, 64)

float to float
value, _ = strconv.ParseFloat(fmt.Sprintf("%.2f", value), 64)

string转成int：
int, err := strconv.Atoi(string)
string转成int64：
int64, err := strconv.ParseInt(string, 10, 64)
int转成string：
string := strconv.Itoa(int)
int64转成string：
string := strconv.FormatInt(int64,10)
uint64转成string：
string := strconv.FormatUint(uint64, 10)
```
### 进制转换：

    var v int64 = 425217101 //默认10进制
	s2 := strconv.FormatInt(v, 2) //10 yo 16
	fmt.Printf("%v\n", s2)

	s8 := strconv.FormatInt(v, 8)
	fmt.Printf("%v\n", s8)

	s10 := strconv.FormatInt(v, 10)
	fmt.Printf("%v\n", s10)

	s16 := strconv.FormatInt(v, 16) //10 yo 16
	fmt.Printf("%v\n", s16)

	var sv = "19584c4d"; // 16 to 10
	fmt.Println(strconv.ParseInt(sv, 16, 32))

### 字符串替换：

    strings.Replace(strings.Trim(fmt.Sprint(users), "[]"), " ", ",", -1),



### 修改字符串：
```
func main() {
    x := "text"
    xRunes := []rune(x)
    xRunes[0] = '我'
    x = string(xRunes)
    fmt.Println(x)  // 我ext
}
```

### golang判断key是否在map中.  
    make(map[int64]int, 0)
    if _, ok := map[key]; ok {
    //存在
    }

### 随机打乱切片数组：
```
func Shuffle(slice []gs_gobang.History) []gs_gobang.History {
    r := rand.New(rand.NewSource(time.Now().Unix()))
    for len(slice) > 0 {
        n := len(slice)
        randIndex := r.Intn(n)
        slice[n-1], slice[randIndex] = slice[randIndex], slice[n-1]
        slice = slice[:n-1]
    }
    return slice
}
```
### 各种时间处理
```
// 日期转字符串
func FormatDatetime(t time.Time) string {
    return t.Format(time.RFC3339)
}
func FormatDatetimeV2(t time.Time) string {
    return t.Format("2006-01-02 15:04:05")
}

// 浮点型精度处理
func Round(f float64, n int, roundDown bool) float64 {
    s := math.Pow10(n)
    if roundDown {
        return math.Floor(f*s) / s
    } else {
        return math.Ceil(f*s) / s
    }
}
1) 时间戳转时间字符串 (int64 —>  string)
        timeUnix:=time.Now().Unix()   //已知的时间戳

        formatTimeStr:=time.Unix(timeUnix,0).Format("2006-01-02 15:04:05")

        fmt.Println(formatTimeStr)   //打印结果：2017-04-11 13:30:39
   2) 时间字符串转时间(string  —>  Time)

      formatTimeStr=”2017-04-11 13:33:37”

      formatTime,err:=time.Parse("2006-01-02 15:04:05",formatTimeStr)

     if err==nil{

         fmt.Println(formatTime) //打印结果：2017-04-11 13:33:37 +0000 UTC

      }
   3) 时间字符串转时间戳 (string —>  int64)

          比上面多一步，formatTime.Unix()即可

// 一天前
    d, _ := time.ParseDuration("-24h")
    oldTime := currentTime.AddDate(0, 0, -2)        //若要获取3天前的时间，则应将-2改为-3
```

### 字符串转换：

```
1、func Title(s string) string
将字符串s每个单词首字母大写返回
2、func ToLower(s string) string
将字符串s转换成小写返回
3、func ToLowerSpecial(_case unicode.SpecialCase, s string) string
将字符串s中所有字符按_case指定的映射转换成小写返回
4、func ToTitle(s string) string
将字符串s转换成大写返回
5、func ToTitleSpecial(_case unicode.SpecialCase, s string) string
将字符串s中所有字符按_case指定的映射转换成大写返回
6、func ToUpper(s string) string
将字符串s转换成大写返回
7、func ToUpperSpecial(_case unicode.SpecialCase, s string) string
将字符串s中所有字符按_case指定的映射转换成大写返回
```

```
channl的发送和接收
data := <- a // read from channel a
a <- data // write to channel a

内建函数：两个的区别
var p *[]int = new([]int)      初始化一个指针
var v []int = make([]int, 10)  初始化一个数据结构以及值
```


### 常用打印方法：
```
打印格式：
    icelog.Infof("test 用户道具编号：%v", game.Prop)
%v  值的默认格式。当打印结构体时，“加号”标记（%+v）会添加字段名
%#v　相应值的Go语法表示
%T  相应值的类型的Go语法表示
%%  字面上的百分号，并非值的占位符　
s := new(Sample)
    s.a = 1
    s.str = "hello"
    fmt.Printf("%v\n", *s)　//{1 hello}
    fmt.Printf("%+v\n", *s) //  {a:1 str:hello}
    fmt.Printf("%#v\n", *s) // main.Sample{a:1, str:"hello"}
    fmt.Printf("%T\n", *s)   //  main.Sample
    fmt.Printf("%%\n", s.a) //  %  %!(EXTRA int=1)

//Go 为常规 Go 值的格式化设计提供了多种打印方式。例如，这里打印了 point 结构体的一个实例。
p := point{1, 2}
fmt.Printf("%v\n", p) // {1 2}
//如果值是一个结构体，%+v 的格式化输出内容将包括结构体的字段名。
fmt.Printf("%+v\n", p) // {x:1 y:2}
//%#v 形式则输出这个值的 Go 语法表示。例如，值的运行源代码片段。
fmt.Printf("%#v\n", p) // main.point{x:1, y:2}
//需要打印值的类型，使用 %T。
fmt.Printf("%T\n", p) // main.point
//格式化布尔值是简单的。
fmt.Printf("%t\n", true)
//格式化整形数有多种方式，使用 %d进行标准的十进制格式化。
fmt.Printf("%d\n", 123)
//这个输出二进制表示形式。
fmt.Printf("%b\n", 14)
//这个输出给定整数的对应字符。
fmt.Printf("%c\n", 33)
//%x 提供十六进制编码。
fmt.Printf("%x\n", 456)
//对于浮点型同样有很多的格式化选项。使用 %f 进行最基本的十进制格式化。
fmt.Printf("%f\n", 78.9)
//%e 和 %E 将浮点型格式化为（稍微有一点不同的）科学技科学记数法表示形式。
fmt.Printf("%e\n", 123400000.0)
fmt.Printf("%E\n", 123400000.0)
//使用 %s 进行基本的字符串输出。
fmt.Printf("%s\n", "\"string\"")
//像 Go 源代码中那样带有双引号的输出，使用 %q。
fmt.Printf("%q\n", "\"string\"")
//和上面的整形数一样，%x 输出使用 base-16 编码的字符串，每个字节使用 2 个字符表示。
fmt.Printf("%x\n", "hex this")
//要输出一个指针的值，使用 %p。
fmt.Printf("%p\n", &p)
//当输出数字的时候，你将经常想要控制输出结果的宽度和精度，可以使用在 % 后面使用数字来控制输出宽度。默认结果使用右对齐并且通过空格来填充空白部分。
fmt.Printf("|%6d|%6d|\n", 12, 345)
//你也可以指定浮点型的输出宽度，同时也可以通过 宽度.精度 的语法来指定输出的精度。
fmt.Printf("|%6.2f|%6.2f|\n", 1.2, 3.45)
//要最对齐，使用 - 标志。
fmt.Printf("|%-6.2f|%-6.2f|\n", 1.2, 3.45)
//你也许也想控制字符串输出时的宽度，特别是要确保他们在类表格输出时的对齐。这是基本的右对齐宽度表示。
fmt.Printf("|%6s|%6s|\n", "foo", "b")
//要左对齐，和数字一样，使用 - 标志。
fmt.Printf("|%-6s|%-6s|\n", "foo", "b")
//到目前为止，我们已经看过 Printf了，它通过 os.Stdout输出格式化的字符串。Sprintf 则格式化并返回一个字符串而不带任何输出。
s := fmt.Sprintf("a %s", "string")
fmt.Println(s)
//你可以使用 Fprintf 来格式化并输出到 io.Writers而不是 os.Stdout。
fmt.Fprintf(os.Stderr, "an %s\n", "error")
```

### redis 玩法
```
redis 整型自增
  bs, err := redis.Int64(redisAuth.Do("INCRBY", keyA))

redis
redisConn.Do("SET", key, 1, "EX", 60, "NX")

```