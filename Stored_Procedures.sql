
drop procedure if exists get_this_week_dates;
delimiter $$

create procedure get_this_week_dates(in cur_date date, out start_date date, out end_date date)

begin
    set start_date = DATE_ADD(cur_date, INTERVAL(-WEEKDAY(cur_date)) DAY);
    set end_date = DATE_ADD(cur_date, INTERVAL(6-WEEKDAY(cur_date)) DAY);
end $$

delimiter ;

call get_this_week_dates("2022-11-28",@start_date, @end_date);

drop view if exists this_week_appointments_mydoc;
create view this_week_appointments_mydoc as
(select hospitals.hospital_id, hospitals.name as 'Hospital Name', doctors.doctor_id, concat(u2.firstname, ' ',u2.lastname) as 'Doctor Name' , u1.user_id,concat(u1.firstname, ' ',u1.lastname) as 'Patient Name', appointments.appointment_id, appointments.appointment_date, appointments.appointment_time
from appointments,appointment_details, users u1, doctors, hospitals, users u2
where appointments.appointment_id = appointment_details.appointment_id and
	appointment_details.user_id = u1.user_id and
    appointment_details.doctor_id = doctors.doctor_id and 
    appointment_details.hospital_id = hospitals.hospital_id and 
    appointment_details.doctor_id = u2.user_id and
    appointments.appointment_date >= DATE_ADD(CURDATE(), INTERVAL(-WEEKDAY(CURDATE())) DAY) and
	appointments.appointment_date <= DATE_ADD(CURDATE(), INTERVAL(6-WEEKDAY(CURDATE())) DAY));


SELECT *
FROM this_week_appointments_mydoc;

drop view if exists previous_appointments_user;
create view previous_appointments_user as
(select appointments.appointment_id, appointments.appointment_date, appointments.appointment_time, concat(u2.firstname, ' ',u2.lastname) as 'Doctor Name', hospitals.name as 'Hospital Name'
from appointments, appointment_details,users u1,users u2, hospitals
where appointments.appointment_id = appointment_details.appointment_id and
		appointment_details.user_id = u1.user_id and
        appointment_details.doctor_id = u2.user_id and
        appointment_details.hospital_id = hospitals.hospital_id and
        u1.user_id = '1'
order by appointments.appointment_date,appointments.appointment_time desc);

SELECT *
FROM previous_appointments_user;

drop function if exists prescription_amt;
delimiter $$
create function prescription_amt(prescription_id int)
returns float
deterministic
begin
	declare total_presc_amt float;
    
	select sum(pres_med.daily_doses*pres_med.number_of_days*medicines.price_per_unit) into total_presc_amt
	from pres_med, medicines
	where pres_med.medicine_id = medicines.medicine_id and
			pres_med.prescription_id = prescription_id;
	
    return total_presc_amt;
end $$
delimiter ;

select prescription_amt('1');

drop function if exists lab_test_amt;
delimiter $$
create function lab_test_amt(lab_test_id int)
returns float
deterministic
begin
	declare total_lab_test_amt float;
    
	select sum(lab_test_description.price_per_lab) into total_lab_test_amt
	from lab, lab_test_description
	where lab.lab_test_description_id = lab_test_description.lab_test_description_id and
			lab.lab_test_id = lab_test_id;
	
    return total_lab_test_amt;
end $$
delimiter ;

select lab_test_amt('1');

drop function if exists visit_charges;
delimiter $$
create function visit_charges(appointment_id int)
returns float
deterministic
begin
	declare total_visit_amt float;
    
	select sum(appointment_fees) into total_visit_amt
	from diagnosis, appointment_details,doctors
	where diagnosis.appointment_id = appointment_details.appointment_id and
			appointment_details.doctor_id = doctors.doctor_id and 
			diagnosis.appointment_id = appointment_id;
	
    return total_visit_amt;
end $$
delimiter ;

select visit_charges('2');


drop trigger if exists payment_discount;
delimiter $$
create trigger payment_discount before update on payments 
for each row
begin
	
    if new.fees > '500' then
		set new.fees = new.fees - 0.1*new.fees;
	end if;
    
end $$
delimiter ;

drop trigger if exists update_bill;
delimiter $$
create trigger update_bill after insert on diagnosis 
for each row
begin

	declare presc_amt float;
    declare lab_amt float;
    declare visit_amt float;
    declare bill_id int;
    
    select appt_pay.payment_id into bill_id
    from appt_pay
    where appt_pay.appointment_id = new.appointment_id;

	select  prescription_amt(new.prescription_id) into presc_amt;
    
    select lab_test_amt(new.lab_test_id) into lab_amt;
    
    select visit_charges(new.appointment_id) into visit_amt;
    
    
    
    
	update payments 
	set fees = fees + presc_amt + lab_amt + visit_amt
	where payments.payment_id = bill_id;
    
end $$
delimiter ;


insert into diagnosis (appointment_id, prescription_id, lab_test_id) values (1, 1, 1);

#update payments set fees = '6000' where payment_id = '1';

drop view if exists generate_bill_view;
create view generate_bill_view as
(select appointments.appointment_id, appointments.appointment_date, appointments.appointment_time,
		concat(u1.firstname, ' ',u1.lastname) as 'patient_name',concat(u2.firstname, ' ',u2.lastname) as 'doctor_name', hospitals.name as 'hospital_name',
        visit_charges(diagnosis.appointment_id) as 'visit_charges',prescription_amt(diagnosis.prescription_id) as 'prescription_amt',lab_test_amt(diagnosis.lab_test_id) as 'lab_test_amt',
        payments.fees as 'final_bill'
from payments, appt_pay, appointments, diagnosis,appointment_details,hospitals,users u1, users u2
where payments.payment_id = appt_pay.payment_id and
		appt_pay.appointment_id = appointments.appointment_id and
        appointments.appointment_id = diagnosis.appointment_id and
        appointments.appointment_id = appointment_details.appointment_id and
        appointment_details.hospital_id = hospitals.hospital_id and
        appointment_details.user_id = u1.user_id and
        appointment_details.doctor_id = u2.user_id);


select *
from generate_bill_view;








        
