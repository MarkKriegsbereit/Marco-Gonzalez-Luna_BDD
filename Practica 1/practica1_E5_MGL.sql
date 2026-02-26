/*Ejercicio 5: Determinar el producto más vendido de cada categoría de producto, 
considerando el escenario de que el esquema SALES se encuentra en una instancia (servidor) A 
y el esquema PRODUCTION en otra instancia (servidor) B.*/



WITH VentasPorCategoria AS (
    SELECT ppc.ProductCategoryID, pp.Name as NameProd, ppc.Name, pp.ProductID, SUM(sod.OrderQty*sod.UnitPrice) AS TotalVendido
    
		FROM Sales.SalesOrderDetail sod
		JOIN Production.Product pp ON sod.ProductID = pp.ProductID
		JOIN Production.ProductSubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
		JOIN Production.ProductCategory ppc ON pps.ProductCategoryID = ppc.ProductCategoryID
		GROUP BY ppc.ProductCategoryID, pp.Name, ppc.Name, pp.ProductID
)

SELECT * FROM VentasPorCategoria V1
WHERE TotalVendido = (
    SELECT MAX(TotalVendido) 
    FROM VentasPorCategoria V2 
    WHERE V2.ProductCategoryID = V1.ProductCategoryID
	
)
ORDER BY v1.ProductCategoryID;

go

WITH VentasPorCategoria AS (
    SELECT 
        ppc.ProductCategoryID, 
        ppc.Name, 
        pp.ProductID, 
        SUM(sod.OrderQty) AS TotalVendido
    FROM Sales.SalesOrderDetail sod -- Local (Servidor A)
    -- A partir de aquí, todo es remoto (Servidor B)
    JOIN SV_CRIS.AdventureWorks2022_2.Production.Product pp 
        ON sod.ProductID = pp.ProductID
    JOIN SV_CRIS.AdventureWorks2022_2.Production.ProductSubcategoryg pps 
        ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
    JOIN SV_CRIS.AdventureWorks2022_2.Production.ProductCategory ppc 
        ON pps.ProductCategoryID = ppc.ProductCategoryID
    GROUP BY ppc.ProductCategoryID, ppc.Name, pp.ProductID
)

SELECT * FROM VentasPorCategoria V1
WHERE TotalVendido = (
    SELECT MAX(TotalVendido) 
    FROM VentasPorCategoria V2 
    WHERE V2.ProductCategoryID = V1.ProductCategoryID
)
ORDER BY V1.ProductCategoryID;}

go