use mydoc;
drop function if exists medicine_amt;
delimiter $$

create function medicine_amt(medicine_id int)
returns int
deterministic
begin
	declare total_medicine_amt int;
    
    select sum(pres_med.daily_doses*pres_med.number_of_days) into total_medicine_amt
	from pres_med
	where pres_med.medicine_id = medicine_id;
    
    return total_medicine_amt;
    
end $$

delimiter ;

select medicine_amt(1) as 'Total number of medicines consumed of a particular medicine type'; 