use mydoc;
drop function if exists billTotal;

delimiter $$
create function billTotal( user_id int ) 
returns float
deterministic
begin
	declare amount float;
    
    select sum(p.fees)into amount from payments p, pay_card pc, user_card uc where uc.user_id = user_id and uc.card_details_id = pc.card_details_id and pc.payment_id = p.payment_id group by uc.user_id;

	return amount;
end $$
delimiter ;

set @totalBill = billTotal(3);

