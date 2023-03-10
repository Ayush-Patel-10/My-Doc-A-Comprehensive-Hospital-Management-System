use mydoc;
drop procedure if exists onCallDoctors;
delimiter $$
create procedure onCallDoctors( in doctor_id_p int,  in appointment_date_p date ,in appointment_time_p varchar(255) , out status_message varchar(255))
docktorWorking:begin
    
    set @doctors_on_call = doctor_id_p;
    set @curr = appointment_time_p;
    set @workDay =  concat(lower(dayname(appointment_date_p)),"_work");
    
     if @workDay = 'sunday_work' or @workDay = 'saturday_work' then
        set status_message = "Doctor Not Available(Weekend)";
        leave docktorWorking;
	end if;
    
    set @isWorkingToday = false;
    prepare query1 from 'select if(doctor_id=null,false,true) into @isWorkingToday from doc_schedule where doctor_id = ? and ? = 0 and ( (?) > time(shift_start) or (?) < time(shift_end))';
    execute query1 using @doctors_on_call,@workDay,@curr, @curr;
    
    if @isWorkingToday = true then
    set status_message = "Doctor is Working Now";
    else
    set status_message = "Doctor is not working Now";
    end if;
    
    deallocate prepare query1;
    
    select status_message;
end;

set @status_message = "";
call onCallDoctors(3,"2022-11-30","18:00:00",@status_message);
select @status_message;

-- select @status_code , @message;