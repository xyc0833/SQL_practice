//41 
-- sum () over相关用法
select
profit_id,
profit_date,
profit,
sum(profit) over(
    order by profit_date
) as cumulative_profit
from daily_profits

SELECT 
    column1, 
    column2,
    SUM(column_to_sum) OVER (
        [PARTITION BY partition_expression]
        [ORDER BY sort_expression [ASC | DESC]]
        [frame_clause]
    ) AS sum_result
FROM table_name;
--  简单累计求和
SELECT 
    date,
    sales,
    SUM(sales) OVER (ORDER BY date) AS running_total
FROM sales_data;
-- 这个查询会按日期顺序计算销售总额的累计值。

-- over是窗口函数？？
https://www.bilibili.com/video/BV1tzxyzREXP/?spm_id_from=333.337.search-card.all.click&vd_source=4fd29620ab97a080af7ee392e19b0fcb

select * ,sum(quantity) over (partition by product_id) from sales;
--窗口函数 保持原本的sql行数不变 去新增一个列
--partition by 分组依据