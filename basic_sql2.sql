--67040249109
--นายปริญญา ไชยรส

-- *********แบบฝึกหัด Basic Query #2 ***************
 
 --1. จงแสดงรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย เฉพาะสินค้าประเภท Seafood
 --แบบ Product
SELECT ProductID, ProductName, UnitPrice 
FROM Products, Categories 
WHERE Products.CategoryID = Categories.CategoryID AND Categories.CategoryName = 'Seafood';
--แบบ Join
SELECT ProductID, ProductName, UnitPrice 
FROM Products JOIN Categories 
ON Products.CategoryID = Categories.CategoryID 
WHERE Categories.CategoryName = 'Seafood' ;

---------------------------------------------------------------------
--2.จงแสดงชื่อบริษัทลูกค้า ประเทศที่ลูกค้าอยู่ และจำนวนใบสั่งซื้อที่ลูกค้านั้น ๆ ที่รายการสั่งซื้อในปี 1997
--แบบ Product
SELECT Customers.CompanyName, Customers.Country, COUNT(Orders.OrderID) as จำนวนใบสั่งซื้อของลูกค้า 
FROM Customers, Orders 
WHERE Customers.CustomerID = Orders.CustomerID AND YEAR(Orders.OrderDate) = 1997 
GROUP BY Customers.CompanyName, Customers.Country ;
--แบบ Join
SELECT Customers.CompanyName, Customers.Country, COUNT(Orders.OrderID) as จำนวนใบสั่งซื้อ 
FROM Customers JOIN Orders ON Customers.CustomerID = Orders.CustomerID 
WHERE YEAR(Orders.OrderDate) = 1997 
GROUP BY Customers.CompanyName, Customers.Country ;



---------------------------------------------------------------------
--3. จงแสดงรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย ชื่อบริษัทและประเทศที่จัดจำหน่ายสินค้านั้น ๆ
--แบบ Product
SELECT ProductID, ProductName, UnitPrice, CompanyName
from Products as P , Suppliers as S
WHERE P.SupplierID = S.SupplierID ;
--แบบ Join
SELECT ProductID, ProductName, UnitPrice, CompanyName, Country 
FROM Products JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID ;


---------------------------------------------------------------------
--4. ชื่อ-นามสกุลของพนักงานขาย ตำแหน่งงาน และจำนวนใบสั่งซื้อที่แต่ละคนเป็นผู้ทำรายการขาย 
--เฉพาะที่ทำรายการขายช่วงเดือนมกราคม-เมษายน ปี 1997 และแสดงเฉพาะพนักงานที่ทำรายการขายมากกว่า 10 ใบสั่งซื้อ 
--แบบ Product
SELECT E.FirstName + ' ' + E.LastName AS FullName, E.Title, COUNT(O.OrderID) 
from Employees as E , Orders as O
WHERE E.EmployeeID = O.EmployeeID
and OrderDate BETWEEN '1997-01-01' and '1997-04-30'
GROUP BY FirstName, LastName, Title
HAVING COUNT(OrderID) > 10 ;
--แบบ Join
SELECT E.FirstName + ' ' + E.LastName AS FullName, E.Title, COUNT(O.OrderID) 
FROM Employees E JOIN Orders O on E.EmployeeID = O.EmployeeID 
WHERE (MONTH(O.OrderDate) BETWEEN 1 AND 6) AND YEAR(O.OrderDate) = 1997 
GROUP BY E.FirstName, E.LastName, E.Title 
HAVING COUNT(O.OrderID) > 10 ;
---------------------------------------------------------------------
--5.จงแสดงรหัสสินค้า ชื่อสินค้า ยอดขายรวม(ไม่คิดส่วนลด) ของสินค้าแต่ละชนิด
--แบบ Product
SELECT OD.ProductID, P.ProductName, sum(od.Quantity) as ยอดขายรวม
FROM [Order Details] as OD , Products as P
where OD.ProductID = P.ProductID 
group by OD.ProductID, P.ProductName ;
--แบบ Join
SELECT OD.ProductID, P.ProductName, SUM(od.Quantity) as ยอดขายรวม 
FROM [Order Details] OD JOIN Products P ON OD.ProductID = P.ProductID 
GROUP BY OD.ProductID, P.ProductName ;

