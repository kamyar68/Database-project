create trigger ret1
after insert on returning
for each row
begin
update returning set retdate=(SELECT date('now')) where loanID=NEW.loanID;
update items set available=1 where IID= (select IID from loans where loans.loanID=NEW.loanID);
update loans set returned=1 where loans.loanID=NEW.loanID;
end;



create trigger ret2
after insert on returning
for each row
when(abs((select julianday('now')) - (select julianday(Sdate) from loans where loanID=NEW.loanID))> (select loanduration from items where IID=(select IID from loans where loanID=NEW.loanID)))

begin
insert into fee values('Delayed loan',NEW.loanID,1*(abs((select julianday('now')) - (select julianday(Sdate) from loans where loans.loanID=NEW.loanID)) - (select loanduration from items where IID= (select IID from loans where loans.loanID=NEW.loanID))),'pending');
update loans set returned=1 where loans.loanID=NEW.loanID;
end;


-- select Sdate from loans where loanID=NEW.loanID
--select Sdate from loans where loans.loandID=NEW.loanID

--abs(select julianday('now')-julianday('2014-01-01')