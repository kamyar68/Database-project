create view itemstatus as
select GID, reservable
from items;

create trigger rs1
after insert on reserve
for each row
begin
update reserve set RID=(Select count (*) from reserve) where CID=NEW.CID and GID=NEW.GID;
update reserve set quepos=((Select count (*) from reserve where GID=NEW.GID)) where CID=NEW.CID and GID=NEW.GID and ((Select reservable from itemstatus where GID=NEW.GID)=1);
update reserve set resdate = (Select date('now')) where CID=NEW.CID and GID=NEW.GID;
delete from reserve where GID= NEW.GID AND CID=NEW.CID and ((Select reservable from itemstatus where GID=NEW.GID)=0);
end;


create trigger rs2
after insert on reserve
for each row
when ((Select reservable from itemstatus where GID=NEW.GID)=1)
begin
insert into fee values('Reservation', (Select count (*) from reserve),1,'pending');
end;