---------------------------------------------------------------------
/*6.จงแสดงรหัสบริษัทจัดส่ง ชื่อบริษัทจัดส่ง จำนวนใบสั่งซื้อที่จัดส่งไปยังประเทศสหรัฐอเมริกา, 
อิตาลี, สหราชอาณาจักร, แคนาดา ในเดือนมกราคม-สิงหาคม ปี 1997 */
--แบบ Product
select ShipperID, CompanyName, COUNT(OrderID) as NumShipoedOrder
from Orders as O , Shippers as S
where O.ShipVia = S.ShipperID
        and ShipCountry In ('USA', 'Italy', 'UK', 'Cannada')
        and ShippedDate BETWEEN '1997-01-01' and '1997-08-31'
GROUP BY ShipperID, CompanyName ;
--แบบ Join
select S.ShipperID, S.CompanyName, count(o.OrderID) as จำนวนใบสั่งซื้อ 
FROM Shippers S JOIN Orders O on S.ShipperID = O.ShipVia join Customers C on C.CustomerID = O.CustomerID 
WHERE (MONTH(O.OrderDate) BETWEEN 1 AND 6 AND YEAR(O.OrderDate) = 1997 )AND C.Country IN ('USA', 'Italy', 'Canada','UK') 
GROUP BY S.ShipperID, S.CompanyName ;

---------------------------------------------------------------------
-- *** 3 ตาราง ****
/*7 : จงแสดงเลขเดือน ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) เฉพาะรายการสั่งซื้อที่ทำรายการขายในปี 1996 
และจัดส่งไปยังประเทศสหราชอาณาจักร,เบลเยี่ยม, โปรตุเกส ของพนักงานขายชื่อ Nancy Davolio*/
--แบบ Product
SELECT MONTH(O.OrderDate) as เดือน, SUM(OD.UnitPrice * OD.Quantity) as ยอดสั่งซื้อ
from Orders as O , [Order Details] as OD, Employees as E 
where O.OrderID = OD.OrderID and O.EmployeeID = E.EmployeeID
        and YEAR(OrderDate) = 1996
        and ShipCountry in ('UK', 'Belgium', 'Portugal')
        and FirstName = 'Nancy' and LastName = 'Davolio'
GROUP BY MONTH(OrderDate) ;

--แบบ Join
SELECT MONTH(O.OrderDate) as เดือน, SUM(OD.UnitPrice * OD.Quantity) as ยอดสั่งซื้อ 
FROM Orders O JOIN [order details] OD ON o.OrderID = OD.OrderID JOIN Customers C ON O.CustomerID = C.CustomerID 
WHERE YEAR(O.OrderDate) = 1996 AND C.Country IN ('Germany', 'France', 'UK') 
GROUP BY MONTH(O.OrderDate) ;
--------------------------------------------------------------------------------

/*8 : จงแสดงข้อมูลรหัสลูกค้า ชื่อบริษัทลูกค้า และยอดรวม(ไม่คิดส่วนลด) เฉพาะใบสั่งซื้อที่ทำรายการสั่งซื้อในเดือน มค. ปี 1997 
จัดเรียงข้อมูลตามยอดสั่งซื้อมากไปหาน้อย*/
--แบบ Product
SELECT C.CustomerID, C.CompanyName, SUM(OD.UnitPrice * OD.Quantity) as ยอดสั่งซื้อ 
FROM Customers as C ,Orders as O ,[Order Details] as OD 
WHERE C.CustomerID = O.CustomerID AND O.OrderID = OD.OrderID AND MONTH(O.OrderDate) = 1 AND YEAR(O.OrderDate) = 1997 
GROUP BY C.CustomerID, C.CompanyName ;
--แบบ Join
SELECT C.CustomerID, C.CompanyName, SUM(OD.UnitPrice * OD.Quantity) as ยอดสั่งซื้อ 
FROM Customers C JOIN Orders O ON c.CustomerID = O.CustomerID JOIN [Order Details] OD ON O.OrderID = OD.OrderID 
WHERE MONTH(O.OrderDate) = 1 AND YEAR(O.OrderDate) = 1997 
GROUP BY C.CustomerID, C.CompanyName ;
---------------------------------------------------------------------------------

/*9 : จงแสดงรหัสผู้จัดส่ง ชื่อบริษัทผู้จัดส่ง ยอดรวมค่าจัดส่ง เฉพาะรายการสั่งซื้อที่ Nancy Davolio เป็นผู้ทำรายการขาย*/
--แบบ Product
SELECT S.ShipperID, S.CompanyName, SUM(OD.UnitPrice * OD.Quantity) as ยอดสั่งซื้อ 
FROM Orders as O ,Shippers as S ,Employees as E ,[Order Details] as OD
WHERE O.ShipVia = S.ShipperID AND O.EmployeeID = E.EmployeeID AND OD.OrderID = O.OrderID AND E.FirstName = 'Nancy' AND E.LastName = 'Davolio' 
GROUP BY S.ShipperID, S.CompanyName ;

