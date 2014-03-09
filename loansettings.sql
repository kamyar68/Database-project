CREATE trigger loansetting1
after insert on loans
for each row 
WHEN (NOT(Select available from items where items.IID=NEW.IID))
begin
delete from loans where IID= NEW.IID AND CID=NEW.CID;
end;

create trigger loansetting2
after insert on loans
for each row
WHEN (SELECT available from items where items.IID=NEW.IID)
begin
update loans set Sdate=(SELECT date('now')) where CID=NEW.CID and IID=NEW.IID;
update loans set Ddate= select date(NEW.Sdate, '+(select loanduration from items,loans where items.IID=NEW.IID) where CID=NEW.CID and IID=NEW.IID day');
update loans set loanID=((Select count (*) from loans)+1) where CID=NEW.CID and IID=NEW.IID;
update items set available= FALSE where items.IID=NEW.IID;
end;


