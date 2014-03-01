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
update loans set Ddate= NEW.Sdate+(select loanduration from items,loans where items.IID=NEW.IID) where CID=NEW.CID and IID=NEW.IID;
update loans set loanID=((Select count (*) from loans)+1) where CID=NEW.CID and IID=NEW.IID;
update items set available= FALSE where items.IID=NEW.IID;
end;

/* Create trigger loansetting3
after insert on loans
for each row
WHEN ((Select available from items where items.IID=NEW.IID) AND (exists(Select * from reserve where reserve.CID= NEW.CID and reserve.IID=NEW.IID)))
begin
delete from reserve where (select GID from items where IID=NEW.IID)= NEW.GID AND CID=NEW.CID;
end; */
