-- FLO Customer Analytics | Microsoft SQL Server (T-SQL)
-- Source: flodb.dbo.flo
-- Each row is treated as one customer; check uniqueness before aggregating.
-- The channel label identifies customer groups, not necessarily the transaction channel.

-- 01 | Validate total and unique customers
SELECT COUNT(*) AS customer_records,
       COUNT(DISTINCT master_id) AS unique_customers
FROM dbo.flo;

-- 02 | Customer distribution by labeled channel
SELECT order_channel,
       COUNT(*) AS customer_count
FROM dbo.flo
GROUP BY order_channel
ORDER BY customer_count DESC;

-- 03 | Total historical online and offline spend by customer group
SELECT order_channel,
       ROUND(SUM(customer_value_total_ever_online), 2) AS total_online_spend,
       ROUND(SUM(customer_value_total_ever_offline), 2) AS total_offline_spend
FROM dbo.flo
GROUP BY order_channel
ORDER BY total_offline_spend DESC;

-- 04 | Average historical online and offline spend per customer
SELECT order_channel,
       ROUND(AVG(customer_value_total_ever_online), 2) AS avg_online_spend,
       ROUND(AVG(customer_value_total_ever_offline), 2) AS avg_offline_spend
FROM dbo.flo
GROUP BY order_channel
ORDER BY avg_online_spend DESC;

-- 05 | Single customer-group filter (WHERE)
SELECT COUNT(*) AS desktop_customers
FROM dbo.flo
WHERE order_channel = 'Desktop';

-- 06 | Group-level filter (HAVING); example, not independently executed for this report
SELECT order_channel,
       COUNT(*) AS customer_count
FROM dbo.flo
GROUP BY order_channel
HAVING COUNT(*) > 3000
ORDER BY customer_count DESC;
