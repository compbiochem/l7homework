CREATE TABLE widgets1 
(Widget varchar, Packaging varchar, Customer varchar, Price money, 
Supplier varchar, Cost money, Warehouse varchar, Quantity integer, MinQuantity integer);

COPY widgets1 FROM 'C:/Users/bwils/OneDrive/Desktop/l7homework/widgets.csv' DELIMITER E',' CSV HEADER;

CREATE TABLE allWidgets (
  widgetID serial,   
  widget varchar,
  PRIMARY KEY (widgetID)
);

INSERT INTO allWidgets (widget)
SELECT TRIM(BOTH FROM Widget) FROM widgets1 GROUP BY TRIM(BOTH FROM Widget);

CREATE TABLE purchasing (
   purchaseID serial,
   widgetIDP varchar,
   Cost money,
   Supplier varchar,
   Warehouse varchar,
   MinQuantity integer,
   PRIMARY KEY (purchaseID)
);

INSERT INTO purchasing (widgetidp, cost, supplier, warehouse, minquantity)
SELECT TRIM(BOTH FROM Widget), cost, TRIM(BOTH FROM supplier), TRIM(BOTH FROM warehouse), minquantity FROM widgets1 GROUP BY TRIM(BOTH FROM Widget), cost, TRIM(BOTH FROM supplier), TRIM(BOTH FROM warehouse), minquantity;

UPDATE purchasing
SET widgetIDP = allWidgets.widgetID
FROM allWidgets
WHERE allWidgets.widget = purchasing.widgetIDP;

ALTER TABLE purchasing ALTER COLUMN widgetIDP TYPE integer USING widgetIDP::integer;
ALTER TABLE purchasing ADD CONSTRAINT fkaw FOREIGN KEY (widgetIDP) REFERENCES allWidgets (widgetID);

CREATE TABLE SKUs (
   skuID serial,
   widgetIDS varchar,
   Packaging varchar,
   PRIMARY KEY (skuID)
);

INSERT INTO SKUs (widgetids, packaging)
SELECT TRIM(BOTH FROM Widget), TRIM(BOTH FROM Packaging) FROM widgets1 GROUP BY TRIM(BOTH FROM Widget), TRIM(BOTH FROM Packaging);

UPDATE SKUs
SET widgetIDS = allWidgets.widgetID
FROM allWidgets
WHERE allWidgets.widget = SKUs.widgetIDS;

ALTER TABLE SKUs ALTER COLUMN widgetIDS TYPE integer USING widgetIDS::integer;
ALTER TABLE SKUs ADD CONSTRAINT fkaw FOREIGN KEY (widgetIDS) REFERENCES allWidgets (widgetID);

CREATE TABLE Orders (
   orderID serial,
   customer varchar,
   price money,
   quantity integer,
   widgetIDO varchar,
   packaging varchar,
   skuID integer,
   PRIMARY KEY (orderID)
);

INSERT INTO Orders (customer, price, quantity, widgetIDO, packaging)
SELECT TRIM(BOTH FROM Customer), Price, Quantity, TRIM(BOTH FROM Widget), TRIM(BOTH FROM Packaging) FROM widgets1;

UPDATE Orders
SET widgetIDO = allWidgets.widgetID
FROM allWidgets
WHERE allWidgets.widget = Orders.widgetIDO;

ALTER TABLE Orders ALTER COLUMN widgetIDO TYPE integer USING widgetIDO::integer;

UPDATE Orders
SET skuID = SKUs.skuID
FROM SKUs
WHERE SKUs.WidgetIDS = Orders.widgetIDO AND SKUs.Packaging = orders.packaging;

ALTER TABLE Orders ADD CONSTRAINT fkaw FOREIGN KEY (skuID) REFERENCES SKUs (skuID);

ALTER TABLE Orders DROP widgetIDO;
ALTER TABLE Orders DROP packaging;

DROP TABLE widgets1;

CREATE VIEW SummaryRevenue AS SELECT SUM(price) FROM Orders;

CREATE VIEW ListSuppliers AS SELECT supplier FROM purchasing GROUP BY supplier;

/* This ties allWidgets the table Orders and EditOrderQuantity together such that updating (or adding or removing) from one alters the other */
CREATE VIEW EditOrderQuantity AS SELECT quantity FROM Orders;

/* UPDATE EditOrderQuantity SET quantity = 201 WHERE quantity = 200; 
   This updates all the order quantites in both table and view that were 200 to 201
*/

/* This ties allWidgets the table allwidgets and CreateWidgets together such that adding or removing from one alters the other */
CREATE VIEW CreateWidgets AS SELECT widget from allwidgets;

/* Adds new value to table which will be in createwidgets
   INSERT INTO allwidgets (widgetID, widget) VALUES(6, 'Trex Trap');

   Removes that row from view (CreateWidgets) and at the same time from table (allWidgets)
   DELETE FROM CreateWidgets WHERE widget = 'Trex Trap'; */







