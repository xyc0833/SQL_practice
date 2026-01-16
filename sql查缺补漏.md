# sql查缺补漏

## mac中如果用homebrew安装mysql的话 无密码
**相关说明**

[具体教程](https://www.sjkjc.com/mysql/install-on-macos/)

brew install mysql

brew services start mysql

**mysql_secure_installation 这个暂时没有弄**

用客户端连接服务端
mysql -u root -p 

MacBook-Air:~ xuyaochen$ mysql -u root -p 
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 9.5.0 Homebrew

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 

- brew services start mysql: 启动 MySQL 服务器，并设置为自启动。
- brew services stop mysql: 停止 MySQL 服务器，并设置为不自启动。
- brew services run mysql: 只启动 MySQL 服务器。
- mysql.server start: 启动 MySQL 服务器。
- mysql.server stop: 停止 MySQL 服务器。


show tables;

B站 sql教程

https://zhuanlan.zhihu.com/p/222865842

## 临时表

https://www.bilibili.com/video/BV1sS4y1k74M/?spm_id_from=333.337.search-card.all.click&vd_source=4fd29620ab97a080af7ee392e19b0fcb

student 学生表 (学多, 似名, 此别.) 
选课关系表 (学号, 课程号, 成烫) 
204289
课程表 (深癣号, 洪癣名, 成须) 

当我们感觉到难的时候 其实是我们缺少中间数据

--临时表
with t1 as (
    select * from student as s,s_course as sc,course as c where s.sno = sc.sno and sc.cno = c.cno and c.name = "java基础"
),
t2 as (
    select * from student as s,s_course as sc,course as c where s.sno = sc.sno and sc.cno = c.cno and c.name = "高等数学"
)
--有了上面的临时表之后
select * from t1,t2 where t1.sno = t2.sno and t1.mark > t2.mark

**使用临时表做思路上的拆解**

## 插入

[sql的插入相关教程](sjkjc.com/mysql/insert/)

INSERT INTO `products` VALUES (2,'Pork - Bacon,back Peameal',49,4.65);

Insert:insert into 列名 值
delete: delete from 表＋条件
单表删除：where, orderby
多表删除：连接后用另一表的条件
Update:update 表 set 列名=新值

**插入单行**
INSERT into customers(
	address,
    city,
    state,
    last_name,
    first_name,
    birth_date) 
VALUES(
'5225 Figueroa Mountain Rd',
'Los Olivos',
'CA',
'Jackson',
'michael',
'1958-08-29'
)

**插入多行**

```
INSERT into shippers(name)
values('shipper1'),
	('shipper2'),
    ('shipper3');
```
练习

```
insert into products(name,quantity_in_stock,unit_price)
 values('product1',1,10),
 ('product2',2,20),
 ('product3',3,30);
```

**插入分级行**

意思就是 插入数据时 插入分层行

案例：
新增一个订单（order），里面包含两个订单项目/两种商品（order_items），请同时更新订单表和订单项目表

```sql
USE sql_store;
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-01', 1);
-- 可以先试一下用 SELECT last_insert_id() 看能否成功获取到的最新的order_id
 select last_insert_id();

INSERT INTO order_items -- 全是必须字段，就不用指定了
VALUES
(last_insert_id(), 1, 2, 2.5),
(last_insert_id(), 2, 5, 1.5)
```

## 创建表的副本

**运用 CREAT TABLE 新表名 AS 子查询 快速创建表 orders 的副本表 orders_archived**

```sql
 create table orders_archived as
	select * from orders;
```

- SELECT * FROM orders 选择了 oders 中所有数据，作为AS的内容，是一个子查询
- 子查询： 任何一个充当另一个SQL语句的一部分的 SELECT…… 查询语句都是子查询，子查询是一个很有用的技
巧。

不再 用 全 部 数 据 ， 而 选 用 原 表 中 部 分 数 据 创 建 副 本 表 ， 如 ， 用 今 年 以 前 的 orders 创 建 一 个 副 本 表
orders_archived，其实就是在子查询里增加了一个WHERE语句进行筛选。注意要先 drop 删掉 或 truncate 清
空掉之前建的 orders_archived 表再重建或重填。

```sql
drop table orders_archived;
 create table orders_archived as
	select * from orders
	where order_date<'2019-01-01';
```

delete 是删除表中的数据, 我们可以选择删除部分数据或者全部数据, delete 删除的数据
是可以回滚的, 
delete 操作并不是真的把数据删除掉了, 而是给数据打上删除标记, 目的是
为了空间复用, 所以 delete 删除表数据, 磁盘文件的大小是不会缩减的。

drop 是删除表结构和表中所有的数据, truncate 是只删除表中所有的记录, 表结构并不会
被删除, drop 和 truncate 删除的数据都是不可以回滚的, 并且删除表会立刻释放磁盘空间

从删除表的性能来看，drop（真的都删） > truncate（只删记录） > delete （不删）

**练习**


```sql
DROP TABLE invoices_archived;
CREATE TABLE invoices_archived AS
SELECT i.invoice_id, c.name AS client, i.payment_date
-- 为了简化，就选这三列
FROM invoices i
JOIN clients c
USING (client_id)
【WHERE i.payment_date IS NOT NULL】
-- 或者 i.payment_total > 0

```

USING 的基本作用

USING 用于 当两张表中存在“同名连接列”时，代替 ON table1.col = table2.col 的写法。

SELECT ...
FROM table1
JOIN table2
USING (column_name);

等价于

FROM table1
JOIN table2
ON table1.column_name = table2.column_name;


## 更新单行

UPDATE 表
【SET 要修改的字段 = 具体值/NULL/DEFAULT/列间数学表达式】 （【修改多个字段用逗号分隔】）
WHERE 行筛选

USE sql_invoicing;
UPDATE invoices
SET
payment_total = 100 / 0 / DEFAULT / NULL / 0.5 * invoice_total,
-- 【注意 0.5 * invoice_total 的结果小数被舍弃，之后讲数据类型会讲到这个问题】
payment_date = '2019-01-01' / DEFAULT / NULL / due_date
WHERE invoice_id = 3

update invoices
set 
	payment_total = 10, payment_date = '2019-01-03'
    where invoice_id = 1;

## 更新多行

**语法一样的，就是让 WHERE…… 的条件包含更多记录，就会同时更改多条记录了**

Workbench默认开启了Safe Updates功能，不允许同时更改多条记录，要先关闭该功能（在 Preference——
SQL Editor 里）

USE sql_invoicing;
UPDATE invoices
SET payment_total = 233, payment_date = due_date
WHERE client_id = 3 -- 该客户的发票记录不止一条，将同时更改
/WHERE client_id IN (3, 4) -- 第二章 4~9 讲的那些写 WHERE 条件的方式当然都可以用
-- 甚至可以直接省略 WHERE 语句，会直接更改整个表的全部记录

练习

```sql
update customers
set points = points + 50 --set中使用了表达式
where birth_date <'1990-01-01';
``` 

## 在update中 使用子查询

```sql
update customers
set points = points + 50 --set中使用了表达式
where client_id = (
    select client_id 
    from clients
    where name = 'myworks'
);
``` 

```sql
update customers
set points = points + 50 --set中使用了表达式
where client_id IN (
    select client_id 
    from clients
    where state IN ('ca','ny')
);
``` 
使用 in 关键字  ：判断字段是否属于某些值

IN …… 后除了可接 （……, ……） 也可接由子查询得到的多个数据（一列多条数据）

SELECT *
FROM employees
WHERE dept_id IN (1, 3, 5);

等价于

WHERE dept_id = 1
   OR dept_id = 3
   OR dept_id = 5;