--แบบ Join
SELECT S.ShipperID, S.CompanyName, SUM(OD.UnitPrice * OD.Quantity) as ยอดสั่งซื้อ 
FROM Orders O JOIN Shippers  S on O.ShipVia = S.ShipperID JOIN Employees E on o.EmployeeID = E.EmployeeID JOIN [Order Details] OD on OD.OrderID = O.OrderID 
WHERE E.FirstName = 'Nancy' AND E.LastName = 'Davolio' 
GROUP BY S.ShipperID, S.CompanyName ;


---------------------------------------------------------------------------------
/*10 : จงแสดงข้อมูลรหัสใบสั่งซื้อ วันที่สั่งซื้อ รหัสลูกค้าที่สั่งซื้อ ประเทศที่จัดส่ง จำนวนที่สั่งซื้อทั้งหมด ของสินค้าชื่อ Tofu ในช่วงปี 1997*/
--แบบ Product
SELECT OD.OrderID, O.OrderDate, O.CustomerID, C.Country, OD.Quantity 
FROM [Order Details] as OD, Orders as O, Customers as C, Products as P 
WHERE OD.OrderID = O.OrderID AND C.CustomerID = C.CustomerID AND OD.ProductID = P.ProductID AND P.ProductName = 'Tofu' AND YEAR(O.OrderDate) = 1997 
GROUP BY OD.OrderID, O.OrderDate, O.CustomerID, C.Country , OD.Quantity ;
--แบบ Join
SELECT OD.OrderID, O.OrderDate, O.CustomerID, C.Country, OD.Quantity 
FROM [Order Details] as OD JOIN Orders O on OD.OrderID = O.OrderID join Customers C on O.CustomerID = C.CustomerID join Products P on OD.ProductID = P.ProductID 
WHERE P.ProductName = 'Tofu' AND YEAR(O.OrderDate) = 1997 
GROUP BY OD.OrderID, O.OrderDate, O.CustomerID, C.Country , OD.Quantity ;

-----------------------------------------------------------------------------
/*11 : จงแสดงข้อมูลรหัสสินค้า ชื่อสินค้า ยอดขายรวม(ไม่คิดส่วนลด) ของสินค้าแต่ละรายการเฉพาะที่มีการสั่งซื้อในเดือน มค.-สค. ปี 1997*/
--แบบ Product
SELECT P.ProductID , ProductName, Sum(OD.UnitPrice * Quantity) as Sumprice
from Products as P, [Order Details] as OD, Orders as O
WHERE P.ProductID = OD.ProductID and OD.OrderID = O.OrderID
     and OrderDate BETWEEN '1997-01-01' And '1997-08-31'
GROUP BY P.ProductID, ProductName ;
--แบบ Join
SELECT P.ProductID , ProductName, Sum(OD.UnitPrice * Quantity) as Sumprice
FROM Products as P INNER JOIN [Order Details] as OD on OD.ProductID = OD.OrderID
                   INNER JOIn Orders as O on OD.OrderID = O.OrderID
where OrderDate BETWEEN '1997-01-01' and '1997-08-31'
GROUP BY P.ProductID, ProductName ;
-----------------------------------------------------------------------------
-- *** 4 ตาราง ****
/*12 : จงแสดงข้อมูลรหัสประเภทสินค้า ชื่อประเภทสินค้า ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) เฉพาะที่มีการจัดส่งไปประเทศสหรัฐอเมริกา ในปี 1997*/
--แบบ Product
SELECT C.CategoryID, CategoryName, SUM(OD.Quantity*OD.UnitPrice) as ยอดสั่งซื้อรวม
from Categories as C , Products as P, [Order Details] as OD , Orders as O
where C.CategoryID = P.CategoryID 
      and P.ProductID = OD.ProductID
      and OD.OrderID = O.OrderID
GROUP BY C.CategoryID, CategoryName ;
--แบบ Join
SELECT C.CategoryID, CategoryName, SUM(OD.Quantity*OD.UnitPrice) as ยอดสั่งซื้อรวม
from Categories as C INNER JOIN Products as P on C.CategoryID = P.CategoryID
                     INNER JOIN [Order Details] as OD on P.ProductID = OD.ProductID
                     INNER JOIN Orders as O on OD.OrderID = O.OrderID
where ShipCountry = 'USA' and YEAR(ShippedDate) = 1997
GROUP BY C.CategoryID, CategoryName ;

