create trigger ret1
after insert on ret
for each row
begin
update ret set retdate=(SELECT date('now')) where loanID=NEW.loanID;
update items set available=TRUE where IID= (select IID from loans where loans.loanID=NEW.loandID);
end;


create trigger ret2
after insert on ret
for each row
when(((SELECT date('now')) - (select Sdate from loans where loanID=NEW.loanID))> (select loanduration from items where IID=(select IID from loans where loanID=NEW.loanID)))
begin
insert into fee values('Reservation',NEW.loanID,1*((retdate - (select Sdate from loans where loans.loandID=NEW.loanID)) - (select loanduration from items where IID= (select IID from loans where loans.loanID=NEW.loanID))),'Pending');
end;