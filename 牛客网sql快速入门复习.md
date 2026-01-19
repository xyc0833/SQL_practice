# 复习 

## 重新过一遍 牛客网的sql快速入门

group by可以去重？

在 SQL 里，GROUP BY 本身就具有“去重”的效果，不过它是按分组字段去重，而不是对整行随意去重

```sql
SELECT department
FROM employee
GROUP BY department;
```

等价于

```sql
select distinct department
from employee;
```

```sql
select
device_id,gender,age,university
from user_profile
where university not in ('复旦大学');
```

# like运算符

**模糊查找，查找具有某种模式的字符串的记录/行**

引号内描述想要的字符串模式，注意SQL任何情况都是不区分大小写的
- % 任何个数（包括0个）的字符（类似通配符里的 *）
- _ 单个字符（类似通配符里的 ?）

```sql
select *
from user_profile
where university like '%北京__'
```

# 数值函数相关

```sql
SELECT ROUND(5.7365, 2) -- 四舍五入
SELECT TRUNCATE(5.7365, 2) -- 截断
SELECT CEILING(5.2) -- 天花板函数，大于等于此数的最小整数
SELECT FLOOR(5.6) -- 地板函数，小于等于此数的最大整数
SELECT ABS(-5.2) -- 绝对值
SELECT RAND() -- 随机函数，0到1的随机值
```
```sql
select 
round(max(gpa),10)
from
user_profile
```

如果我想取gpa最高的那一行 应该怎么取

**老老实实用子查询**


WHERE 是在 分组和聚合之前执行
聚合函数只能出现在：
SELECT
HAVING
子查询

```sql
select
    *
from
    user_profile
where
    gpa = (
        select
            max(gpa)
        from
            user_profile
    );
```

# count函数 和 if函数组合

根据是否满足条件返回不同的值:
IF(条件表达式, 返回值1, 返回值2) 返回值可以是任何东西，数值、文本、日期时间、空值null均可


SELECT
    COUNT(IF(gender = 'male', 1, NULL))
FROM user_profile;

- IF(gender = 'male', 1, NULL)
- COUNT(expr) 只统计非 NULL 的值
- 男性 → 返回 1 → 被统计
- 非男性 → 返回 NULL → 不统计

# 聚合函数

输入一系列值并聚合为一个结果的函数

```sql
SELECT
MAX(invoice_date) AS latest_date,
-- SELECT选择的不仅可以是列，也可以是数字、列间表达式、列的聚合函数
MIN(invoice_total) lowest,
AVG(invoice_total) average,
SUM(invoice_total * 1.1) total,
COUNT(*) total_records,
COUNT(invoice_total) number_of_invoices,
-- 和上一个相等
COUNT(payment_date) number_of_payments,
-- 聚合函数会忽略空值，支付数少于发票数
【COUNT(DISTINCT client_id) number_of_distinct_clients】
-- DISTINCT client_id筛掉了该列的重复值，再COUNT计数，不同顾客数
FROM invoices
WHERE invoice_date > '2019-07-01' -- 想只统计下半年的结果
```

**你在用聚合函数 COUNT()，但又想把“每一行的全部字段”一起查出来**

这是 SQL 的硬性规则：

只要 SELECT 里出现聚合函数，
那么：

- 要么所有字段都要参与聚合

- 要么必须出现在 GROUP BY 中

而：

* 代表 每一行的所有列

COUNT() 是 把多行压缩成一行

👉 这两件事在逻辑上是冲突的。



合法的写法：

SELECT
    gender,
    COUNT(*) AS cnt
FROM user_profile
GROUP BY gender;


1️⃣COUNT(*) —— 数“行数”

不关心某一列是否为 NULL

只要这一行存在，就 +1

2️⃣ COUNT(gender) —— 数“gender 不为 NULL 的行”

如果某一行 gender IS NULL

这一行 不会被统计


## group by子句的理解 还不到位

> SELECT 里出现的非聚合字段，
> 必须出现在 GROUP BY 中（或能被唯一确定）

![alt text](image.png)

```sql
select 
   university,
   device_id,
    count(*)
from user_profile
group by university,device_id
```

**SELECT 里出现的非聚合字段，**
**必须出现在 GROUP BY 中（或能被唯一确定）**

```sql
select
gender,
university,
count(device_id) as user_num,
avg(active_days_within_30) as avg_active_day,
avg(question_cnt) as avg_question_cnt
from user_profile
group by gender,university
order by gender,university
```


## 临时表的训练

临时表内部不能写分号