----------------------------------------------------------------------------
/*13 : จงแสดงรหัสพนักงาน ชื่อและนามสกุล(แสดงในคอลัมน์เดียวกัน) ยอดขายรวมของพนักงานแต่ละคน เฉพาะรายการขายที่จัดส่งโดยบริษัท Speedy Express 
ไปยังประเทศสหรัฐอเมริกา และทำการสั่งซื้อในปี 1997 */
--แบบ Product
SELECT E.EmployeeID, FirstName+''+LastName as employeename
FROM Employees as E, Orders as O, Shippers as S ,[Order Details] as OD
WHERE E.EmployeeID = O.EmployeeID 
     and O.ShipVia = S.ShipperID
     and O.OrderID = OD.OrderID 
     and CompanyName = 'Speedy Exprss' and ShipCountry = 'USA'
     and YEAR(OrderDate) = 1997
GROUP BY E.EmployeeID, FirstName, LastName ; 
--แบบ Join
SELECT E.EmployeeID, FirstName+''+LastName as employeename
from Employees as E INNER JOIN Orders as O on E.EmployeeID = O.EmployeeID
                    INNER join Shippers as S on O.ShipVia = S.ShipperID
                    INNer join [Order Details] As OD On O.OrderID = OD.OrderID
where CompanyName = 'Speedy Exprss' and ShipCountry = 'USA' ;

---------------------------------------------------
/*14 : จงแสดงรหัสสินค้า ชื่อสินค้า ยอดขายรวม เฉพาะสินค้าที่นำมาจัดจำหน่ายจากประเทศญี่ปุ่น และมีการสั่งซื้อในปี 1997 และจัดส่งไปยังประเทศสหรัฐอเมริกา */
--แบบ Product
SELECT P.ProductID, P.ProductName, SUM(od.Quantity) 
FROM Products as P,[Order Details] as OD, Orders as O, Customers as C ,Suppliers as S 
WHERE P.ProductID = OD.ProductID AND OD.OrderID = O.OrderID AND O.CustomerID = C.CustomerID AND S.SupplierID = P.SupplierID AND S.Country = 'Japan' AND C.Country = 'USA' AND YEAR(O.OrderDate) = 1997 
GROUP BY p.ProductID, p.ProductName ;


--แบบ Join
SELECT P.ProductID,P.ProductName,SUM(OD.Quantity) 
FROM Products P JOIN [Order Details] OD ON P.ProductID = OD.ProductID JOIN Orders O ON OD.OrderID = O.OrderID JOIN Customers C ON O.CustomerID = C.CustomerID JOIN Suppliers S ON p.SupplierID = S.SupplierID 
WHERE S.Country = 'Japan' AND C.Country = 'USA' AND YEAR(O.OrderDate) = 1997 
GROUP BY P.ProductID, P.ProductName ;

----------------------------------------------------------------------------
-- *** 5 ตาราง ***
/*15 : จงแสดงรหัสลูกค้า ชื่อบริษัทลูกค้า ยอดสั่งซื้อรวมของการสั่งซื้อสินค้าประเภท Beverages ของลูกค้าแต่ละบริษัท  และสั่งซื้อในปี 1997 จัดเรียงตามยอดสั่งซื้อจากมากไปหาน้อย*/
--แบบ Product
SELECT C.CustomerID, C.CompanyName, SUM(OD.Quantity*OD.UnitPrice) as ยอดสั่งซื้อ 
FROM Customers as C, Orders as O, [Order Details] as OD, Products as P 
WHERE C.CustomerID = O.CustomerID AND O.OrderID = OD.OrderID AND OD.ProductID = P.ProductID AND P.CategoryID = 1 AND YEAR(O.OrderDate) = 1997 
GROUP BY C.CustomerID, C.CompanyName ORDER BY ยอดสั่งซื้อ DESC ;


--แบบ Join
SELECT C.CustomerID, C.CompanyName, SUM(OD.Quantity*OD.UnitPrice) as ยอดสั่งซื้อ 
FROM Customers C JOIN Orders O on C.CustomerID = O.CustomerID JOIN  [Order Details] OD on O.OrderID = OD.OrderID JOIN Products P on OD.ProductID = P.ProductID 
WHERE P.CategoryID = 1 AND YEAR(O.OrderDate) = 1997 
GROUP BY C.CustomerID, C.CompanyName ORDER BY ยอดสั่งซื้อ DESC ;

