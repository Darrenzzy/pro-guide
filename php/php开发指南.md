php开发指南

0. 写代码的风格尽量遵循以下原则
    简单、易懂、可信赖

1.  所有url路径规则尽量遵循以下原则
  /namespace/controller/action 
  http的method尽量使用rest风格
  	post 创建和修改类
  	patch 修改
  	delete 删除类方法
  	get 获取类方法

2. 所有起名认为是大小写敏感
   文件名 驼峰命名，首字母大写如 HelloController.php
   类名 驼峰命名，首字母大写 如 class HelloController {}
   方法名 驼峰命名，首字母小写 如 function getText(){}
   类成员变量 全部消息小写，单词之间使用_连接，所有内部成员变量，必须使用_开始，
      如 $_hello_world 但是赋值和获取没有第一个下划线. 通过注释来声明类型
      class Test extends BaseModel
      {
         /**
          * 支持类型integer string decimal datetime boolean
          * @type integer
          */
         private $_hello_world;
         // 无类型转换，直接赋值
         public $text;
      }
      $test = new Test();
      $test->hello_world = "11" // 会字段转为数字11
      var_dump($test->hell_world ); // 输出的是数字11
      获取xx属性的优先顺序
      getXxx方法 > _xxx获取 
      
   表名和model类名  都是复数

   类命名尽量使用名词词性的单词
   方法应该尽量使用动词或动名词
   变量则使用与字段名一致，非字段命名变量则使用名词，计数的词只充许使用以下这几个 i, j, x, y， k, q

3. 禁止echo、print_r、var_dump 之类的函数进行调试程序，统一使用日志方式debug、info、warn  

4. 循环和判断尽量控制在3层，超过3层，要反思思路是否有问题，或者独立成一个函数

5. 在明确知道传递参数是否改变的情况下，优先使用引用传递数组，如
   $a  = array(1,3,5,7)
   $b = $a // 被拷贝了, $b被更改，不会影响到$a
   $b = &$a  //引用, 相当于别名，$b更改，会影响到$a
   function test(&$array){}// 方法是引用传递数组
   
   php5.5之后，对象传递默认都是引用传递

6. 输出json，必须统一在controller父类中进行输出，并且保证content_type 为application/json
   不要输出无效字符，导致客户端解析失败

7. 重复写的方法应该抽象出来，提高代码复用


8. 使用phpstorm进行代码格式化和语法检查，排除掉语法警告和错误，将声明但未使用的变量删除

9. model类的对象方法
   findXXXX 以find开始，标明是查找方法
   findVideos 返回的是数组
   findVideo 返回的是单个对象
   updateXXX 更新方法
   asyncXXX 异步方法  注意，异步方法的参数，不能是数组或者对象，只能是基础类型，如数字、字符串
   save 只做新增数据!!!
   update 更新数据
   delete 删除数据
   findById 通过ID查找
   findByIds 通过多个ID查找
   findBatch 批量抓取

   以下为常见的回调方法(对象方法)名称，会被自动触发
   beforeSaveEvent
   beforeUpdateEvent
   asyncAfter + Save/Update/Delete + Event
   
   注意，回调中不要出现递归回调，不允许在回调对象中，再次调用当前对象的update或者save方法

10. model中关联对象必须显式声明如
    class User extends BaseModel
    {
       public $product;// 显式声明，放在所有方法前面
       // 方法开始
       function test(){}
    }

11. 判断语句, 常量在前
   // 尽量使用常量
  if (USER_STATUS_BLOCKED == $this->user_status){}   
  if (1 == $status){}// 不要使用数字
  if (1 == $status) test(); // 应该使用{} 扩起来，即使只有一个语句

12. 编码格式应该有序，
	a. 可以统一使用一个TAB(即4个空格）为单位;
	b. 三种常见语句结构（if/while(for)/switch上下及不同程序功能处理段应保持一空行;

	如：
	  $a = 10;
	  $b = 20;

	  if ($a > $b) {
	      echo ‘no entry’;
	  } else {
	      echo ‘entry’;
	  }

	  for ($i=$a; $a < $b;) {
	  	echo $a++;
	  }

 
	c. 方法或函数的参数定义、调用、运算符与变量之间都应保持一个半角空格；除for循环结构的变量外, 如下
	
	
	function generalFullName($preName, midName, $lastName) {
	    return $preName . $midName . $lastName;
	}
	
	$my_fullname = generalFullName(‘程’, ‘序’, ‘员’);
	
	echo $my_fullname;
	

	

13. 在类定义时，公有的方法应该放置在类的方法最上部，私有方法放置在最底部，受保护的方法放置在中间；私有方法请在定义时添加‘_’前缀；如下


	class UsersController extends BaseController {
        
            private $_username;
            private $_avatar;
            private $_address;
        
            // 列表
            public function indexAction() {
                $area_code = $this->params('area_code', 0);
        
                $users = $this->_getRankUser($area_code);
            }
        
            // 新增
            public function newAction() {
        
            }
        
            // 更新
            public function updateAction() {
        
            }
        
            // 删除
            public function deleteAction() {
        
            }
        
        
            /**
             * 获取某区域权重高的用户
             * @param int $area_code
             */
            private function _getRankUser($area_code = 0) {
                // 实现略
            }
        
            ...
        }

14. 注释，全局的控制器请直接使用短注释 // xxx， 中间保持有一个空格。其它的方法使用通用来处理

15. 时间字段，一律以_at结尾

16. isBlank 替代 empty; 开发中严禁使用empty;isBlank在检测变量若是 NULL, ‘’, 数组为空 则返回真，否则为假


   
      