内部写了分号会报错

程序异常退出, 请检查代码"是否有数组越界等异常"或者"是否有语法错误"
SQL_ERROR_INFO: "You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ';\n)\nselect * from t1 where avg_question_cnt<5 or avg_answer_cnt<20' at line 9"

```sql
with t1 as (
select
    university,
    avg(question_cnt) as avg_question_cnt,
    avg(answer_cnt) as avg_answer_cnt
from
    user_profile
group by
    university
)
select * from t1 where  avg_question_cnt<5 or  avg_answer_cnt<20;

```
等价于

```sql
select
university,
avg(question_cnt) as avg_question_cnt,
avg(answer_cnt) as  avg_answer_cnt
from user_profile
group by 1
having  avg_question_cnt < 5 or avg_answer_cnt < 20
```

## having 子句
 HAVING …… 对 SELECT …… 查询后（通常是分组并聚合查询后）的结果列进行 事后筛选

 - WHERE 是对 FROM JOIN 里原表中的列进行 事前筛选



using 的复习 
21题
```sql
-- 先取出浙江大学学生的数据

select a.device_id, b.question_id,b.result
from user_profile as a
left join question_practice_detail as b
using(device_id)
where university = '浙江大学'
order by b.question_id
```


```sql
-- 还是想着构建临时表
--先拿到每个学校的总答题数。和 总用户数
with
    t1 as (
        select
            university,
            count(question_id) as total_question,
            count(DISTINCT question_practice_detail.device_id) as user_num
        from
            user_profile
            left join question_practice_detail using (device_id)
        group by
            university
    )
select university, round(total_question/user_num,4)  as avg_answer_cnt
from t1;
```


出现问题
程序异常退出, 请检查代码"是否有数组越界等异常"或者"是否有语法错误"
SQL_ERROR_INFO: "Duplicate column name 'id'"

错误代码
```sql
with
    t1 as (
        select
            *
        from
            question_practice_detail as a
            left join user_profile as b using (device_id)
            left join question_detail as c using (question_id)
    )
select  
b.university,
c.difficult_level,
count(a.question_id)/count(a.device_id)
from t1
group by b.university,c.difficult_level;

-- 先构建一张基础表

```

一、结论先行（一句话版）

👉 错误出在 t1 里用了 select *，而三张表中都包含名为 id 的列
👉 MySQL 在构建 CTE t1 时，发现 结果集中出现了多个 id 列
👉 直接报错：Duplicate column name 'id'

23题复习
```sql
with
    t1 as (
        select
            university,difficult_level,
            a.question_id as question_id,
            a.device_id as  device_id
        from
            question_practice_detail as a
            left join user_profile using (device_id)
            left join question_detail using (question_id)
    )
select  
university,
difficult_level,
count(question_id)/count(distinct device_id)
from t1
group by university,difficult_level;

-- 先构建一张基础表

```

//25

## union关键字

union会去重

union all 不会去重

FROM …… JOIN …… 可对多张表进行横向列合并，而 …… UNION …… 可用来按行纵向合并多个查询结果，这些查询结果
可能来自相同或不同的表
同一张表可通过UNION添加新的分类字段，即先通过分类查询并添加新的分类字段再UNION合并为带分类字段
的新表。
不同表通过UNION合并的情况如：将一张18年的订单表和19年的订单表纵向合并起来在一张表里展示

合并的查询结果必须列数相等，否则会报错
合并表里的列名由排在UNION前面的决定

感觉本质上可以将查询语句的任何一步和任何一个层次，包括（按实际执行顺序排列）：
1. 选取表 FROM ……
2. 横向连接合并 …… JOIN ……
3. 纵向筛选 WHERE ……
4. 横向筛选 SELECT ……
5. 纵向连接合并 …… UNION ……
6. 排序、限制，ORDER BY …… LIMIT ……
本质上都可以看作暂时生成了一张新表（储存在内存中的虚拟表，中间过程表，桥梁表），将后续步骤都看作是在
对这些新表进行进一步的操作，这样，层次步骤就能理清，就好理解了，也才真的能从本质上掌握并灵活运用

```sql
select 
device_id,gender,age,gpa
from
user_profile
where university = '山东大学' 
union all
select 
device_id,gender,age,gpa
from
user_profile
where gender = 'male'
```

//26
```sql
select
if(age<25 or age is null,'25岁以下', '25岁及以上'),
count(id)
from user_profile
group by 1
```

## sql 删除语句

delete from invoices
where invoice_id = 19;


