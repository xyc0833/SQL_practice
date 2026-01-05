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
on a.device_id = b.device_id
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