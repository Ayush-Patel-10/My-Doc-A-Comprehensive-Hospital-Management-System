use mydoc;
drop function if exists numAppointmentsToday;

delimiter $$
create function numAppointmentsToday( today_date date , hospital_id int)
returns int
deterministic
begin
	declare count_appointments int;
	select count(*) into count_appointments from appointments a , appointment_details as ad where a.appointment_id = ad.appointment_id and ad.hospital_id = hospital_id;
    return count_appointments;

end $$
delimiter ;

set @todaysAppointments = numAppointmentsToday("2022-11-30",3);
select @todaysAppointments as "Number of appointments today";