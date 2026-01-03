/***
 * 牛客网 快速入门 40题
 * https://www.nowcoder.com/exam/oj?page=1&tab=SQL%E7%AF%87&topicId=199
 */
//1 
select * from user_profile

//2
select
device_id,gender,age,university
from
user_profile

//3
select distinct
university
from
user_profile

select 
university
from
user_profile
group by university

//4
select device_id from user_profile
limit 2

//5
select 
device_id as user_infos_example 
from user_profile
limit 2


//6 
select
device_id,university
from user_profile
where university = "北京大学"

//7
select
device_id,gender,age,university
from
user_profile
where age>24

//8
select
device_id,gender,age
from
user_profile
where age<=23 and age>=20

//9
select
device_id,gender,age,university
from
user_profile
where university !='复旦大学'

//10
select
device_id,gender,age,university
from
user_profile
where age is not null

//11
select
device_id,gender,age,university,gpa
from
user_profile
where gender = 'male' and gpa>3.5

//12
select
device_id,gender,age,university,gpa
from
user_profile
where university = '北京大学' or gpa>3.7

//13
select
device_id,gender,age,university,gpa
from
user_profile
where university in ('北京大学','复旦大学','山东大学')

//14
select
device_id,gender,age,university,gpa
from
user_profile
where (gpa>3.5 and university = '山东大学') or (gpa>3.8 and university = '复旦大学')

//15
select
device_id,age,university
from
user_profile
where university like '%北京%'

//16 
select
round(max(gpa),1) as gpa
from
user_profile
where university = '复旦大学'