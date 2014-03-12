CREATE TABLE library (
name CHAR(50),
address CHAR(100),
tel char(20),
PRIMARY KEY (name) 
);
CREATE TABLE customers (
CID INT,
name CHAR (50),
address CHAR (100),
tel char(20),
PRIMARY KEY (CID)
);
CREATE TABLE items(
IID INT,
GID INT,
available BOOLEAN,
item_type CHAR (20),
name CHAR(70),
author CHAR (50),
item_year INT,
loanduration INT,
reservable BOOLEAN,
homelib CHAR(50) REFERENCES library(homelib),
PRIMARY KEY (IID) 
);
CREATE TABLE loans (
loanID INT,
IID INT REFERENCES items(IID),
CID INT REFERENCES customers(CID),
Sdate DATE,
Ddate DATE,
PRIMARY KEY (loanID) 
);
CREATE TABLE reserve (
RID INT,
CID INT REFERENCES customers(CID),
GID INT,
DelivLib CHAR (50),
resdate DATE,
quepos INT,
PRIMARY KEY (RID) 
);
CREATE TABLE fee (
reason CHAR (20),
transID INT,
amount FLOAT,
status CHAR(40) CHECK(status IN ('paid','pending')),
PRIMARY KEY (reason, transID) 
);
CREATE TABLE returning (
loanID INT REFERENCES loans(loanID),
retdate DATE,
retlib CHAR (50) REFERENCES library(retlib),
PRIMARY KEY (loanID)
);
-- ---------------
CREATE trigger loansetting1
after insert on loans
for each row 
WHEN ((Select available from items where IID=NEW.IID)=0)
begin
delete from loans where IID= NEW.IID AND CID=NEW.CID;
end;

create trigger loansetting2
after insert on loans
for each row
WHEN (1=1)
begin
update loans set Sdate=(SELECT date('now')) where CID=NEW.CID and IID=NEW.IID;
update loans set Ddate= (select date(julianday('now')+(select loanduration from items where items.IID=NEW.IID))) where CID=NEW.CID and IID=NEW.IID;
update loans set loanID=((Select count (*) from loans)+1) where CID=NEW.CID and IID=NEW.IID;
update items set available= 0 where items.IID=NEW.IID;
end;
-- --------------------
create view itemstatus as
select GID, reservable
from items;

create trigger rs1
after insert on reserve
for each row
WHEN ((Select reservable from itemstatus where itemstatus.GID=NEW.GID)=0) 
begin
delete from reserve where GID= NEW.GID AND CID=NEW.CID;
end;

create trigger rs2
after insert on reserve
for each row
when ((Select reservable from itemstatus where items.GID=NEW.GID)=1)
begin
update reserve set RID=((Select count (*) from reserve)+1) where CID=NEW.CID and GID=NEW.GID;
update reserve set quepos=((Select count (*) from reserve where reserve.GID=NEW.GID)) where CID=NEW.CID and GID=NEW.GID;
insert into fee values('Reservation',NEW.RID,1,'Pending');
end;

Create trigger autoloan
after update of available on items
when ((new.available=1) and (NEW.GID in (select GID from reserve)))
begin
insert into loans values (1111, NEW.IID,(select CID from reserve where quepos=1 and GID=NEW.GID),'1999-12-12',2222);
delete from reserve where RID= NEW.RID;
update reserve set quepos=quepos-1 where GID=old.GID;
END;



-- --------------------------
create trigger ret1
after insert on returning
for each row
begin
update ret set retdate=(SELECT date('now')) where loanID=NEW.loanID;
update items set available=1 where IID= (select IID from loans where loans.loanID=NEW.loandID);
end;



create trigger ret2
after insert on returning
for each row
when(abs((select julianday('now')) - (select julianday(Sdate) from loans where loanID=NEW.loanID))> (select loanduration from items where IID=(select IID from loans where loanID=NEW.loanID)))

begin
insert into fee values('Reservation',NEW.loanID,1*(abs((select julianday('now')) - (select julianday(Sdate) from loans where loans.loandID=NEW.loanID)) - (select loanduration from items where IID= (select IID from loans where loans.loanID=NEW.loanID))),'Pending');

end;

.mode csv
.import items.csv items
.import library.csv library
.import customers.csv customers