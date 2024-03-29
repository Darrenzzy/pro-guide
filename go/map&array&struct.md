## array、map、struct

数组、字典map、结构体是golang常见的数据类型. 

具体比较性能请看：https://github.com/codingplans/person-go/blob/master/modgo/test/merge_slice_test.go

### 1. 数组

数组就是用下标为**数字**来标识的值的位置，在地址空间上，数组中的每个元素都是连续的

```go
arr1 := [3]int8{0, 1, 2}
for i := 0; i < 3; i++ {
    fmt.Println(&arr1[i])
}
```

### 2. 字典

字典就是哈希表， k=>v的结构。，只是值可以是字符或者其他类型。字典的key必须是同一个类型。不能像php一样，包含多个类型。

```go
map1 := make(map[string]string)
map1["a"] ="aaaa"
map1["b"] = "bbb"
map2 := map[string]string{"a": "a1", "b": "b1"}
```

### 3. 结构体

结构体就是和C语言结构体一样，是定义多个多个复合类型的集合。比如里面既可以又整型，也可以有字符等。

```go
type Person struct{
    age int
    name string
}

```



### 总结

map和array则是定义一组数据，他们的数据类型是相同的。而结构体定义的类型则是不相同的。

比如我们要定义一个学生的姓名的列表。这个时候，我们可以使用map或是array。因为学生的姓名基本上类型一致 都是string。但是如果我们需要定义一个学生的属性信息，一个学生有年龄，姓名，班级。这个时候，我们就需要使用结构体了。