## 函数相关
- 格式化日期和时间
- IFNULL 和 COALESE函数

有一些内容已经在 牛客网 sql快速入门2 里面 
有些在之前刷题的时候用到过不展开了

### 格式化日期和时间

```sql
select date_format(now(),'%Y');
SELECT DATE_FORMAT(NOW(), '%M %d, %Y') -- September 12, 2020
-- 【格式说明符里，大小写是不同的，这是目前SQL里第一次出现大小写不同的情况】
SELECT TIME_FORMAT(NOW(), '%H:%i %p') -- 11:07 AM
```

日期事件格式化函数应该只是转换日期时间对象的显示格式（另外始终铭记日期时间本质是数值）

格式说明符里，大小写代表不同的格式，这是目前SQL里第一次出现大小写不同的情况

方法
很多像这种完全不需要记也不可能记得完，重要的是知道有这么个可以实现这个功能的函数，具体的格式说明符
（Specifiers）可以需要的时候去查，至少有两种方法： 
1. 直接谷歌关键词 如 mysql date format functions, 其实是在官方文档的 12.7 Date and Time Functions 小结
里，有两个函数的说明和specifiers表 
2. 用软件里的帮助功能，如workbench里的HELP INDEX打开官方文档查询或者右侧栏的 automatic comtext
help (其是也是查官方文档，不过是自动的)

### ifnull 和 COALESE 函数

两个用来替换空值的函数：IFNULL, COALESCE. 
IFNULL : 前者用来返回两个值中的首个非空值，用来替换空值
COALESCE : 后者用来返回一系列值中的首个非空值，用法更灵活

将orders里shipper.id中的空值替换为'Not Assigned'（未分配）

```sql
SELECT
order_id,
IFNULL(shipper_id, 'Not Assigned') AS shipper
-- If expr1 is not NULL, IFNULL() returns expr1; otherwise it returns expr2.
FROM orders
```

COALESE 的用法

将orders里shipper.id中的空值先替换comments，若comments也为空再替换为'Not Assigned'（未分配）

```sql
SELECT
order_id,
COALESCE(shipper_id, comments, 'Not Assigned') AS shipper
-- Returns the first non-NULL value in the list, or NULL if there are no non-NULLvalues.
FROM orders
```

COALESCE 函数是返回一系列值中的首个非空值，更灵活


## 视图

就是创建虚拟表，自动化一些重复性的查询模块，简化各种复杂操作（包括复杂的子查询和连接等）

注意视图虽然可以像一张表一样进行各种操作，但并没有真正储存数据，数据仍然储存在原始表中，视图只是储存
起来的模块化的查询结果（会随着原表数据的改变而改变），是为了方便和简化后续进一步操作而储存起来的虚拟
表。

```sql
use sql_invoicing;
create view sales_by_client as 
SELECT
client_id,
name,
SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING(client_id)
GROUP BY client_id, name;
-- 【虽然实际上这里GROUP BY加不加上name都一样，但一般把选择子句中出现的所有非聚合列都加入到分类
-- 依据中比较好，在有些DBMS里不这样做会报错】sales_by_clientsales_by_clientsales_by_clientsales_by_client
```

若要删掉该视图用 【DROP VIEW sales_by_client】 或右键
创建视图后可就当作sql_invoicing库下一张表一样进行各种操作

```sql
USE sql_invoicing;
SELECT
s.name,
s.total_sales,
phone
FROM sales_by_client s
JOIN clients c USING(client_id)
WHERE s.total_sales > 500
```

### 更新或删除视图

修改视图可以先 DROP 再 CREATE，但最好是用 CREATE OR REPLACE
视图的查询语句可以在该视图的设计模式（点击扳手图标）下查看和修改，但最好是保存为sql文件并放在源码控
制妥善管理

CREATE OR REPLACE VIEW clients_balance AS
……
ORDER BY balance DESC

如何保存视图的原始查询语句？
法1.
（推荐方法） 将原始查询语句保存为与视图名同名的 clients_balance.sql 文件并放在 views 文件夹下，然后将
这个文件夹放在源码控制下（put these files under source control）, 通常放在git repository（仓库）里与
其它人共享，团队其他人因此能在自己的电脑上重建这个数据库

法2.
若丢失了原始查询语句，要修改的话可点击视图的扳手按钮打开设计模式，可看到如下被MySQL处理了的查询语
句
MySQL在前面加了些用户主机名之类的东西并且在所有库名表名字段名外套上反引号防止名称冲突（当对象名和
MySQL里的关键字相同时确保被当作对象名而不是关键字），但这都不影响
直接做我们需要的修改，如加上ORDER BY balance DESC 然后点apply就行了

