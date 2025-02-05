常用语句：

DQL: SELECT
DML: UPDATE/DELETE/INSERT
DDL: CREATE TABLE/VIEW/INDEX/SYN/CLUSTER
DCL: GRANT/ROLLBACK/COMMIT

查看MYSQL数据库服务器和数据库字符集
show variables like '%character%';

查看字段
show columns from user;

去重
select DISTINCT *  from user where user_id in (XXXX);

删除
delete from config where  depend_on='position';

查找重复数据
```
select id from config where `field` in 
( select `field` from config group by `field` having count(*)>1) ;

```

清空表数据
truncate table tableName restart identity ;

创建数据库
CREATE DATABASE mydatabase CHARACTER SET utf8

UPDATE Person SET FirstName = 'Fred',FirstNamev2 = 'Fred' WHERE LastName = 'Wilson'

update tableName set name=concat('前缀名称-',name);

SELECT Persons.id, Persons.LastName, Persons.FirstName, Orders.id,Orders.OrderNo,Orders.Pid
FROM Persons
INNER JOIN Orders
ON Persons.id = Orders.Pid


SELECT column-names
  FROM table-name
 WHERE column-name IN (values)

psql：
添加注释：

COMMENT ON COLUMN t_account_application.manager_union_id IS '1# mobile booking,    2# admin booking,    3# web booking, 4# tell call';

添加数据
insert into test1 (id) values (1);

添加字段
alter table `msgs` 
  add `sss2` int(11) Default 0 comment '站点 id',
  ADD `platform` SMALLINT  UNSIGNED  NOT NULL  DEFAULT 0  COMMENT '平台'
  
ALTER TABLE table ALTER COLUMN app SET NOT NULL;
ALTER TABLE table ADD mark varchar DEFAULT NULL;

修改原来字段
ALTER TABLE `monitor_data` CHANGE `plan_ids` `app_version` JSON  NULL  DEFAULT (json_array())  COMMENT '版本';

修改原来索引结构
alter table tableName add index indexName(columnName,sync_status);

删除字段
alter table play_level_god_accept drop column grab_switch5;
ALTER TABLE `monitor_data` DROP `media_ids`;

删除表
drop table tablename;

 数据库创建索引：
  create index manager_id_on_groups on groups(manager_id);

字段创建唯一索引
CREATE UNIQUE INDEX logs_id_unique ON logs(id);
CREATE UNIQUE INDEX "xxx_unique" ON public.tablename (id,name....);
考虑左前缀匹配原则，对于索引的字段要做处理


查看数据库索引
  SHOW INDEX FROM table_name
查看ddl：
  show create table table_name

 强制索引
 ....FROM search FORCE INDEX (search_time) WHERE....

 --创建聚集索引
create CLUSTERED INDEX 索引名称 ON 表名(字段名)

--创建非聚集索引
create NONCLUSTERED INDEX 索引名称 ON 表名(字段名)


 mysql like模糊查询提高效率的奇葩方法！不知道有没有人这么干过？
一张表大概40万左右的数据，用like模糊查询title字段，很慢，title字段已经建立了索引，mysql 对 someTitle% 这样的模糊查询在有索引的前提下是很快的。
所以下面这两台sql语句差别就很大了 
$sql1 = "...... title like someTitle%" (话费0.001秒)
$sql2 = "...... title like %someTitle%" (话费0.8秒)
这两句的效率相差了800倍，这很可观啊。
所以我有个想法：在不用分词的方法的前提下，把存储的title字段，加一个特别的前缀，比如"im_prefix"，比如一条记录的title="我是标题党"，那么存储的时候就存储为"im_prefix我是标题党"。


mysql 高效模糊查询 代替like  locate(substr,str)
查询效率比如果： table.field like '%AAA%' 可以改为 locate ('AAA' , table.field) > 0

索引与优化like查询

1. like %keyword    索引失效，使用全表扫描。但可以通过翻转函数+like前模糊查询+建立翻转函数索引=走翻转函数索引，不走全表扫描。
2. like keyword%    索引有效。
3. like %keyword% 索引失效，也无法使用反向索引。

### 每类前三个考虑 并列

```sql
select s1.name,s1.subject,s1.score from scores s1
left join (select distinct subject,score from scores) s2
on s1.subject=s2.subject
and s1.score<s2.score
group by s1.name,s1.subject,s1.score
having count(1)<3
order by subject,score desc;
```