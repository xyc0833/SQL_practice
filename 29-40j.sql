//29
-- WITH子句（公用表表达式，CTE）
-- WITH子句用于定义临时结果集，可在后续查询中引用，类似于临时视图。
WITH cte_name AS (
    SELECT columns FROM table WHERE conditions
)
SELECT * FROM cte_name;

with tmp
as(
    select
    device_id,date
    from
    question_practice_detail
    group by 1,2
)
-- 自己也可以连接自己
select * from tmp


with tmp
as(
    select
    device_id,date
    from
    question_practice_detail
    group by 1,2
)

select 
count(b.device_id) / count(a.device_id) as avg_ret
from tmp as a
left join tmp b
on a.device_id = b.device_did
and a.date = date_sub(b.date,interval 1 day)

//30
-- sql字段内如何截取字符？
-- SUBSTRING_INDEX 是 SQL 中用于根据指定分隔符和出现次数截取字符串的函数
SELECT SUBSTRING_INDEX('user@example.com', '@', -1);  
-- 返回 'example.com'
SELECT SUBSTRING_INDEX('/home/user/file.txt', '/', 3);  
-- 返回 '/home/user'
SELECT SUBSTRING_INDEX('A|B|C', '|', 2);  
-- 返回 'A|B'（第2个分隔符前）
SELECT SUBSTRING_INDEX('A|B|C', '|', -2);  
-- 返回 'B|C'（倒数第2个分隔符后）

select
substring_index(profile,',',-1)
from
user_submit
-- 前面有count 后面必须有group by
select
substring_index(profile,',',-1),
count(1) as number
from
user_submit
group by 1

//31
select
device_id,
substring_index(blog_url,'/',-1)
from
user_submit

//32 
-- 嵌套写法
select
substring_index(substring_index(profile,',',3),',',-1) as age,
count(1) as number
from
user_submit
group by 1

//33
select
b.device_id,
a.*
from
(
    select
    university,
    min(gpa) as gpa
    from user_profile
    group by 1
) as a
left join
(
    select
    *
    from user_profile
) as b
on a.university = b.university and a.gpa = b.gpa
order by 2


//34
select 
a.device_id,
b.university,
count(question_id) 
# result
from question_practice_detail as a
left join 
user_profile as b
on a.device_id = b.device_id
where b.university = '复旦大学'
group by a.device_id

sum(if(a.result = 'right',1,0))
-- if(a.result = 'right', 1, 0)
-- 这是一个条件判断：
-- 如果字段 a.result 的值等于字符串 'right'，则返回 1。
-- 否则返回 0。
-- 效果：将 'right' 的记录标记为 1，其他记录标记为 0。
-- sum(...)
-- 对 if 函数的结果求和：
-- 所有 1 会被累加（即统计 'right' 的出现次数）。
-- 0 不影响总和。

select
    a.device_id as device_id,
    b.university as university,
    count(1) as question_cnt,
    sum(if(a.result = 'right', 1, 0)) as right_question_cnt
from
    question_practice_detail as a
    left join user_profile as b on a.device_id = b.device_id
where
    b.university = '复旦大学'
    and left(a.date, 7) = '2021-08'
group by
    a.device_id
union all
# 剩下的部分要加入 没有答过题的人
select
    a.device_id as device_id,
    a.university as university,
    0 as question_cnt,
    0 as right_question_cnt
from
    user_profile a
    left join question_practice_detail b on a.device_id = b.device_id
    and a.university = '复旦大学'
where
    b.device_id is null
    and a.university = '复旦大学'

//40
select
    id,
    name,
    phone_number
from
    contacts
where
    phone_number REGEXP '^[1-9][0-9]{2}-?[0-9]{3}-?[0-9]{4}$';

^[1-9][0-9]{2}-?[0-9]{3}-?[0-9]{4}$
-- 可以用‘？’来表示0或1，进一步简化表达式：
-- -? 意思为 需要匹配0个-（没有-字符）或者1个-字符。
-- -------------NOTES------------------
-- ^ 表示字符串开始
-- $表示字符串结束
-- []表示 character set，结合-使用表示范围，eg: [1-9]表示1,2,3,4,5....8,9组成的集合
-- {}为数量符，eg:[0-9]{2}表示搜寻'2个0-9中的任意字符'
-- ？为数量符合，表示0或1个, eg -?表示搜寻'0个或者1个字符 "-" '

//35
select 
c.difficult_level,
sum(if(a.result='right',1,0))/count(1)
from question_practice_detail as a
left join user_profile as b
on a.device_id = b.device_id
left join question_detail as c
on a.question_id = c.question_id
where b.university = '浙江大学'
group by 1
order by 2

//36
select
device_id,
age
from user_profile
order by 2
