BEGIN TRANSACTION;
DROP TABLE IF EXISTS "Inventory";
CREATE TABLE IF NOT EXISTS "Inventory" (
	"InventoryName"	TEXT NOT NULL,
	"Place"	TEXT,
	"InventoryParent"	TEXT,
	PRIMARY KEY("InventoryName")
);
DROP TABLE IF EXISTS "InventoryItem";
CREATE TABLE IF NOT EXISTS "InventoryItem" (
	"InventoryName"	VARCHAR(255) NOT NULL,
	"ItemName"	VARCHAR(255) NOT NULL,
	"QuantityAsNumber"	INT,
	"QuantityAsWeight"	REAL,
	PRIMARY KEY("InventoryName","ItemName"),
	FOREIGN KEY("InventoryName") REFERENCES "Inventory"("InventoryName"),
	FOREIGN KEY("ItemName") REFERENCES "Item_old"("ItemName")
);
DROP TABLE IF EXISTS "Transfer";
CREATE TABLE IF NOT EXISTS "Transfer" (
	"TransferID"	INTEGER,
	"Date"	DATE,
	"Time"	TIME,
	"QuantityAsNumber"	INTEGER,
	"QuantityAsWeight"	INT,
	"ItemName"	TEXT NOT NULL,
	"SourceInventoryName"	TEXT NOT NULL,
	"DestinationInventoryName"	TEXT NOT NULL,
	PRIMARY KEY("TransferID"),
	FOREIGN KEY("SourceInventoryName") REFERENCES "Inventory"("InventoryName"),
	FOREIGN KEY("DestinationInventoryName") REFERENCES "Inventory"("InventoryName"),
	FOREIGN KEY("ItemName") REFERENCES "Item_old"("ItemName")
);
DROP TABLE IF EXISTS "InventoryFlowInOut";
CREATE TABLE IF NOT EXISTS "InventoryFlowInOut" (
	"FlowID"	INTEGER,
	"ItemName"	VARCHAR(255) NOT NULL,
	"QuantityAsNumber"	INTEGER,
	"QuantityAsWeight"	REAL,
	"Date"	DATE NOT NULL,
	"Time"	TIME NOT NULL,
	"InventoryName"	VARCHAR(255) NOT NULL,
	"FlowType"	VARCHAR(255) NOT NULL,
	"SourceOrDestination"	VARCHAR(255),
	"Notes"	TEXT,
	PRIMARY KEY("FlowID" AUTOINCREMENT),
	FOREIGN KEY("ItemName") REFERENCES "Item_old"("ItemName"),
	FOREIGN KEY("InventoryName") REFERENCES "Inventory"("InventoryName")
);
DROP TABLE IF EXISTS "Item_old";
CREATE TABLE IF NOT EXISTS "Item_old" (
	"ItemName"	VARCHAR(255) NOT NULL,
	"Category"	VARCHAR(255),
	"SbCategory"	VARCHAR(255),
	"QuantityType"	TEXT,
	"QuantityPerCarton"	INTEGER,
	PRIMARY KEY("ItemName")
);
DROP TABLE IF EXISTS "ManufacturingProcess";
CREATE TABLE IF NOT EXISTS "ManufacturingProcess" (
	"ManufacturingID"	INTEGER,
	"ItemName"	VARCHAR(255) NOT NULL,
	"QuantityAsNumber"	REAL,
	"QuantityAsWeight"	REAL,
	"ManufacturingType"	VARCHAR(255) NOT NULL,
	"ManufacturingStartDate"	DATE,
	"ManufacturingStartTime"	TIME,
	"ManufacturingEndDate"	DATE,
	"ManufacturingEndTime"	TIME,
	"OperationName"	VARCHAR(255) NOT NULL,
	"InventoryName"	VARCHAR(255) NOT NULL,
	"Notes"	TEXT,
	"ParentManufacturingID"	INTEGER,
	PRIMARY KEY("ParentManufacturingID"),
	FOREIGN KEY("InventoryName") REFERENCES "Inventory"("InventoryName"),
	FOREIGN KEY("ItemName") REFERENCES "Item_old"("ItemName")
);
DROP TABLE IF EXISTS "Item";
CREATE TABLE IF NOT EXISTS "Item" (
	"ItemName"	VARCHAR(255) NOT NULL,
	"Category"	VARCHAR(255),
	"SbCategory"	VARCHAR(255),
	"QuantityType"	TEXT CHECK("QuantityType" IN ('number', 'Weight')),
	"QuantityPerCarton"	INTEGER,
	PRIMARY KEY("ItemName")
);
INSERT INTO "Inventory" ("InventoryName","Place","InventoryParent") VALUES ('Warehouse C','Industrial Park',NULL),
 ('Retail Store D','Shopping Mall','City Center'),
 ('Warehouse D','Harbor',NULL);
