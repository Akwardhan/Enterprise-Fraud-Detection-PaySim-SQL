-- Data Cleaning
-- Working Dataset

select count(*) as zero_amounts
from paysim_transactions
where amount = 0;

delete from paysim_working
where amount = 0;

-- Checking for NULL Values
Select count(*) from paysim_working
where amount IS NULL
or transactionS_type IS NULL
or "nameOrig" IS NULL
or "nameDest" IS NULL;

-- altering table and flagging the data where the value was 0 in amount and balance

Alter table paysim_working add column is_zero_balance BOOLEAN;
update paysim_working
set is_zero_balance = 
	CASE
		when "oldbalanceOrg" = 0
		and "newbalanceOrig" = 0
		and "oldbalanceDest" = 0
		and "newbalanceDest" = 0
		then TRUE 
		ELSE FALSE
	END;
-- true and False are flags. If this transaction has zero balances everywhere,
--flag it as suspicious (TRUE). Otherwise, it’s normal (FALSE).

select * from paysim_working
order by step;

-- check for duplicates
SELECT count(*)
from (
	select *, count(*)Over(Partition By step, transactions_type, amount, "nameOrig", "oldbalanceOrg",
	"newbalanceOrig", "nameDest", "oldbalanceDest", "newbalanceDest") as cnt
	from paysim_working
) sub
where cnt > 1;
)
-- what we did here was, we selected the cnt > 1 by partitioning, meaning grouping all the rows 
-- by columns saying if there ecist the match in all those column add them in cnt column
-- parition by adds the matching value indivually and tells info for every row that how many match this this row has
-- unlike group by. so we added the count in cnt table and then we selected count where cnt >1 to see
-- how many duplicates were there

-- STANDARDIZING
--converts flags to proper boolean
alter table paysim_working
alter column "isFraud" TYPE boolean using ("isFraud" = 1),
alter column "isFlaggedFraud" TYPE boolean using ("isFlaggedFraud" = 1);

select * from paysim_working;

-- clean transaction transactions_type values
select distinct transactions_type from paysim_working;

Alter table paysim_working Rename column is_zero_balance to is_suspicious;

Alter table paysim_working Rename column is_suspicious to is_zero_balance;

-- ADD a fraud suspicion flag based on different conditions
ALter table paysim_working ADD column is_suspicious BOOLEAN;
update paysim_working
SET is_suspicious = (
 	("oldbalanceOrg" = 0 and amount > 0)
or	("newbalanceDest" = 0 and amount >0)	 
);
-- Mark a transaction as suspicious if:
--The sender had no money but sent money, or
--The receiver got money, but their balance stayed zero.”

-- FINAL CHECK ROW AFTER CLEANING
select count(*) from paysim_working;