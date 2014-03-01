create trigger reservesetting1
after insert on reserve
for each row
WHEN (NOT(Select reservable from items where items.IID=NEW.IID))
begin
delete from reserve where IID= NEW.IID AND CID=NEW.CID;
end;

create trigger reservesetting2
after insert on reserve
for each row
when (Select reservable from items where items.IID=NEW.IID)
begin
update reserve set RID=((Select count (*) from reserve)+1) where CID=NEW.CID and IID=NEW.IID;
update reserve set quepos=((Select count (*) from reserve where reserve.IID=NEW.IID)) where CID=NEW.CID and IID=NEW.IID;
insert into fee values('Reservation',NEW.RID,1,'Pending');
end;

Create trigger moveque
after delete on reserve
for each row
begin
update reserve set quepos=quepos-1 where IID=old.IID;
end;

create Trigger quteTOloan
after update of quepos on reserve
for each row
when (((select qupos from reserve)=0) and (select available from items where IID=NEW.IID))
begin
delete from reserve where RID= (select RID from reserve where quepos=0;)
insert into loans ((111111, new.IID,NEW.CID,'date';,1111111);
end;