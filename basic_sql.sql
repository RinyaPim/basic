-- 67040249109
-- นายปริญญา ไชยรส

-- *********แบบฝึกหัด Basic Query #1 ***************
--1. แสดงข้อมูลสินค้า 10 รายการแรก
SELECT top 10 *
FROM Products ;

--2. จงแสดงข้อมูล รหัสพนักงาน ชื่อ นามสกุล ของพนักงานทุกคน
select EmployeeID,FirstName,LastName
from Employees 

--3. แสดงรหัสพนักงาน ชื่อและนามสกุลต่อกัน อายุ ของพนักงานแต่ละคน
SELECT EmployeeID,FirstName+LastName,BirthDate 
from Employees

/*4. แสดงข้อมูลรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย จำนวนคงเหลือ รหัสประเภทสินค้า
จัดเรียงข้อมูลตามรหัสประเภทสินค้า จากน้อยไปหามาก และจำนวนคงเหลือจากมากไปหาน้อย */
select ProductID,ProductName,UnitPrice,UnitsInStock
from Products
ORDER BY CategoryID,UnitsInStock ASC ;

--5. แสดงจำนวนรายการสินค้าที่จัดอยู่ในประเภทสินค้ารหัส 1
SELECT CategoryId
from Categories
where CategoryID = 1;

--6. แสดงจำนวนลูกค้าที่อยู่ในประเทศสหรัฐอเมริกา
SELECT COUNT(*) แสดงจำนวนลูกค้าที่อยู่ในประเทศสหรัฐอเมริกา
from Customers
where Country = 'USA'

--7. แสดงจำนวนใบสั่งซื้อที่จัดส่งไปยังประเทศฝรั่งเศส ในปี 1997
SELECT COUNT(*) as จำนวนใบสั่งซื้อที่จัดส่งไปยังประเทศฝรั่งเศส 
from orders  JOIN Customers on orders.customerID = Customers.customerID
Where shipcountry = 'France' and YEAR(OrderDate) = 1997

--8. แสดงราคาต่อหน่วยของสินค้าที่แพงสุด และถูกที่สุด
SELECT MIN(UnitPrice)as ราคาต่อหน่วยของสินค้าที่แพงสุด,MAX(UnitPrice)as 
ราคาต่อหน่วยของสินค้าที่ถูกที่สุด
from Products 

--9. จงแสดงอายุของพนักงานที่มากสุดและอายุน้อยสุด
SELECt MAX(YEAR(GETDATE())-YEAR(BirthDate)) as max_age,
       MIN(YEAR(GETDATE())-YEAR(BirthDate)) as min_age
from Employees ;

--10. แสดงรหัสสินค้า ราคาต่อหน่วย จำนวนที่ซื้อ ราคารวม ของรายการสั่งซื้อที่อยู่ในใบสั่งซื้อหมายเลข10248
SELECT ProductID, UnitPrice, Quantity, (UnitPrice * Quantity) as sumprice
from [Order Details]
WHERE OrderID = 10248 ;

--11. แสดงยอดสั่งซื้อรวมของใบสั่งซื้อหมายเลข 10248
SELECT SUM(UnitPrice * Quantity) as totolprice
from [Order Details]
WHERE OrderID = 10248 ;

--12. แสดงอายุเฉลี่ยของพนักงาน
select AVG(YEAR(GETDATE()) - YEAR(BirthDate)) as average_age
from Employees ;

--13. แสดงรหัสประเภทสินค้าและจำนวนรายการสินค้าในแต่ละประเภท
SELECT CategoryID, COUNT(ProductID) as NumProducts
from Products
GROUP BY CategoryID ;

/*14. แสดงรหัสประเภทสินค้าและจำนวนรายการสินค้าในแต่ละประเภท 
เฉพาะประเภทสินค้าที่มีรายการสินค้าอยู่ในประเภทนั้น 10 รายการขึ้นไป */
SELECT CategoryID, COUNT(ProductID) as NumProducts
from Products 
GROUP BY CategoryID HAVING COUNT(*) > 10 ;

--15. แสดงชื่อประเทศและจำนวนลูกค้าที่อยู่ในแต่ละประเทศ เฉพาะประเทศที่มีลูกค้าไม่ถึง 5 ราย
SELECT Country , COUNT(*) as costumerID
from Customers
GROUP BY Country HAVING COUNT(*) < 5 ;


/*16. แสดงรหัสใบสั่งซื้อและยอดสั่งซื้อรวมในแต่ละใบสั่งซื้อ เฉพาะใบสั่งซื้อที่มียอดสั่งซื้อรวมเกิน $10000
จัดเรียงข้อมูลตามยอดสั่งซื้อรวมจากมากไปหาน้อย */
SELECT OrderID , SUM(UnitPrice * Quantity) as total
FROM [Order Details] GROUP BY OrderID HAVING SUM(UnitPrice * Quantity) > 10000 
ORDER BY SUM(UnitPrice * Quantity) DESC

