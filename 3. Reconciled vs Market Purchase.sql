----Reconciled QTY

SELECT	s.warehouseid,COUNT(*) Sale_QTY
FROM	thingrequest tr
	JOIN shipment s on s.id = tr.shipmentid

WHERE	ReconciledOn is not null
	AND s.ReconciledOn >= '2022-03-20 00:00 +6:00' 
	AND s.ReconciledOn < '2022-03-21 00:00 +6:00'
	AND shipmentstatus NOT IN (1,9,10)
	AND IsReturned = 0
	AND tr.IsCancelled = 0
	AND tr.Hasfailedbeforedispatch = 0
	AND tr.IsMissingafterdispatch = 0

GROUP BY s.warehouseid
ORDER BY 1 asc


---MP QTY

-----Geting Min & Max Thing ID
select Max(te.ThingId) [MaximumThingID],
       Min(te.ThingId) [MinimumThingID]
from ThingEvent te
join ThingTransaction tt on tt.Id = te.ThingTransactionId 

where tt.CreatedOn >= '2022-03-20 00:00 +06:00'
and tt.CreatedOn < '2022-03-21 00:00 +06:00'
and FROMstate IN (262144, 536870912)
AND tostate IN ( 65536,16777216,268435456)




SELECT	s.warehouseid,
		COUNT(*) ProductQTY

FROM	ThingRequest tr
	JOIN shipment s on s.id=tr.shipmentid

WHERE ReconciledOn is not null
	AND s.ReconciledOn >= '2022-03-20 00:00 +6:00' 
	AND s.ReconciledOn < '2022-03-21 00:00 +6:00'
--	AND shipmentstatus NOT IN (1,9,10)
	AND iscancelled=0
	AND IsReturned=0
	AND HasFailedBeforeDispatch=0
	AND IsMissingAfterDispatch=0
	AND tr.AssignedThingId in 
		(
SELECT	t.id thingid FROM thing t
JOIN thingevent te ON t.id = te.thingid
JOIN thingtransaction tss on tss.id = te.thingtransactionid
WHERE FROMstate IN (262144, 536870912)
AND tostate IN ( 65536,16777216,268435456)
AND t.CostPrice is not null
AND te.thingid >= 136257693  ------MinimumThingId 
AND te.thingid <= 138073193  ------MaximumThingId 
GROUP BY t.id
		)

GROUP BY s.warehouseid
ORDER BY 1 asc

--SELECT * FROM warehouse