INSERT INTO "InventoryItem" ("InventoryName","ItemName","QuantityAsNumber","QuantityAsWeight") VALUES ('Warehouse C','Product Y',-575,450.0),
 ('Retail Store D','Product W',3200,100.0),
 ('Warehouse D','Product Z',760,501.55);
INSERT INTO "Transfer" ("TransferID","Date","Time","QuantityAsNumber","QuantityAsWeight","ItemName","SourceInventoryName","DestinationInventoryName") VALUES (1,'2023-05-02','08:00:00',20,50,'Product Z','Warehouse C','Warehouse D'),
 (2,'2023-05-02','08:00:00',20,50.5,'Product Z','Warehouse C','Warehouse D'),
 (3,'2023-05-02','08:00:00',20,50.55,'Product Z','Warehouse C','Warehouse D'),
 (4,'2023-05-05','18:47:05',100,50,'Product W','Warehouse D','Retail Store D'),
 (5,'2023-05-05','18:47:05',100,50,'Product W','Warehouse D','Retail Store D'),
 (6,'2023-05-05','18:47:05',1000,50,'Product W','Warehouse D','Retail Store D'),
 (7,'2023-05-05','18:47:05',1000,50,'Product W','Warehouse D','Retail Store D'),
 (8,'2023-05-05','18:47:05',1000,50,'Product W','Warehouse D','Retail Store D'),
 (9,'2023-05-05','18:47:05',1000,50,'Product W','Warehouse D','Retail Store D');
INSERT INTO "InventoryFlowInOut" ("FlowID","ItemName","QuantityAsNumber","QuantityAsWeight","Date","Time","InventoryName","FlowType","SourceOrDestination","Notes") VALUES (1,'Product W',5,NULL,'2023-05-05','12:00:00','Retail Store D','input','Supplier A','Received 5 units of Widget A from Supplier A'),
 (2,'Product Z',3,NULL,'2023-05-06','9:00:00','Warehouse C','output','Customer A','Sold 3 units of Widget A to Customer A'),
 (3,'Product W',300,NULL,'2023-05-05','12:00:00','Retail Store D','input','Supplier A','Received 5 units of Widget A from Supplier A'),
 (4,'Product Z',80,0.5,'2023-05-06','9:00:00','Warehouse C','output','Customer A','Sold 3 units of Widget A to Customer A'),
 (5,'Product W',300,NULL,'2023-05-05','12:00:00','Retail Store D','input','Supplier A','Received 5 units of Widget A from Supplier A'),
 (6,'Product Z',80,0.5,'2023-05-06','9:00:00','Warehouse C','output','Customer A','Sold 3 units of Widget A to Customer A'),
 (7,'Product W',300,NULL,'2023-05-05','12:00:00','Retail Store D','input','Supplier A','Received 5 units of Widget A from Supplier A'),
 (8,'Product Z',80,0.5,'2023-05-06','9:00:00','Warehouse D','output','Customer A','Sold 3 units of Widget A to Customer A'),
 (9,'Product W',300,NULL,'2023-05-05','12:00:00','Retail Store D','input','Supplier A','Received 5 units of Widget A from Supplier A'),
 (10,'Product Z',80,0.5,'2023-05-06','9:00:00','Warehouse C','output','Customer A','Sold 3 units of Widget A to Customer A'),
 (11,'Product Y',100,50.0,'2023-05-05','18:47:05','Warehouse C','input','dali',NULL),
 (12,'Product Y',275,50.0,'2023-05-05','18:47:05','Warehouse C','input','dali',NULL),
 (13,'Product Y',275,50.0,'2023-05-05','18:47:05','Warehouse C','output','dali',NULL),
 (14,'Product Y',275,50.0,'2023-05-05','18:47:05','Warehouse C','output','dali',NULL),
 (15,'Product Y',275,50.0,'2023-05-05','18:47:05','Warehouse C','output','dali',NULL);
INSERT INTO "Item_old" ("ItemName","Category","SbCategory","QuantityType","QuantityPerCarton") VALUES ('Product Y','Clothing','Shirts','number',18),
 ('Product Z','Home and Garden','Furniture','number',1),
 ('Product W','Electronics','Laptops','number',12),
 ('Product WS','Electronics','Laptops','number',12),
 ('Product ZS','Home and Garden','Furniture','number',1),
 ('Product WSS','Electronics','Laptops','number',12),
 ('Product WSSS','Electronics','Laptops','number',12),
 ('Product ZSS','Home and Garden','Furniture','number',1),
 ('Product ZSSS','Home and Garden','Furniture','number',1),
 ('Product YS','Clothing','Shirts','number',18),
 ('Product ZSSSS','Home and Garden','Furniture','number',1);
