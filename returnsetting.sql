create trigger ret1
after insert on returning
for each row
begin
update ret set retdate=(SELECT date('now')) where loanID=NEW.loanID;
update items set available=TRUE where IID= (select IID from loans where loans.loanID=NEW.loandID);
end;



create trigger ret2
after insert on returning
for each row
when(SELECT abs(julianday('now') - julianday('date(select Sdate from loans where loanID=NEW.loanID)'))> (select loanduration from items where IID=(select IID from loans where loanID=NEW.loanID)))
--when (select abs(julianday('now')-julianday('2013-12-12'))>2)
begin
--insert into fee values('Reservation',NEW.loanID,1*((julianday('now') - julianday(select Sdate from loans where loans.loandID=NEW.loanID)) - (select loanduration from items where IID= (select IID from loans where loans.loanID=NEW.loanID))),'Pending');
insert into fee values('Reservation',NEW.loanID,1*(select julianday('now')-julianday('2014-01-01')-10),'Pending');
end;


-- select Sdate from loans where loanID=NEW.loanID
--select Sdate from loans where loans.loandID=NEW.loanID

--abs(select julianday('now')-julianday('2014-01-01')