---------------------------------------------------------------------------
/*16 : จงแสดงรหัสผู้จัดส่ง ชื่อบริษัทที่จัดส่ง จำนวนใบสั่งซื้อที่จัดส่งสินค้าประเภท Seafood ไปยังประเทศสหรัฐอเมริกา ในปี 1997 */
--แบบ Product
SELECT S.ShipperID, S.CompanyName, COUNT(o.OrderID) 
FROM Shippers as S, Orders as O, Customers as C
WHERE S.ShipperID = O.ShipVia AND O.CustomerID = C.CustomerID AND C.Country = 'USA' AND YEAR(O.OrderDate) = 1997 
GROUP BY S.ShipperID, S.CompanyName ;

--แบบ Join
SELECT S.ShipperID, S.CompanyName, COUNT(O.OrderID) 
FROM Shippers S JOIN Orders O on S.ShipperID = O.ShipVia JOIN Customers C on O.CustomerID = C.CustomerID 
WHERE C.Country = 'USA' AND YEAR(O.OrderDate) = 1997 
GROUP BY S.ShipperID, S.CompanyName ;
---------------------------------------------------------------------------
-- *** 6 ตาราง ***
/*17 : จงแสดงรหัสประเภทสินค้า ชื่อประเภท ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) ที่ทำรายการขายโดย Margaret Peacock ในปี 1997 
และสั่งซื้อโดยลูกค้าที่อาศัยอยู่ในประเทศสหรัฐอเมริกา สหราชอาณาจักร แคนาดา */

--แบบ Product
SELECT P.CategoryID, C.CategoryName, SUM(OD.Quantity*OD.UnitPrice)as ยอดสั่งซื้อรวม 
FROM Products as P , Categories as C, Employees as E, Customers as CU, Orders as O,[Order Details] as OD
WHERE P.CategoryID = C.CategoryID and P.ProductID = OD.ProductID and E.EmployeeID = O.EmployeeID and O.OrderID = OD.OrderID and O.CustomerID = CU.CustomerID and CU.Country in('USA', 'Canada','UK') and E.FirstName = 'Margaret' and E.LastName = 'Peacock' and YEAR(O.OrderDate) = 1997 
GROUP BY P.CategoryID, C.CategoryName ;

--แบบ Join
SELECT P.CategoryID, C.CategoryName, SUM(OD.Quantity * OD.UnitPrice) AS ยอดสั่งซื้อรวม 
FROM Products P JOIN Categories C ON P.CategoryID = C.CategoryID JOIN [Order Details] OD ON P.ProductID = OD.ProductID JOIN Orders O ON O.OrderID = OD.OrderID JOIN Customers CU ON O.CustomerID = CU.CustomerID JOIN Employees E ON O.EmployeeID = E.EmployeeID 
WHERE CU.Country IN ('USA', 'Canada', 'UK') AND E.FirstName = 'Margaret' AND E.LastName = 'Peacock' AND YEAR(O.OrderDate) = 1997 
GROUP BY P.CategoryID, C.CategoryName ;

---------------------------------------------------------------------------
/*18 : จงแสดงรหัสสินค้า ชื่อสินค้า ยอดสั่งซื้อรวม(ไม่คิดส่วนลด) ของสินค้าที่จัดจำหน่ายโดยบริษัทที่อยู่ประเทศสหรัฐอเมริกา ที่มีการสั่งซื้อในปี 1997 
จากลูกค้าที่อาศัยอยู่ในประเทศสหรัฐอเมริกา และทำการขายโดยพนักงานที่อาศัยอยู่ในประเทศสหรัฐอเมริกา */

--แบบ Product
SELECT OD.ProductID, P.ProductName, SUM(OD.Quantity * OD.UnitPrice) AS ยอดสั่งซื้อรวม 
FROM [Order Details] as OD, Orders as O , Employees as E, Customers as C , Products as P 
WHERE OD.OrderID = O.OrderID AND O.CustomerID = C.CustomerID AND O.EmployeeID = E.EmployeeID AND P.ProductID = OD.ProductID AND YEAR(O.OrderDate) = 1997 AND E.Country = 'USA' AND C.Country = 'USA' 
GROUP BY OD.ProductID, P.ProductName ;

--แบบ Join
SELECT OD.ProductID, P.ProductName, SUM(OD.Quantity * OD.UnitPrice) AS ยอดสั่งซื้อรวม 
FROM [Order Details] OD JOIN Orders O ON od.OrderID = O.OrderID JOIN Customers C ON O.CustomerID = C.CustomerID JOIN Employees E ON O.EmployeeID = E.EmployeeID JOIN Products P ON OD.ProductID = P.ProductID 
WHERE YEAR(O.OrderDate) = 1997 AND E.Country = 'USA' AND C.Country = 'USA' 
GROUP BY OD.ProductID, P.ProductName ;
---------------------------------------------------------------------------