```sql
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `sales_by_client` AS
    SELECT 
        `c`.`client_id` AS `client_id`,
        `c`.`name` AS `name`,
        SUM(`i`.`invoice_total`) AS `total_sales`
    FROM
        (`clients` `c`
        JOIN `invoices` `i` ON ((`c`.`client_id` = `i`.`client_id`)))
    GROUP BY `c`.`client_id` , `c`.`name`
    ORDER BY `total_sales` DESC
```

### 可更新视图

如果一个视图的原始查询语句中没有如下元素： 
1. GROUP BY 分组、聚合函数、HAVING 分组聚合后筛选 (即分组聚合筛选三兄弟) 
2. DISTINCT 去重
3. UNION 纵向合并
则该视图是可更新视图（Updatable Views），可以用在 INSERT DELETE UPDATE 语句中进行增删改，否则只能
用在 SELECT 语句中进行查询。（1好理解，2和3需要记一下）
另外，增（INSERT）还要满足附加条件：视图必须包含底层原表的所有必须字段（也很好理解）
总之，一般通过原表修改数据，但当出于安全考虑或其他原因没有某表的直接权限时，可以通过视图来修改数据，
前提是视图是可更新的。

创建视图（新虚拟表）invoices_with_balance（带差额的发票记录表）
```sql
USE sql_invoicing;
CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
/*这里有个小技巧，要插入表中的多列列名时，
可从左侧栏中【连选并拖入】相关列
*/
invoice_id,
number,
client_id,
invoice_total,
payment_total,
invoice_date,
invoice_total - payment_total AS balance,
-- 新增列
due_date,
payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0
/*
这里不能用列别名balance，会报错说不存在，
必须用原列名的表达式
之前从执行顺序解释过
*/
```

该视图满足条件，是可更新视图，故可以增删改：
1. 删：
删掉id为1的发票记录
DELETE FROM invoices_with_balance
WHERE invoice_id = 1

2. 改：
将2号发票记录的期限延后两天

UPDATE invoices_with_balance
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2

3. 增：
在视图中用 INSERT 新增记录的话还有另一个前提，即视图必须包含其底层所有原始表的所有必须字段（这很好
理解）
例如，若这个invoices_with_balance视图里没有invoice_date字段（invoices中的必须字段），那就无法通过该
视图向invoices表新增记录，因为invoices表不会接受必须字段 invoice_date 为空的记录

###  WITH CHECK OPTION 子句

在视图的原始创建语句的最后加上 WITH CHECK OPTION 可以防止执行那些会让视图中某些行（记录）消失的修改语
句。
案例
接前面的invoices_with_balance视图的例子，该视图与原始的orders表相比增加了balance (invouce_total -
payment_total)列，且只显示balance大于0的行（记录），若将某记录（如2号订单）的payment_total改为和
invouce_total相等，则balance为0，该记录会从视图中消失：
```sql
UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 2
```

更新后会发现 invoices_with_balance 视图里2号订单消失。
但在视图原始创建语句的最后加入 WITH CHECK OPTION 后，对3号订单执行类似上面的语句后会报错：

```sql
USE sql_invoicing;
CREATE OR REPLACE VIEW invoices_with_balance AS
……
WHERE (invoice_total - payment_total) > 0
【WITH CHECK OPTION】;
UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 3;
-- Error Code: 1369. CHECK OPTION failed 'sql_invoicing.invoices_with_balance'
```

### 视图的其他优点

三大优点：
简化查询、增加抽象层和减少变化的影响、数据安全性
具体来讲：
1. （首要优点）简化查询 simplify queries
2. 增加抽象层，减少变化的影响 Reduce the impact of changes：视图给表增加了一个抽象层（模块化），这样
如果数据库设计改变了（如一个字段从一个表转移到了另一个表），只需修改视图的查询语句使其能保持原有查
询结果即可，不需要修改使用这个视图的那几十个查询。相反，如果没有视图这一层的话，所有查询将直接使用
指向原表的原始查询语句，这样一旦更改原表设计，就要相应地更改所有的这些查询。

3. 限制对原数据的访问权限 Restrict access to the data：在视图中可以对原表的行和列进行筛选，这样如果你禁
止了对原始表的访问权限，用户只能通过视图来修改数据，他们就无法修改视图中未返回的那些字段和记录。但
需注意，这并不像听上去这么简单，需要良好的规划，否则最后可能搞得一团乱。

