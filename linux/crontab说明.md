Linux crontab 计划任务可以很方便的将一些任务放到计划任务里，当到达某一时刻进行，如定时备份mysql数据库目录。

####格式 每一行代表一个任务。

####minute hour day month week command


```
minite 表示0-59的整数
hour 表示0-23的整数
day 表示1-31的整数（必须和制定月份一起）
month 表示1-12的整数月份
week 表示0-7的整数，星期数
command 表示需要执行的命令


```

* *号表示 所有可能的值。比如在hour为×的时候，表示每个小时都执行。

* ,逗号 表示一个制定的列表范围。 例如hour可以制定为1,3,5,7,9 当在1点/3点/7点/9点运行。
* -中杠 可以用整数之间的表示一个证书的范围。比如1-3 等价于1,2,3
* / 正斜线 可以表示指定时间之间的频率。 比如0-23/2 在hour上时 表示每隔两个小时执行一次
* ×/10 表示每隔十分钟运行一次



例子解释


```

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
#分    时   天     月    week

5       *       *           *     *     ls 表示每小时的第五分钟执行一下ls。

30     5       *           *     *     ls  表示每天的5：30执行一次ls

*/3,*/5 * * * *  ls  表示每隔5小时或者每三分钟执行一次
crontab 命令介绍
crontab -e 编辑任务
crontab -r 删除任务
crontab -l 查看任务列表    crontab -r 删除任务
crontab -l 查看任务列表
```