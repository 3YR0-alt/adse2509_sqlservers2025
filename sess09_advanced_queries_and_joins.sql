/* Session09 covers grouping, aggregating data, subqueries, joins, table expressions, and pivoting & unpivoting data. */

--Switch to the AdventureWorks database
use AdventureWorks2025;

-- Demostrate the 'group by' clause in a select statement
-- Get/retrieve the number of hours per work order from the workrouting table in the production schema
select workorderid, sum(ActualResourceHRS) 'Hours Per Order'
from production.workorderrouting
group by workorderid;
