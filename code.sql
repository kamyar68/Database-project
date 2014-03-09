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