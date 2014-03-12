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

