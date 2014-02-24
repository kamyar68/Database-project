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
update reserve set quepos=((Select count (*) from reserve where reserve.IID=NEW.IID)+1) where CID=NEW.CID and IID=NEW.IID;
insert into fee values('Reservation',NEW.RID,1,'Pending');
end;
