-- Dropping Constraints
ALTER TABLE Laptop DROP FOREIGN KEY laptop_ibfk_1;
ALTER TABLE PC DROP FOREIGN KEY pc_ibfk_1;
ALTER TABLE Printer DROP FOREIGN KEY printer_ibfk_1;
ALTER TABLE Product DROP PRIMARY KEY;
-- Adding Entries
--Product
INSERT INTO Product (maker,model,type) VALUES('Z',1014,'pc');
INSERT INTO Product (maker,model,type) VALUES('Z',2015,'laptop');
INSERT INTO Product (maker,model,type) VALUES('Z',3016,'printer');
INSERT INTO Product (maker,model,type) VALUES('ZZ',9000,'pc');
INSERT INTO Product (maker,model,type) VALUES('ZZ',9001,'laptop');
INSERT INTO Product (maker,model,type) VALUES('ZZ',9002,'printer');
--PC
INSERT INTO PC (model,speed,ram,hd,price) VALUES(1014,1.0,256,1024,800);
INSERT INTO PC (model,speed,ram,hd,price) VALUES(9000,-1.0,256,1024,800);
--Laptop
INSERT INTO Laptop (model,speed,ram,hd,screen,price) VALUES(2015,4.0,512,512,13.3,5000);
INSERT INTO Laptop (model,speed,ram,hd,screen,price) VALUES(9001,1.0,256,256,20.3,2000);
--Printer
INSERT INTO Printer (model,color,type,price) VALUES(3016,'False','bubble-jet',500);
INSERT INTO Printer (model,color,type,price) VALUES(9002,'True','bobble-jet',1000);

-- Creating a SAVEPOINT
START TRANSACTION;
SAVEPOINT SavePoint1;

DELETE FROM Laptop WHERE speed < 2.0;
DELETE FROM Printer WHERE type NOT IN ('laser','ink-jet','bubble-jet');
DELETE FROM Product WHERE type NOT IN ('pc','laptop','printer');

START TRANSACTION;
SAVEPOINT SavePoint2;
--COMMIT changes Releases Savepoints
COMMIT;

ALTER TABLE Laptop ADD CONSTRAINT SpeedCheck CHECK (speed >=2.0);
ALTER TABLE Printer ADD CONSTRAINT PrinterCheck CHECK (type IN ('laser', 'ink-jet','bubble-jet'));
ALTER TABLE Product ADD Constraint ProductCheck CHECK (type IN ('pc', 'laptop', 'printer'));

ALTER TABLE Product ADD PRIMARY KEY(model);
ALTER TABLE PC ADD FOREIGN KEY (model) REFERENCES Product (model);

ALTER TABLE Laptop ADD FOREIGN KEY (model) REFERENCES Product (model);

ALTER TABLE Printer ADD FOREIGN KEY (model) REFERENCES Product (model);

--CREATING TRIGGER TO CHECK FOR NEGATIVE VALUES
CREATE TRIGGER Negative_PC_Speed
BEFORE INSERT ON PC
FOR EACH ROW
SET NEW.speed = ABS(NEW.speed);

--Test for Negative Input Value
--INSERT INTO PC (model,speed,ram,hd,price) VALUES(1013,-9.99,512,80,529);