INSERT INTO "ManufacturingProcess" ("ManufacturingID","ItemName","QuantityAsNumber","QuantityAsWeight","ManufacturingType","ManufacturingStartDate","ManufacturingStartTime","ManufacturingEndDate","ManufacturingEndTime","OperationName","InventoryName","Notes","ParentManufacturingID") VALUES (1,'Product Y',20.0,100.0,'input','2023-05-04','09:00:00',NULL,NULL,'Production','Warehouse C',NULL,1),
 (1,'Product Y',25.0,50.0,'input','2023-05-04','09:00:00',NULL,NULL,'Production','Warehouse C',NULL,2),
 (1,'Product Y',25.0,50.0,'output','2023-05-04','09:00:00',NULL,NULL,'Production','Warehouse C',NULL,3),
 (1,'Product Y',25.0,50.0,'output','2023-05-04','09:00:00',NULL,NULL,'Production','Warehouse C',NULL,4),
 (1,'Product Y',25.0,50.0,'output','2023-05-04','09:00:00',NULL,NULL,'Production','Warehouse C',NULL,5),
 (1,'Product Y',20.0,100.0,'input','2023-05-04','09:00:00',NULL,NULL,'Production','Warehouse C',NULL,6),
 (1,'Product Y',20.0,100.0,'input','2023-05-04','09:00:00',NULL,NULL,'Transform','Warehouse C',NULL,7),
 (1,'Product Y',20.0,100.0,'input','2023-05-04','09:00:00',NULL,NULL,'Transform','Warehouse C',NULL,8),
 (1,'Product Y',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'Transform','Warehouse C',NULL,9),
 (1,'Product Y',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'Transform','Warehouse C',NULL,10),
 (1,'Product Y',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'Transform','Warehouse C',NULL,11),
 (1,'Product Y',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'Transform','Warehouse C',NULL,12),
 (1,'Product Y',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'Transform','Warehouse C',NULL,13),
 (1,'Product Y',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'Transform','Warehouse C',NULL,14),
 (1,'Product Y',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'Transform','Warehouse C',NULL,15),
 (1,'Product W',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'Transform','Warehouse C',NULL,16),
 (1,'Product W',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'Transform','Warehouse C',NULL,17),
 (1,'Product W',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,18),
 (1,'Product W',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,19),
 (1,'Product W',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,20),
 (1,'Product W',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,21),
 (1,'Product W',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,22),
 (NULL,'Product WS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,23),
 (NULL,'Product WSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,24),
 (NULL,'Product WS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,25),
 (NULL,'Product WSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,26),
 (1,'Product Z',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,27),
 (NULL,'Product ZS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,28),
 (NULL,'Product ZSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,29),
 (NULL,'Product ZS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,30),
 (NULL,'Product ZSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,31),
 (1,'Product Z',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,32),
 (NULL,'Product ZS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,33),
 (NULL,'Product ZSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,34),
 (NULL,'Product ZS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,35),
 (NULL,'Product ZSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,36),
 (1,'Product W',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,37),
 (NULL,'Product WS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,38),
 (NULL,'Product WSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,39),
 (NULL,'Product WS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,40),
 (NULL,'Product WSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,41),
 (1,'Product W',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,42),
 (NULL,'Product WS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,43),
 (NULL,'Product WSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,44),
 (NULL,'Product WS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,45),
 (NULL,'Product WSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,46),
 (1,'Product W',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,47),
 (NULL,'Product WS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,48),
 (NULL,'Product WSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,49),
 (NULL,'Product WS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,50),
 (NULL,'Product WSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,51),
 (1,'Product Z',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,52),
 (NULL,'Product ZS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,53),
 (NULL,'Product ZSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,54),
 (NULL,'Product ZS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,55),
 (NULL,'Product ZSS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'transfer','Warehouse C',NULL,56),
 (1,'Product Z',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,57),
 (NULL,'Product ZS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,58),
 (1,'Product Z',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,59),
 (NULL,'Product ZS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,60),
 (1,'Product Z',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,61),
 (NULL,'Product ZS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,62),
 (1,'Product Z',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,63),
 (NULL,'Product ZS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,64),
 (1,'Product Z',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,65),
 (NULL,'Product ZS',NULL,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,66),
 (1,'Product Z',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,67),
 (NULL,'Product ZS',20.0,100.0,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,68),
 (1,'Product Y',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,69),
 (NULL,'Product YS',360.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,70),
 (1,'Product Z',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,71),
 (NULL,'Product ZS',NULL,100.0,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,72),
 (1,'Product Z',20.0,100.0,'output','2023-05-04','09:00:00',NULL,NULL,'transfer','Warehouse C',NULL,73),
 (NULL,'Product ZS',20.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,74),
 (NULL,'Product Z',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'Operation A','Warehouse D',NULL,75),
 (NULL,'Product Z',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'Operation A','Warehouse D',NULL,76),
 (NULL,'Product Z',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'Operation A','Warehouse D',NULL,77),
 (NULL,'Product Z',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'Operation A','Warehouse D',NULL,78),
 (NULL,'Product Z',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'Operation A','Warehouse D',NULL,79),
 (NULL,'Product Z',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'Transfer','Warehouse D',NULL,80),
 (NULL,'Product Z',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,81),
 (NULL,'Product ZS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,82),
 (NULL,'Product ZS',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,83),
 (NULL,'Product ZSS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,84),
 (NULL,'Product Z',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,85),
 (NULL,'Product ZS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,86),
 (NULL,'Product Z',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,87),
 (NULL,'Product ZS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,88),
 (5,'Product Z',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,89),
 (NULL,'Product ZS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,90),
 (5,'Product ZSS',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,91),
 (NULL,'Product ZSSS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,92),
 (5,'Product Y',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse C',NULL,93),
 (NULL,'Product YS',1800.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,94),
 (5,'Product Y',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse C',NULL,95),
 (NULL,'Product YS',1800.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,96),
 (5,'Product Y',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse C',NULL,97),
 (NULL,'Product YS',1800.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,98),
 (5,'Product Y',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse C',NULL,99),
 (NULL,'Product YS',1800.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,100),
 (5,'Product Y',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse C',NULL,101),
 (NULL,'Product YS',1800.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,102),
 (5,'Product Y',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse C',NULL,103),
 (NULL,'Product YS',1800.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,104),
 (5,'Product Y',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse C',NULL,105),
 (NULL,'Product YS',1800.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,106),
 (6,'Product Z',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse C',NULL,107),
 (NULL,'Product ZS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,108),
 (6,'Product Z',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse C',NULL,109),
 (NULL,'Product ZS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse C',NULL,110),
 (9,'Product Z',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Retail Store D',NULL,111),
 (NULL,'Product ZS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Retail Store D',NULL,112),
 (11,'Product ZSSS',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,113),
 (NULL,'Product ZSSSS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,114),
 (11,'Product ZSSS',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,115),
 (NULL,'Product ZSSSS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,116),
 (11,'Product ZSSS',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,117),
 (NULL,'Product ZSSSS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,118),
 (21,'Product ZSSS',100.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,119),
 (NULL,'Product ZSSSS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,120),
 (21,'Product ZSSS',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,121),
 (NULL,'Product ZSSSS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,122),
 (21,'Product ZSSS',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'trassdsnsfer','Warehouse D',NULL,123),
 (21,'Product ZSSS',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'Transfer','Warehouse D',NULL,124),
 (21,'Product ZSSS',100.0,50.0,'output','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,125),
 (NULL,'Product ZSSSS',100.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,126),
 (21,'Product ZSSS',11200.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,127),
 (NULL,'Product ZSSSS',11200.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,128),
 (21,'Product ZSSS',11200.0,50.0,'input','2023-05-05','08:00:00',NULL,NULL,'transfer','Warehouse D',NULL,129),
 (21,'Product ZSSSS',11200.0,NULL,'output',NULL,NULL,NULL,NULL,'not_transfer','Warehouse D',NULL,130);
INSERT INTO "Item" ("ItemName","Category","SbCategory","QuantityType","QuantityPerCarton") VALUES ('Product Y','Clothing','Shirts','number',18),
 ('Product Z','Home and Garden','Furniture','number',1),
 ('Product W','Electronics','Laptops','number',12),
 ('Product WS','Electronics','Laptops','number',12),
 ('Product ZS','Home and Garden','Furniture','number',1),
 ('Product WSS','Electronics','Laptops','number',12),
 ('Product WSSS','Electronics','Laptops','number',12),
 ('Product ZSS','Home and Garden','Furniture','number',1),
 ('Product ZSSS','Home and Garden','Furniture','number',1),
 ('Product YS','Clothing','Shirts','number',18);
DROP INDEX IF EXISTS "itemIndex";
CREATE INDEX IF NOT EXISTS "itemIndex" ON "Item_old" (
	"ItemName"
);
DROP TRIGGER IF EXISTS "update_inventory_item_TRAnsfer";
CREATE TRIGGER "update_inventory_item_TRAnsfer" AFTER INSERT ON "Transfer"
BEGIN
    UPDATE "InventoryItem"
    SET "QuantityAsNumber" = "QuantityAsNumber" - NEW."QuantityAsNumber",
        "QuantityAsWeight" = "QuantityAsWeight" - NEW."QuantityAsWeight"
    WHERE "InventoryName" = NEW."SourceInventoryName"
      AND "ItemName" = NEW."ItemName";
      
    UPDATE "InventoryItem"
    SET "QuantityAsNumber" = "QuantityAsNumber" + NEW."QuantityAsNumber",
        "QuantityAsWeight" = "QuantityAsWeight" + NEW."QuantityAsWeight"
    WHERE "InventoryName" = NEW."DestinationInventoryName"
      AND "ItemName" = NEW."ItemName";
END;
DROP TRIGGER IF EXISTS "UpdateInventoryItemFlowInOut";
CREATE TRIGGER "UpdateInventoryItemFlowInOut" AFTER INSERT ON "InventoryFlowInOut"
BEGIN
    UPDATE "InventoryItem"
    SET "QuantityAsNumber" = 
        CASE 
            WHEN NEW."FlowType" = 'output' THEN "QuantityAsNumber" - NEW."QuantityAsNumber"
            WHEN NEW."FlowType" = 'input' THEN "QuantityAsNumber" + NEW."QuantityAsNumber"
            ELSE "QuantityAsNumber"
        END,
        "QuantityAsWeight" =
        CASE
            WHEN NEW."FlowType" = 'output' THEN "QuantityAsWeight" - NEW."QuantityAsWeight"
            WHEN NEW."FlowType" = 'input' THEN "QuantityAsWeight" + NEW."QuantityAsWeight"
            ELSE "QuantityAsWeight"
        END
    WHERE "InventoryName" = NEW."InventoryName"
      AND "ItemName" = NEW."ItemName";
END;
DROP TRIGGER IF EXISTS "UpdateInventoryItemManufacturing";
CREATE TRIGGER "UpdateInventoryItemManufacturing" AFTER INSERT ON "ManufacturingProcess"
BEGIN
    UPDATE "InventoryItem"
    SET "QuantityAsNumber" = 
        CASE 
            WHEN NEW."ManufacturingType" = 'input' THEN "QuantityAsNumber" - NEW."QuantityAsNumber"
            WHEN NEW."ManufacturingType" = 'output' THEN "QuantityAsNumber" + NEW."QuantityAsNumber"
            ELSE "QuantityAsNumber"
        END,
        "QuantityAsWeight" =
        CASE
            WHEN NEW."ManufacturingType" = 'input' THEN "QuantityAsWeight" - NEW."QuantityAsWeight"
            WHEN NEW."ManufacturingType" = 'output' THEN "QuantityAsWeight" + NEW."QuantityAsWeight"
            ELSE "QuantityAsWeight"
        END
    WHERE "InventoryName" = NEW."InventoryName"
      AND "ItemName" = NEW."ItemName";
END;
DROP TRIGGER IF EXISTS "after_insert_ManufacturingProcess_combined";
CREATE TRIGGER after_insert_ManufacturingProcess_combined
AFTER INSERT
ON ManufacturingProcess
WHEN NEW.OperationName = 'transfer'
BEGIN
    INSERT INTO "Item_old" (ItemName, Category, SbCategory, QuantityType, QuantityPerCarton)
    SELECT (NEW.ItemName || 'S'), Category, SbCategory, QuantityType, QuantityPerCarton
    FROM "Item_old"
    WHERE ItemName = NEW.ItemName AND NOT EXISTS (SELECT 1 FROM "Item_old" WHERE ItemName = (NEW.ItemName || 'S'));

    INSERT INTO ManufacturingProcess (ItemName, ManufacturingType, QuantityAsNumber, QuantityAsWeight, OperationName, InventoryName,ManufacturingID)
    SELECT (NEW.ItemName || 'S'), 'output',
        CASE WHEN QuantityType = 'number' THEN NEW.QuantityAsNumber * QuantityPerCarton ELSE NULL END,
        CASE WHEN QuantityType = 'weight' THEN NEW.QuantityAsWeight * QuantityPerCarton ELSE NULL END,
        'not_transfer',
        NEW.InventoryName
		,NEW.ManufacturingID
    FROM "Item_old"
    WHERE ItemName = NEW.ItemName;
END;
COMMIT;
