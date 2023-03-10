use mydoc;
drop procedure if exists bookAppointment;
delimiter $$
create procedure bookAppointment( in user_id_p int, in doctor_id_p int, in hospital_id_p int, 
								in appointment_time_p varchar(255), in appointment_date_p date , 
                                out status_code int , out status_message varchar(255))
MainAppointment:BEGIN
	declare qry varchar(255);
    declare isWorkingToday int;
    declare isWorklingNow int;
    declare workDay varchar(255);
    declare timeSlot time;

	set @user_id_p = user_id_p;
    set @hospital_id_p = hospital_id_p;

    set @workDay =  concat(lower(dayname(appointment_date_p)),"_work");
	set @doctor_id_p = doctor_id_p;
    set @appointment_time_p = appointment_time_p;
    set @appointment_date_p = appointment_date_p;
    
    if @workDay = 'sunday_work' or @workDay = 'saturday_work' then
		set status_code = -1;
        set status_message = "Doctor Not Available. Please Book for another time";
        leave MainAppointment;
	end if;
    
    -- set @start_time := 'select start_time from doc_schedule where doctor_id = ?'
    -- prepare query1 from 'select * from doc_schedule where doctor_id = ?';
	-- execute query1 using @doctor_id_p ;
	-- select shift_start from query1;
	set @isWorkingToday = false;
    prepare query0 from 'select if(doctor_id=null,false,true) into @isWorkingToday from doc_schedule where doctor_id = ? and ? = 0 and ( (?) > time(shift_start) or (?) < time(shift_end) )';
    execute query0 using @doctor_id_p, @workDay , @appointment_time_p, @appointment_time_p;
	DEALLOCATE PREPARE query0;

    if @isWorkingToday = false then
		set status_code = -1;
        set status_message = "Doctor Not Available. Please Book for another time";
        leave MainAppointment;
	else 
		-- select if(appt.id=null,false,true) into @isAppointmentThere from appointments as appt, appointment_details as apptd where appt.id = apptd.id and doctor_id = ? and appointment_date = ?  and appointment_time = ?
        set @isAppointmentThere = false;
		prepare query1 from 'select count(*) into @isAppointmentThere from appointments  appt, appointment_details  apptd where appt.appointment_id = apptd.appointment_id and apptd.doctor_id = ? and appt.appointment_date = cast( ? as Date)  and appt.appointment_time = ?';
		execute query1 using @doctor_id_p, @appointment_date_p, @appointment_time_p;
		DEALLOCATE PREPARE query1;
        
        
        if @isAppointmentThere = 0 then
			prepare query2 from 'insert into appointments(appointment_date,appointment_time) values (cast( ? as Date),?)';
			execute query2 using @appointment_date_p,@appointment_time_p;
            
            set @newAppointmentID = 0;
            SELECT LAST_INSERT_ID() into @newAppointmentID;
            
            prepare query3 from 'insert into appointment_details(appointment_id,user_id,doctor_id,hospital_id) values (?,?,?,?)';
			execute query3 using @newAppointmentID,@user_id_p,@doctor_id_p,@hospital_id_p;
            
			set status_code = 1;
			set status_message = "Doctor Available. Your appointment has been booked !!";
		else
			set status_code = -1;
			set status_message = "Doctor Not Available. Please Book for another time";
		end if;
	end if;
    
    select status_code as "Status Code" , status_message as "Status Message";
end;


#call bookAppointment(4,11,3,"17:00:00","2022-11-30",@status_code , @message);
#select @status_code , @message;
	
