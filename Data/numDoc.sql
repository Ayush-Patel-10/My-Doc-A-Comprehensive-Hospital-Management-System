use mydoc;
drop procedure if exists numDoctors;

delimiter $$
create procedure numDoctors( in appointment_date_p date , out numberOfDoctors int)
numDoctors:begin
    set @workDay =  concat(lower(dayname(appointment_date_p)),"_work");
    
     if @workDay = 'sunday_work' or @workDay = 'saturday_work' then
        set numberOfDoctors = 0;
        leave numDoctors;
	end if;
    
    select @workDay;
    set @countDoctors = 0;
    
	 if @workDay = 'monday_work' then
		prepare query1 from 'select count(*) into @countDoctors from doc_schedule where monday_work = true';
		execute query1;
	end if;
        
	 if @workDay = 'tuesday_work' then
		prepare query1 from 'select count(*) into @countDoctors from doc_schedule where tuesday_work = true';
		execute query1;
	 end if;
        
	 if @workDay = 'wednesday_work' then
		prepare query1 from 'select count(*) into @countDoctors from doc_schedule where wednesday_work = true';
		execute query1;
	end if;
        
	 if @workDay = 'thursday_work' then
		prepare query1 from 'select count(*) into @countDoctors from doc_schedule where thursday_work = true';
		execute query1;
	end if;
        
	 if @workDay = 'friday_work' then
		prepare query1 from 'select count(*) into @countDoctors from doc_schedule where friday_work = true';
		execute query1;        
	 end if;
    
    set numberOfDoctors = @countDoctors;
    
    select numberOfDoctors as "Number of Doctors Working";
end;

set @numData = 0;
call numDoctors("2022-12-06",@numData);
select @numData;