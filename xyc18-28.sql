//18
当score≥60时，IF返回1（被计数）
当score<60时，IF返回NULL（不被计数）
结果就是统计及格的学生人数

COUNT函数只统计非NULL值：
无论IF返回什么值，只有当返回值不为NULL时才会被计数
如果IF返回NULL，则该行不会被计数
常见用法：
通常让IF在条件满足时返回1（或其他非NULL值），不满足时返回NULL
这样COUNT实际上就是在统计满足条件的行数

SELECT COUNT(IF(score >= 60, 1, NULL)) AS pass_count
FROM students;

select
gender,
university,
round(count(device_id),1) as user_num,
round(avg(active_days_within_30),1) as avg_active_day,
round(avg(question_cnt),1) as avg_question_cnt
from user_profile
group by 1,2
order by 1,2


//19
where的筛选会执行在 from之后
where只能依据原表中的数据做筛选 
原表中没有的 要用having来筛选
不能有多余的逗号
select
university,
avg(question_cnt) as avg_question_cnt,
avg(answer_cnt) as  avg_answer_cnt
from user_profile
group by 1
having  avg_question_cnt < 5 or avg_answer_cnt < 20


一、执行顺序总览
1. FROM & JOIN -2.WHERE -3.GROUP BY|- 
4. HAVING - 5. SELECT -6.ORDER BY 7. LIMIT
可简单记为：先确定数据源 (FROM/ J0IN) 过滤行 
 (WHERE ) 一分组 (GROUP BY ) 一过滤分组 (HAVING ) 一选择列 (SELECT
) 排序 (ORDER BY ) 限制结果 (LIMIT) 

//20
select
university,
round(avg(question_cnt),4) as avg_question_cnt
from
user_profile
group by university
order by avg_question_cnt


//21
select 
*
from
question_practice_detail a
left join
(
    select
    device_id,
    university
    from
    user_profile
) b
on a.device_id = b.device_id

left join的话 主表在左边
select 
*
from
question_practice_detail as a
left join
user_profile as b
on a.device_id = b.device_id

select 
a.device_id as device_id, 
b.question_id as question_id,
result
from
question_practice_detail as a
left join
user_profile as b
on a.device_id = b.device_id
where b.university = '浙江大学'
order by question_id

//22
select 
b.university as university,
round(count(1)/count(distinct a.device_id),4) as avg_answer_cnt
from 
question_practice_detail  as a
left join user_profile as b
on a.device_id = b.device_id
group by b.university

//23
平均答题数目
(说明：某学校用户平均答题数量计算方式为
该学校用户答题总次数除以答过题的不同用户个数
哪张表应该作为主表？
主表选择的主要原则
数据量较小的表优先
通常选择行数较少的表作为主表
例如：订单明细表(大)关联产品表(小)时，以产品表为主表效率更低
过滤条件更严格的表优先
如果某张表有高度筛选性的WHERE条件，以该表为主表
例如：用户表(10万行)中有状态='活跃'的过滤条件，而订单表(100万行)没有过滤条件，应以用户表为主表
需要保留所有记录的表
当使用LEFT JOIN时，左表就是需要保留所有记录的表
例如：要查询所有客户及其订单(即使没有订单也要显示客户)，则应以客户表为主表
索引情况
优先选择有良好索引支持关联字段的表
例如：订单表的customer_id有索引，而客户表的id是主键，以订单表为主表可能更高效

我觉得应该选第二章表

select
b.university as university,
c.difficult_level as difficult_level,
count(1)/count(distinct a.device_id) as avg_answer_cnt
from
question_practice_detail as a
left join user_profile as b
on a.device_id = b.device_id
left join question_detail as c
on a.question_id = c.question_id
group by b.university ,c.difficult_level

//24
平均答题数目
(说明：某学校用户平均答题数量计算方式为
该学校用户答题总次数除以答过题的不同用户个数
select
b.university,
c.difficult_level,
count(b.university)/count(distinct a.device_id) as avg_answer_cnt
from
question_practice_detail as a
left join user_profile as b
on a.device_id = b.device_id
left join question_detail as c
on a.question_id = c.question_id
where b.university = '山东大学'
group by b.university,c.difficult_level

-- 还用另外的做法

select
b.university,
c.difficult_level,
count(b.university)/count(distinct a.device_id) as avg_answer_cnt
from
question_practice_detail as a
left join user_profile as b
on a.device_id = b.device_id and  b.university = '山东大学'
left join question_detail as c
on a.question_id = c.question_id
where b.device_id is not null
group by b.university,c.difficult_level

-- join会丢掉没有连接上的行
-- left join会保留左表的所有行
select
b.university,
c.difficult_level,
count(b.university)/count(distinct a.device_id) as avg_answer_cnt
from
question_practice_detail as a
join user_profile as b
on a.device_id = b.device_id and  b.university = '山东大学'
left join question_detail as c
on a.question_id = c.question_id
group by b.university,c.difficult_level

//25
select distinct
device_id,gender,age,gpa
from
user_profile
where university = '山东大学' 
union all
select distinct
device_id,gender,age,gpa
from
user_profile
where gender = 'male' 

//26
-- if函数的用法
SELECT 
    order_id,
    amount,
    IF(amount > 1000, '大额订单', '普通订单') AS order_type
FROM orders;

select
if(age < 25 or age is null,'25岁以下','25岁及以上'),
count(1) as number
from
user_profile
group by 1

//27 学习 case when 的用法
-- 根据分数评级
SELECT 
    student_name,
    score,
    CASE
        WHEN score >= 90 THEN 'A'
        WHEN score >= 80 THEN 'B'
        WHEN score >= 70 THEN 'C'
        WHEN score >= 60 THEN 'D'
        ELSE 'F'
    END AS grade
FROM students;

select
device_id,
gender,
case when age<20 then '20岁以下'
     when age>=20 and age<24 then '20-24岁'
     when age>=25 then '25岁及以上'
 else '其他' 
END as age_cut
from user_profile

//28
left函数
-- 引号类型的区别
-- 反引号（`）：
-- 在 MySQL 和 MariaDB 中用于引用标识符（如列名、表名）
-- 用于避免与保留关键字冲突或处理包含特殊字符的名称
-- 例如：`date` 表示引用名为 date 的列
select
day(`date`) as day
,count(1) as question_cnt
from question_practice_detail
where left(`date`, 7) = '2021-08'
group by 1
-- DAY() 是一个日期函数，用于从日期或日期时间值中提取日部分（月份中的具体哪一天），返回一个整数（1-31）。