--Michael Torres
--Creating Views and Cursors

--Creating a view joining Laptop and Product Tables
CREATE VIEW LaptopView
AS SELECT maker, b.type AS typeProd, a.model, speed, ram, hd, price
FROM Laptop a JOIN Product b
ON a.model=b.model;

--Creating a view joining PC and Product Tables
CREATE VIEW PCView
AS SELECT maker, b.type AS typeProd, a.model, speed, ram, hd, price
FROM PC a JOIN Product b
ON a.model=b.model;

--Creating a view joining Printer and Product Tables
CREATE VIEW PrinterView
AS SELECT maker, b.type AS typeProd, a.model, color, a.type, price
FROM Printer a, Product b
WHERE a.model=b.model;

-- PC List Cursor
DELIMITER $$
CREATE PROCEDURE createPCList (
	INOUT PCList varchar(4000)
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE makerCV VARCHAR(100) DEFAULT "";
    DECLARE typeCV VARCHAR(100) DEFAULT "";
    DECLARE modelCV INTEGER DEFAULT 0;
    DECLARE priceCV INTEGER DEFAULT 0;
	-- declare cursor for PCView
	DECLARE curPC CURSOR FOR SELECT maker, typeProd, model ,price FROM PCView;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curPC;

	getPC: LOOP
		FETCH curPC INTO makerCV, typeCV, modelCV, priceCV;
		IF finished = 1 THEN 
			LEAVE getPC;
		END IF;
		-- build PC Output List
		SET PCList = CONCAT(makerCV," - ",typeCV, " ", modelCV, " for $", priceCV,'\n', PCList );
	END LOOP getPC;
	CLOSE curPC;

END$$
DELIMITER ;
SET @PCList = ""; CALL createPCList(@PCList); SELECT @PCList;

--Printer Cursor
DELIMITER $$
CREATE PROCEDURE createPrinterList (
	INOUT PrinterList varchar(4000)
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE PrinterMakerCV VARCHAR(100) DEFAULT "";
    DECLARE PrinterTypeCV VARCHAR(100) DEFAULT "";
    DECLARE PrinterModelCV INTEGER DEFAULT 0;
    DECLARE PrinterPriceCV INTEGER DEFAULT 0;
	-- declare cursor for PrinterView
	DECLARE curPrinter CURSOR FOR SELECT maker, typeProd, model ,price FROM PrinterView;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curPrinter;

	getPrinter: LOOP
		FETCH curPrinter INTO PrinterMakerCV, PrinterTypeCV, PrinterModelCV, PrinterPriceCV;
		IF finished = 1 THEN 
			LEAVE getPrinter;
		END IF;
		-- build printer list
		SET PrinterList = CONCAT(PrinterMakerCV, " - ", PrinterTypeCV," ",PrinterModelCV, " for $", PrinterPriceCV,'\n', PrinterList );
	END LOOP getPrinter;
	CLOSE curPrinter;

END$$
DELIMITER ;

SET @PrinterList = ""; CALL createPrinterList(@PrinterList); SELECT @PrinterList;


-- Laptop Cursor 
DELIMITER $$
CREATE PROCEDURE createLaptopList (
	INOUT LaptopList varchar(4000)
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE LaptopMakerCV VARCHAR(100) DEFAULT "";
    DECLARE LaptopTypeCV VARCHAR(100) DEFAULT "";
    DECLARE LaptopModelCV INTEGER DEFAULT 0;
    DECLARE LaptopPriceCV INTEGER DEFAULT 0;
	-- declare cursor for LaptopView
	DECLARE curLaptop CURSOR FOR SELECT maker, typeProd, model ,price FROM LaptopView;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curLaptop;

	getLaptop: LOOP
		FETCH curLaptop INTO LaptopMakerCV,LaptopTypeCV, LaptopModelCV, LaptopPriceCV;
		IF finished = 1 THEN 
			LEAVE getLaptop;
		END IF;
		-- build laptop list
		SET LaptopList = CONCAT(LaptopMakerCV," -  ",LaptopTypeCV, " ", LaptopModelCV, " for $", LaptopPriceCV,'\n', LaptopList );
	END LOOP getLaptop;
	CLOSE curLaptop;

END$$
DELIMITER ;

SET @LaptopList = ""; CALL createLaptopList(@LaptopList); SELECT @LaptopList;

--Cursor With Laptop Parameters
DELIMITER $$
CREATE PROCEDURE createLaptopListPR (
	INOUT LaptopListPR varchar(4000)
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE LaptopMakerCV VARCHAR(100) DEFAULT "";
    DECLARE LaptopTypeCV VARCHAR(100) DEFAULT "";
    DECLARE LaptopModelCV INTEGER DEFAULT 0;
    DECLARE LaptopPriceCV INTEGER DEFAULT 0;
	-- declare cursor for LaptopView
	DECLARE curLaptop CURSOR FOR SELECT maker, typeProd, model ,price FROM LaptopView WHERE price>ram;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curLaptop;

	getLaptop: LOOP
		FETCH curLaptop INTO LaptopMakerCV, LaptopTypeCV, LaptopModelCV, LaptopPriceCV;
		IF finished = 1 THEN 
			LEAVE getLaptop;
		END IF;
		-- build laptop list
		SET LaptopListPR = CONCAT(LaptopMakerCV, " - ", LaptopTypeCV, " ",LaptopModelCV, " for $", LaptopPriceCV,'\n', LaptopListPR );
	END LOOP getLaptop;
	CLOSE curLaptop;

END$$
DELIMITER ;

SET @LaptopListPR = ""; CALL createLaptopListPR(@LaptopListPR); SELECT @LaptopListPR;

--Creating PC Cursor
DELIMITER $$
CREATE PROCEDURE createPCList2 (
	INOUT PCParameters varchar(4000)
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE makerCV VARCHAR(100) DEFAULT "";
    DECLARE typeCV VARCHAR(100) DEFAULT "";
    DECLARE modelCV INTEGER DEFAULT 0;
    DECLARE priceCV INTEGER DEFAULT 0;
	-- declare cursor for PCView
	DECLARE curPC CURSOR FOR SELECT maker, typeProd ,model ,price FROM PCView WHERE hd < 200 OR price > 1000;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curPC;

	getPC: LOOP
		FETCH curPC INTO makerCV, typeCV, modelCV, priceCV;
		IF finished = 1 THEN 
			LEAVE getPC;
		END IF;
		-- build PC Output List
		SET PCParameters = CONCAT(makerCV," - ", typeCV, " ", modelCV, " for $", priceCV,'\n', PCParameters );
	END LOOP getPC;
	CLOSE curPC;

END$$
DELIMITER ;

SET @PCParameters = ""; CALL createPCList2(@PCParameters); SELECT @PCParameters;


--Printer Cursor
DELIMITER $$
CREATE PROCEDURE createPrinterList2 (
	INOUT PrinterLaser varchar(4000)
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE PrinterMakerCV VARCHAR(100) DEFAULT "";
    DECLARE PrinterProdCV VARCHAR(100) DEFAULT "";
    DECLARE PrinterModelCV INTEGER DEFAULT 0;
    DECLARE PrinterPriceCV INTEGER DEFAULT 0;
    DECLARE PrinterTypeCV VARCHAR(100) DEFAULT "";
	-- declare cursor for PrinterView
	DECLARE curPrinter2 CURSOR FOR SELECT maker, typeProd, type, model ,price FROM PrinterView WHERE type='laser';

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curPrinter2;

	getPrinter2: LOOP
		FETCH curPrinter2 INTO PrinterMakerCV, PrinterProdCV, PrinterTypeCV, PrinterModelCV, PrinterPriceCV;
		IF finished = 1 THEN 
			LEAVE getPrinter2;
		END IF;
		-- build printer list
		SET PrinterLaser = CONCAT(PrinterMakerCV, " - ", PrinterProdCV, " ",PrinterModelCV, " for $", PrinterPriceCV,'\n', PrinterLaser );
	END LOOP getPrinter2;
	CLOSE curPrinter2;

END$$
DELIMITER ;

SET @PrinterLaser = ""; CALL createPrinterList2(@PrinterLaser); SELECT @PrinterLaser;


--Sale Cursor
DELIMITER $$
CREATE PROCEDURE createPCSale (
	INOUT PCSaleList varchar(4000)
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
    DECLARE SaleType  VARCHAR(100) DEFAULT "";
    DECLARE SaleModel INTEGER DEFAULT 0;


	-- declare cursor for PrinterView
	DECLARE curSale CURSOR FOR SELECT typeProd, model FROM PCView;


	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curSale;

	getPrinter2: LOOP
		FETCH curSale INTO SaleType, SaleModel;
		IF finished = 1 THEN 
			LEAVE getPrinter2;
		END IF;
		-- build PC Sale list
		SET PCSaleList = CONCAT( SaleType, " " ,SaleModel, " is on sale!", '\n', PCSaleList );
	END LOOP getPrinter2;


END$$
DELIMITER ;

SET @PCSaleList = ""; CALL createPCSale(@PCSaleList); SELECT @PCSaleList;


--Printer Sale Cursor
DELIMITER $$
CREATE PROCEDURE createPrinterSale (
	INOUT PrinterSaleList varchar(4000)
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
    DECLARE SaleType  VARCHAR(100) DEFAULT "";
    DECLARE SaleModel INTEGER DEFAULT 0;


	-- declare cursor for PrinterView
	DECLARE curSale CURSOR FOR SELECT typeProd, model FROM PrinterView;


	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curSale;

	getPrinter2: LOOP
		FETCH curSale INTO SaleType, SaleModel;
		IF finished = 1 THEN 
			LEAVE getPrinter2;
		END IF;
		-- build printer Sale list
		SET PrinterSaleList = CONCAT( SaleType, " " ,SaleModel, " is on sale!", '\n', PrinterSaleList );
	END LOOP getPrinter2;


END$$
DELIMITER ;

SET @PrinterSaleList = ""; CALL createPrinterSale(@PrinterSaleList); SELECT @PrinterSaleList;

DELIMITER $$
CREATE PROCEDURE createLaptopSale (
	INOUT LaptopSaleList varchar(4000)
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
    DECLARE SaleType  VARCHAR(100) DEFAULT "";
    DECLARE SaleModel INTEGER DEFAULT 0;


	-- declare cursor for PrinterView
	DECLARE curSale CURSOR FOR SELECT typeProd, model FROM LaptopView;


	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curSale;

	getPrinter2: LOOP
		FETCH curSale INTO SaleType, SaleModel;
		IF finished = 1 THEN 
			LEAVE getPrinter2;
		END IF;
		-- build printer list
		SET LaptopSaleList = CONCAT( SaleType, " " ,SaleModel, " is on sale!", '\n', LaptopSaleList );
	END LOOP getPrinter2;


END$$
DELIMITER ;

SET @LaptopSaleList = ""; CALL createLaptopSale(@LaptopSaleList); SELECT @LaptopSaleList;




SELECT * FROM PCView;
SELECT * FROM LaptopView;
SELECT * FROM PrinterView;
SET @PCList = ""; CALL createPCList(@PCList); SELECT @PCList;
SET @PrinterList = ""; CALL createPrinterList(@PrinterList); SELECT @PrinterList;
SET @LaptopList = ""; CALL createLaptopList(@LaptopList); SELECT @LaptopList;
SET @LaptopListPR = ""; CALL createLaptopListPR(@LaptopListPR); SELECT @LaptopListPR;
SET @PCParameters = ""; CALL createPCList2(@PCParameters); SELECT @PCParameters;
SET @PrinterLaser = ""; CALL createPrinterList2(@PrinterLaser); SELECT @PrinterLaser;
SET @PCSaleList = ""; CALL createPCSale(@PCSaleList); SELECT @PCSaleList;
SET @PrinterSaleList = ""; CALL createPrinterSale(@PrinterSaleList); SELECT @PrinterSaleList;
SET @LaptopSaleList = ""; CALL createLaptopSale(@LaptopSaleList); SELECT @LaptopSaleList;


