---Only Market Purchase Sold Information Part-1
--Sold Information

SELECT	w.id WID, w.Name WarehouseName, pv.id PVID, pv.Name ProductName,
		COUNT(*) ProductQTY

FROM ThingRequest tr
JOIN Shipment s ON s.id=tr.ShipmentID
JOIN ProductVariant pv ON tr.ProductVariantID=pv.id
JOIN Warehouse w ON s.WarehouseID=w.id

WHERE ReconciledOn IS NOT NULL
AND s.ReconciledOn >= '2022-03-20 00:00 +6:00' 
AND s.ReconciledOn < '2022-03-21 00:00 +6:00'
--AND ShipmentStatus NOT IN (1,9,10)
AND IsCancelled=0
AND IsReturned=0
AND HasFailedBeforeDispatch=0
AND IsMissingAfterDispatch=0
--AND w.id IN (2,7,27)
AND tr.AssignedThingID IN 
		(
		SELECT	t.id ThingID
		FROM Thing t
		JOIN ThingEvent te ON t.id = te.ThingID
		JOIN ThingTransaction tss ON tss.id = te.ThingTransactionID
		WHERE	FromState IN (262144, 536870912)
		AND ToState IN ( 65536,16777216,268435456)
		AND t.CostPrice IS NOT NULL
		AND te.thingid >= 136257693  ------MinimumThingId 
        AND te.thingid <= 138073193  ------MaximumThingId 
		GROUP BY t.id)

GROUP BY w.id, w.Name, pv.id, pv.Name
ORDER BY 1 ASC


--Only Market Purchase Sales --  Part-2

SELECT s.WarehouseID,tr.ProductVariantID, COUNT(*) Sale_QTY
FROM ThingRequest tr
JOIN Shipment s ON s.id = tr.ShipmentID
JOIN Warehouse w ON s.WarehouseID=w.id

WHERE ReconciledOn IS NOT NULL
AND s.ReconciledOn >= '2022-03-20 00:00 +6:00' 
AND s.ReconciledOn < '2022-03-21 00:00 +6:00'
AND ShipmentStatus NOT IN (1,9,10)
AND IsReturned = 0
AND tr.IsCancelled = 0
AND tr.HasFailedBeforeDispatch = 0
AND tr.IsMissingAfterDispatch = 0

GROUP BY s.WarehouseID, tr.ProductVariantID
ORDER BY 1 ASC