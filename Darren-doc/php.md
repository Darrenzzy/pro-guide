
# php 内部函数日常总结
7.24
查看配置文件路径
php --ini

截取字符串 substr('string',0,1);
 

判断字符串位置存在与否
strstr('string','key') 返回关键字以后的字符串

if(strpos($img,'1')!==false)  返回真(含有) 假 （不含有）
 

```php


# 3.28
/**
 * 二维数组根据某个字段排序
 * @param array $array 要排序的数组
 * @param string $keys   要排序的键字段
 * @param string $sort  排序类型  SORT_ASC     SORT_DESC 
 * @return array 排序后的数组
 */
 function arraySort($array, $keys, $sort = SORT_DESC) {
        $keysValue = [];
        foreach ($array as $k => $v) {
            $keysValue[$k] = $v[$keys];
        }
        array_multisort($keysValue, $sort, $array);
        return $array;
    }  

function curlGet($url, $user_agent = "")
{
    //初始化
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_USERAGENT, $user_agent);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    //执行并获取HTML文档内容
    $output = curl_exec($ch);
    curl_close($ch);
    return $output;
}

function curlPost($url, $post)
{
    //初始化
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url); // 要访问的地址
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); // 获取的信息以文件流的形式返回
    curl_setopt($ch, CURLOPT_HEADER, 0); // 显示返回的Header区域内容
    curl_setopt($ch, CURLOPT_POST, 1); // 发送一个常规的Post请求
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post); // Post提交的数据包
    curl_setopt($ch, CURLOPT_TIMEOUT, 30); // 设置超时限制防止死循环
    //执行并获取HTML文档内容
    $output = curl_exec($ch);
    curl_close($ch);
    return $output;
}


```


php合并数组方式 
1：array_merge();  合并后不保留健值，
2 $arr + $arr1  保留键值 若健值重复则优先取前面的


2.28
去掉空格
$sort = trim($sort);


1.10
数组去空、去重处理
array_unique(array_filter())

合并数组 去空去重，
implode(',', array_unique(array_filter(array_merge($user_ids, $add_user_ids))));

1.7
防止sql注入的PHP函数：
addslashes（）
stripslashes（）

12.13
php字符串比较忽略大小写进行比较：
  strcasecmp()
这是不忽略大小写：strcmp（）

php时间戳转换
 strval(date('m-d H:i', time()));

 php 检查目录和检查文件是否存在 创建目录
 is_dir($dir)
 file_exists($file);
 mkdir($dir,0777,true);
          
 

11.28
PHP posix_getpid 取得当前服务器进程号

9.11
   
php获取当前目录  执行命令目录
    getcwd();
php执行shell命令 最后一行
  exec($pwd);
打印全部行
shell_exec("") 

取前一天的0点整点时间戳
 strtotime(date('Y-m-d',strtotime('-1 day')))


8.8
 
获取当前类的名称，可以在调用当前类中的静态方法
get_called_class()


7月13日
把“Hello”的首字符转换为小写。：
echo lcfirst("Hello world!");

