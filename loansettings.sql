/* CREATE trigger loansetting1
after insert on loans
for each row 
WHEN ((Select available from items where IID=NEW.IID)=0)
begin
delete from loans where IID= NEW.IID AND CID=NEW.CID;
end; */

create trigger loansetting2
after insert on loans
for each row
/* WHEN ((Select available from items where IID=NEW.IID)=1) */
begin
delete from loans where IID= NEW.IID AND CID=NEW.CID and ((Select available from items where IID=NEW.IID)=0);
update loans set Sdate=(SELECT date('now')) where CID=NEW.CID and IID=NEW.IID AND ((Select available from items where IID=NEW.IID)=1);
update loans set Ddate= (select date(julianday('now')+(select loanduration from items where items.IID=NEW.IID))) where CID=NEW.CID and IID=NEW.IID and ((Select available from items where IID=NEW.IID)=1);
update loans set loanID=((Select count (*) from loans)) where CID=NEW.CID and IID=NEW.IID and ((Select available from items where IID=NEW.IID)=1);
update items set available= 0 where items.IID=NEW.IID and ((select returned from loans where IID=new.IID)=0));
end;





/* CREATE trigger loansetting1
after insert on loans
for each row 
--WHEN (NOT(Select available from items where IID=NEW.IID))
when('false')
begin
delete from loans where IID= NEW.IID AND CID=NEW.CID;
end; */

/* create trigger loansetting2
after insert on loans
for each row
WHEN ((SELECT available from items where IID=NEW.IID)='TRUE')
--when(NEW.IID>1)
begin
update loans set Sdate=(SELECT date('now')) where CID=NEW.CID and IID=NEW.IID;
update loans set Ddate= (select date(julianday('now')+(select loanduration from items where items.IID=NEW.IID))) where CID=NEW.CID and IID=NEW.IID;
update loans set loanID=(Select count (*) from loans) where CID=NEW.CID and IID=NEW.IID;
update items set available= 'FALSE' where items.IID=NEW.IID;
end; */

/* create trigger ls
after insert on loans
for each row
--WHEN ((SELECT available from items where IID=NEW.IID)='TRUE')
begin
--delete from loans where IID= NEW.IID AND CID=NEW.CID AND  (SELECT available from items where IID=NEW.IID)=0;
update loans set Sdate=(SELECT date('now')) where CID=NEW.CID and IID=NEW.IID and (SELECT available from items where IID=NEW.IID)=1;
update loans set Ddate= (select date(julianday('now')+(select loanduration from items where items.IID=NEW.IID))) where CID=NEW.CID and IID=NEW.IID and (SELECT available from items where IID=NEW.IID)=1;
update loans set loanID=(Select count (*) from loans) where CID=NEW.CID and IID=NEW.IID and (SELECT available from items where IID=NEW.IID)=0;
update items set available= 0 where items.IID=NEW.IID and (SELECT available from items where IID=NEW.IID)=1;
end;  */

/* create trigger ls
after insert on loans
for each row
begin
case select available from items where IID=NEW.IID;
when 0 then (delete from loans where IID= NEW.IID AND CID=NEW.CID)
when 1 then (update loans set Sdate=(SELECT date('now')) where CID=NEW.CID and IID=NEW.IID)
when 1 then (update loans set Ddate= (select date(julianday('now')+(select loanduration from items where items.IID=NEW.IID))) where CID=NEW.CID and IID=NEW.IID)
when 1 then (update loans set loanID=(Select count (*) from loans) where CID=NEW.CID and IID=NEW.IID)
when 1 then (update items set available= 0 where items.IID=NEW.IID)
END;
end; */
