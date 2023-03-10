drop view if exists userInfo;
create view userInfo as ( select user_id, concat(firstname, ' ',lastname) as name, gender, date_of_birth, address,city,state,pincode, phone_number,email_id from users);

select * from userInfo;
