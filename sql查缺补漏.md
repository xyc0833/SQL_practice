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