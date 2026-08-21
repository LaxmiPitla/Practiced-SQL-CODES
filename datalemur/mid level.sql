/*===============================User's Third Transaction - Uber SQL Interview Question===============================*/

SELECT user_id,spend,transaction_date FROM
(
SELECT *,
ROW_NUMBER() OVER(Partition by user_id order by transaction_date) as rn
FROM transactions)t
where rn = 3
/*=====================================================*/
