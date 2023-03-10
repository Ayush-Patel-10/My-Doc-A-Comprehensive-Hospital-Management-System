drop database if exists mydoc;
create database if not exists mydoc;
use mydoc;

#--- USER RELATED TABLES

create table if not exists users(
    user_id int primary key auto_increment,
    firstname varchar(255) not null,
    lastname varchar(255) not null,
    gender varchar(10) not null,
    date_of_birth date not null,
    address varchar(255) not null,
    city varchar(255) not null,
    state varchar(255) not null,
    pincode varchar(5) not null,
    phone_number varchar(50) not null,
    email_id varchar(255) not null,
    ssn varchar(50) not null,
    password varchar(255) not null,
    user_type ENUM('patient','doctor','admin') not null
);

#--- DOCTOR RELATED TABLES

create table doctors(
    doctor_id int primary key,
    license_number varchar(20) not null,
    start_of_practice date,
    salary float,
    -- Make below enum
    degree ENUM('MD','MBBS'), 
    university text,
    appointment_fees float

);

create table area_of_specialization(
    area_of_specialization_id int primary key auto_increment not null unique,
    name varchar(255)
);

create table specializes(
    area_of_specialization_id int not null,
    doctor_id int not null,

    primary key (doctor_id, area_of_specialization_id),
    foreign key (area_of_specialization_id) references area_of_specialization(area_of_specialization_id),
    foreign key (doctor_id) references doctors(doctor_id)
);

create table if not exists schedule(
    monday_work boolean,
    tuesday_work boolean,
    wednesday_work boolean,
    thursday_work boolean,
    friday_work boolean,
    shift_start time,
    shift_end time
);

create table doc_schedule(
    monday_work boolean,
    tuesday_work boolean,
    wednesday_work boolean,
    thursday_work boolean,
    friday_work boolean,
    shift_start time,
    shift_end time,

    doctor_id int not null,
    primary key (doctor_id, monday_work, tuesday_work, wednesday_work, thursday_work, friday_work,shift_start,  shift_end),
    foreign key (doctor_id) references doctors(doctor_id)
);


#--- DEPARTMENT RELATED TABLES

create table departments(
    department_id int primary key auto_increment not null unique,
    name varchar(255),
    number_doctors int,
    number_nurses int,
    department_location text,   
    department_spec varchar(255),
    department_budget float,
    phone_number varchar(30) not null,
    date_of_establishment date
);

create table doc_dept(
    department_id int not null,
    doctor_id int not null,

    primary key (doctor_id, department_id),
    foreign key (department_id) references departments(department_id),
    foreign key (doctor_id) references doctors(doctor_id)

);


#--- HOSPITAL RELATED TABLES


create table hospitals(
    hospital_id int primary key auto_increment not null unique,
    name varchar(255),
    address varchar(255) not null,
    city varchar(255) not null,
    state varchar(255) not null,
    pincode varchar(5) not null,
    phone_number varchar(50) not null,
    email_id varchar(255) not null,
    date_of_establishment date
);

create table contact_us(
    contact_us_id int primary key auto_increment not null unique,
	firstname varchar(255) not null,
    lastname varchar(255) not null,
    email_id varchar(255) not null,
    phone_number int(10) not null,
    questions text
);

create table hosp_contact_us(

    contact_us_id int not null unique,
    hospital_id int not null unique,

    primary key (contact_us_id, hospital_id),
    foreign key (contact_us_id) references contact_us(contact_us_id),
    foreign key (hospital_id) references hospitals(hospital_id)
);

create table hosp_dept(
    hospital_id int not null,
    department_id int not null,

    primary key (department_id, hospital_id),
    foreign key (department_id) references departments(department_id),
    foreign key (hospital_id) references hospitals(hospital_id)
);

#--- APPOINTMENT RELATED TABLES

create table appointments(
    appointment_id int primary key auto_increment,
    appointment_date date,
    appointment_time time
);

create table appointment_details(
	user_id int not null,
    doctor_id int not null,
    hospital_id int not null,
    appointment_id int not null,
    
    foreign key (user_id) references users(user_id),
    foreign key (doctor_id) references doctors(doctor_id),
    foreign key (hospital_id) references hospitals(hospital_id),
    foreign key (appointment_id) references appointments(appointment_id)
);



#--- PRESCRIPTION RELATED TABLES

create table if not exists prescriptions(

    prescription_id int primary key auto_increment,
    prescription_text text
    
);


create table if not exists medicines(
    medicine_id int primary key auto_increment not null unique,
    medicine_name varchar(255),
    medicine_manufacturer varchar(255),
    price_per_unit float
);


create table if not exists pres_med(
    prescription_id int not null,
    medicine_id int not null,
    daily_doses int not null,
    number_of_days int not null,

    primary key (prescription_id, medicine_id),
    foreign key (medicine_id) references medicines(medicine_id),
    foreign key (prescription_id) references prescriptions(prescription_id)
);


#--- LAB TEST RELATED TABLES


create table if not exists lab_test(
    lab_test_id int primary key auto_increment not null unique,
    test_name text
);


create table if not exists lab_test_description(
    lab_test_description_id int primary key auto_increment not null,
    description_text text,
    price_per_lab float
);

create table if not exists lab(
	
    lab_test_id int not null,
    lab_test_description_id int not null,
    
    primary key (lab_test_id, lab_test_description_id),
    foreign key (lab_test_id) references lab_test(lab_test_id),
    foreign key (lab_test_description_id) references lab_test_description(lab_test_description_id)	
);


create table diagnosis(
	appointment_id int,
    prescription_id int,
    lab_test_id int,
    
    primary key (appointment_id, prescription_id, lab_test_id),
    foreign key (appointment_id) references appointments(appointment_id),
    foreign key (prescription_id) references prescriptions(prescription_id),
    foreign key (lab_test_id) references lab_test(lab_test_id)
);

#--- PAYMENT RELATED TABLES

create table if not exists payments(
    payment_id int primary key auto_increment not null unique,
    payment_date date,
    fees float
);

create table if not exists card_details(
	card_details_id int primary key auto_increment not null unique,
    card_holder_name varchar(50),
    card_number varchar(30),
    card_type varchar(20),
    expiry_date date
);

create table if not exists pay_card(
	card_details_id int not null,
    payment_id int not null,
    cvv int,
    appointment_id int,
    
    primary key (card_details_id, payment_id,appointment_id),
    foreign key (card_details_id) references card_details(card_details_id),
    foreign key (payment_id) references payments(payment_id),
    foreign key (appointment_id) references appointments(appointment_id)
);

create table if not exists user_card(
	user_id int not null,
    card_details_id int not null,
    
    primary key (user_id, card_details_id),
    foreign key (user_id) references users(user_id),
    foreign key (card_details_id) references card_details(card_details_id)
);


#--- FEEDBACK RELATED TABLES

create table reviews(
    review_id int primary key auto_increment not null unique,
	title text,
    description text,
    rating int(1),

    -- Start of foregin Key
    user_id int not null,
    foreign key (user_id) references users(user_id)
);

create table appt_pay(
		appointment_id int,
        payment_id int,
        
        primary key (appointment_id, payment_id),
		foreign key (appointment_id) references appointments(appointment_id),
		foreign key (payment_id) references payments(payment_id)
);



#--- USERS

insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (1, 'Kahaleel', 'Boorer', 'Bigender', '2022-11-07', '8 Homewood Alley', 'Milwaukee', 'Wisconsin', '53210', '262-460-1044', 'kboorer0@mapquest.com', '336-06-6891', 'tYBNSC0ScPw2', 'patient');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (2, 'Harmon', 'Mayell', 'Male', '2022-10-23', '20 Helena Park', 'West Hartford', 'Connecticut', '06127', '860-592-5042', 'hmayell1@yandex.ru', '121-29-0049', '5MVD6mlb9D', 'patient');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (3, 'Joycelin', 'Toon', 'Female', '2022-09-28', '11841 Grayhawk Road', 'Oklahoma City', 'Oklahoma', '73147', '405-938-3497', 'jtoon2@imageshack.us', '383-72-0063', '13sY81vk', 'patient');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (4, 'Gardner', 'Guinness', 'Male', '2022-09-23', '6 Banding Court', 'New York City', 'New York', '10155', '917-659-0187', 'gguinness3@nsw.gov.au', '631-24-9697', 'nXC8bhesTyNB', 'patient');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (5, 'Brendon', 'Capron', 'Male', '2022-09-21', '8 Hauk Terrace', 'Bronx', 'New York', '10474', '917-709-4247', 'bcapron4@soup.io', '534-62-8135', 'kejk89AIL8Hs', 'patient');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (6, 'Rollins', 'Janeczek', 'Male', '2022-09-24', '12088 Ridgeview Terrace', 'Peoria', 'Illinois', '61635', '309-329-2528', 'rjaneczek5@about.com', '416-62-2392', 'ME6aKPEI', 'patient');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (7, 'Andie', 'Ilden', 'Female', '2022-10-11', '88597 Mayfield Drive', 'Harrisburg', 'Pennsylvania', '17140', '717-508-1402', 'ailden6@howstuffworks.com', '415-60-2828', '92vXNE0oHon0', 'patient');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (8, 'Aurora', 'D''Adamo', 'Female', '2022-11-07', '048 Valley Edge Alley', 'Dayton', 'Ohio', '45490', '937-374-0423', 'adadamo7@godaddy.com', '783-62-8517', 'LZaJLcfE', 'patient');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (9, 'Giuseppe', 'Parade', 'Male', '2022-10-03', '961 Farmco Park', 'Suffolk', 'Virginia', '23436', '757-473-2755', 'gparade8@youtu.be', '178-02-5842', 'QQ4CqQfZJ', 'patient');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (10, 'Zorine', 'Leveridge', 'Female', '2022-09-25', '900 Victoria Alley', 'Amarillo', 'Texas', '79176', '806-904-1874', 'zleveridge9@wunderground.com', '462-08-5099', '2UhiSm6T0KP', 'patient');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (11, 'Amie', 'Coltman', 'Female', '2022-11-03', '9 Blue Bill Park Terrace', 'Great Neck', 'New York', '11024', '516-732-9071', 'acoltmana@myspace.com', '439-21-1922', 'Wb8anIJXjoNn', 'doctor');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (12, 'Brennen', 'Hairsnape', 'Male', '2022-11-14', '503 Holy Cross Plaza', 'New York City', 'New York', '10270', '347-208-5675', 'bhairsnapeb@goodreads.com', '304-51-9904', 'EntPuL7AMS2r', 'doctor');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (13, 'Sarene', 'McRae', 'Female', '2022-10-02', '858 Pond Terrace', 'New Orleans', 'Louisiana', '70165', '504-476-0740', 'smcraec@loc.gov', '684-64-7978', '9Eu3H0nkYd', 'doctor');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (14, 'Ashlin', 'Dumbare', 'Male', '2022-09-30', '80378 Burrows Terrace', 'New York City', 'New York', '10260', '212-642-3584', 'adumbared@meetup.com', '558-10-3908', '5u2xlp', 'doctor');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (15, 'Sophronia', 'Brighty', 'Female', '2022-09-19', '63356 Cody Road', 'Van Nuys', 'California', '91411', '213-792-7876', 'sbrightye@cbc.ca', '561-85-6769', 'CO8vxFwm3gR', 'doctor');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (16, 'Darin', 'Wilcocke', 'Male', '2022-11-26', '50 Union Court', 'Newark', 'Delaware', '19714', '302-743-0298', 'dwilcockef@sfgate.com', '851-57-8849', '65wU198u', 'doctor');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (17, 'Alyssa', 'Eusden', 'Female', '2022-09-06', '7052 Talisman Trail', 'Boynton Beach', 'Florida', '33436', '561-797-1522', 'aeusdeng@jugem.jp', '160-46-1367', 'DnZFISW', 'doctor');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (18, 'Engracia', 'Hick', 'Female', '2022-09-03', '9687 4th Plaza', 'Cincinnati', 'Ohio', '45254', '513-986-3648', 'ehickh@reuters.com', '290-52-7643', '20vsnyt0', 'doctor');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (19, 'Joseph', 'Brockwell', 'Bigender', '2022-02-12', '998 Westport Pass', 'Des Moines', 'Iowa', '50936', '515-217-3485', 'jbrockwelli@newsvine.com', '803-70-5836', 'fE97D05v', 'admin');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (20, 'Roma', 'McKirdy', 'Male', '2022-10-28', '402 Heffernan Drive', 'Los Angeles', 'California', '90020', '818-791-7281', 'rmckirdyj@alibaba.com', '574-46-4439', 'MeAalWvf', 'admin');
insert into users (user_id, firstname, lastname, gender, date_of_birth, address, city, state, pincode, phone_number, email_id, ssn, password, user_type) values (21, 'Sibel', 'Goodbourn', 'Female', '2022-09-14', '76252 Sutherland Place', 'Bonita Springs', 'Florida', '34135', '941-601-5530', 'sgoodbournk@behance.net', '896-20-6976', 'jVac4kgEUuVL', 'admin');


#--- HOSPITALS


insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (1, 'Cormier LLC', '905 Lakewood Gardens Place', 'Houston', 'Texas', '77030', '832-315-6805', 'ldavidof0@usgs.gov', '1989-08-03');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (2, 'Klein-Wisoky', '866 American Terrace', 'Miami', 'Florida', '33185', '305-951-2280', 'sivanishchev1@wiley.com', '1935-05-02');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (3, 'Dietrich-Bogisich', '77996 Mariners Cove Crossing', 'Fort Wayne', 'Indiana', '46862', '260-955-3135', 'whambatch2@hexun.com', '1930-01-14');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (4, 'Gusikowski Inc', '95 Briar Crest Point', 'Anderson', 'Indiana', '46015', '765-681-7276', 'nspall3@wisc.edu', '1906-11-03');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (5, 'Braun, Harris and Gislason', '06169 Bartelt Place', 'Springfield', 'Missouri', '65810', '417-883-0802', 'apiddock4@statcounter.com', '1922-08-03');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (6, 'Corkery-Christiansen', '34102 Iowa Way', 'Oklahoma City', 'Oklahoma', '73173', '405-760-9728', 'cwaggatt5@furl.net', '1981-06-16');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (7, 'Walter-Wehner', '296 Blaine Drive', 'Austin', 'Texas', '78715', '512-602-7983', 'ewittleton6@cbc.ca', '1981-12-10');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (8, 'Cole-Block', '63341 Dapin Junction', 'Hicksville', 'New York', '11854', '516-962-5014', 'bmalarkey7@sakura.ne.jp', '1920-11-07');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (9, 'Grady, Goyette and Hilpert', '319 Fuller Crossing', 'North Hollywood', 'California', '91606', '818-760-9705', 'ralltimes8@fc2.com', '1926-09-30');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (10, 'Fadel-Towne', '7 Tennyson Court', 'Sioux Falls', 'South Dakota', '57188', '605-387-9010', 'rcorbyn9@cdc.gov', '2012-03-17');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (11, 'Rolfson LLC', '993 Dryden Plaza', 'Garland', 'Texas', '75049', '214-982-6317', 'rwitteringa@yandex.ru', '1928-12-16');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (12, 'Mayert LLC', '881 Warner Place', 'Indianapolis', 'Indiana', '46295', '317-189-5149', 'nkettowb@si.edu', '1938-01-21');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (13, 'Bogisich-Olson', '72651 Spohn Hill', 'Newport Beach', 'California', '92662', '949-953-7132', 'mlehenmannc@devhub.com', '1983-11-04');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (14, 'Casper LLC', '33 Bultman Avenue', 'North Las Vegas', 'Nevada', '89036', '702-614-2717', 'lspeked@nationalgeographic.com', '1958-05-15');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (15, 'Willms, Littel and Fadel', '7 Farwell Avenue', 'Saint Louis', 'Missouri', '63136', '314-247-8857', 'fgoudarde@walmart.com', '1959-11-12');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (16, 'Harvey-Nolan', '2214 Warbler Trail', 'Davenport', 'Iowa', '52809', '563-610-5620', 'sbristonf@apache.org', '1974-04-18');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (17, 'Sipes, Ebert and Kessler', '81 Holy Cross Circle', 'San Antonio', 'Texas', '78285', '210-952-0475', 'tsalesg@dropbox.com', '1987-09-09');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (18, 'Altenwerth LLC', '0 Melody Place', 'Lawrenceville', 'Georgia', '30245', '678-128-0695', 'ehaskeyh@state.gov', '1999-11-22');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (19, 'Little and Sons', '12200 Waxwing Drive', 'Clearwater', 'Florida', '34629', '727-883-7385', 'njarnelli@moonfruit.com', '1942-09-24');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (20, 'McKenzie LLC', '7 Iowa Point', 'Saint Paul', 'Minnesota', '55166', '651-987-1366', 'vpickringj@parallels.com', '2020-07-10');
insert into hospitals (hospital_id, name, address, city, state, pincode, phone_number, email_id, date_of_establishment) values (21, 'Hansen and Sons', '5 Loftsgordon Avenue', 'Lancaster', 'Pennsylvania', '17622', '717-284-5558', 'dadrank@about.com', '1902-10-06');


#--- DEPARTMENTS

insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (1, 'Department of Medicine', 1, 26, '2nd Floor', 'Medicine', 8657248, '558-912-8117', '1951-05-16');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (2, 'Department of Surgery', 5, 17, '4th Floor', 'Surgery', 9085390, '587-260-3610', '2002-01-13');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (3, 'Department of Gynaecology', 2, 13, '4th Floor', 'Gynaecology', 9638276, '188-669-1740', '2020-04-09');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (4, 'Department of Obstetrics', 6, 30, '2nd Floor', 'Obstetrics', 8422190, '786-804-0921', '1909-06-16');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (5, 'Department of Paediatrics', 5, 12, '4th Floor', 'Paediatrics', 8624731, '838-118-4012', '2003-08-02');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (6, 'Department of Ophthalmologist', 8, 30, '2nd Floor', 'Eye', 3000619, '428-318-0275', '1904-04-22');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (7, 'Department of ENT', 5, 28, '1st Floor', 'ENT', 8702687, '985-439-1093', '1958-09-11');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (8, 'Department of Dental care', 5, 18, '5th Floor', 'Dental', 4390542, '494-587-2865', '1943-06-11');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (9, 'Department of Orthopaedics', 4, 24, '5th Floor', 'Orthopaedics', 5845069, '925-384-3643', '1944-07-24');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (10, 'Department of Neurology', 8, 18, '2nd Floor', 'Neurology', 5112328, '546-533-3288', '1933-04-30');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (11, 'Department of Cardiology', 4, 10, '1st Floor', 'Cardiology', 3918755, '861-435-7672', '1992-01-15');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (12, 'Department of Psychiatry', 10, 22, '5th Floor', 'Psychiatry', 4916787, '691-458-2166', '2015-10-24');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (13, 'Department of Skin', 1, 10, '5th Floor', 'Skin', 8664783, '418-975-6581', '1981-12-27');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (14, 'Department of Medicine', 2, 22, '2nd Floor', 'Medicine', 5043610, '426-396-4197', '1963-09-18');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (15, 'Department of Surgery', 1, 15, '4th Floor', 'Surgery', 5872447, '243-120-7409', '1935-11-30');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (16, 'Department of Gynaecology', 7, 26, '3rd Floor', 'Gynaecology', 5309470, '332-777-4612', '1973-03-20');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (17, 'Department of Obstetrics', 5, 24, '2nd Floor', 'Obstetrics', 1890616, '770-743-4273', '1902-06-12');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (18, 'Department of Paediatrics', 9, 12, '2nd Floor', 'Paediatrics', 2522333, '461-388-7150', '2006-05-30');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (19, 'Department of Ophthalmologist', 2, 18, '4th Floor', 'Eye', 5917370, '781-951-1926', '2020-05-08');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (20, 'Department of ENT', 1, 18, '5th Floor', 'ENT', 4560550, '109-484-3816', '1959-09-18');
insert into departments (department_id, name, number_doctors, number_nurses, department_location, department_spec, department_budget, phone_number, date_of_establishment) values (21, 'Department of Dental care', 2, 14, '1st Floor', 'Dental', 8922641, '946-256-7023', '1903-07-22');


#--- DOCTORS


insert into doctors (doctor_id, license_number, start_of_practice, salary, degree, university,appointment_fees) values (11, '8507234666', '2000-07-17', 247861, 'MBBS', 'Music Academy "Stanislaw Moniuszko" in Gdansk','150');
insert into doctors (doctor_id, license_number, start_of_practice, salary, degree, university,appointment_fees) values (12, '1943631492', '2005-05-18', 485182, 'MBBS', 'Banat''s University of Agricultural Sciences','180');
insert into doctors (doctor_id, license_number, start_of_practice, salary, degree, university,appointment_fees) values (13, '5785603004', '2015-03-16', 339995, 'MBBS', 'Samara State University of Economics','120');
insert into doctors (doctor_id, license_number, start_of_practice, salary, degree, university,appointment_fees) values (14, '5258386953', '2008-05-11', 381162, 'MD', 'Xiangtan Normal University','100');
insert into doctors (doctor_id, license_number, start_of_practice, salary, degree, university,appointment_fees) values (15, '7473405942', '2013-11-13', 291262, 'MBBS', 'University of Craiova','150');
insert into doctors (doctor_id, license_number, start_of_practice, salary, degree, university,appointment_fees) values (16, '1511663650', '2009-01-14', 251880, 'MBBS', 'Chengdu University of Traditional Chinese Medicine','300');
insert into doctors (doctor_id, license_number, start_of_practice, salary, degree, university,appointment_fees) values (17, '6650997838', '2005-09-23', 425248, 'MD', 'Nangarhar University','200');
insert into doctors (doctor_id, license_number, start_of_practice, salary, degree, university,appointment_fees) values (18, '9187977524', '2010-02-08', 325050, 'MBBS', 'Universidad Nacional del Centro del Perú','50');


#--- AREA OF SPECIALIZATION


insert into area_of_specialization (area_of_specialization_id, name) values (1, 'Pediatrician');
insert into area_of_specialization (area_of_specialization_id, name) values (2, 'Gynecologist');
insert into area_of_specialization (area_of_specialization_id, name) values (3, 'Cardiologist');
insert into area_of_specialization (area_of_specialization_id, name) values (4, 'Oncologist');
insert into area_of_specialization (area_of_specialization_id, name) values (5, 'Gastroenterologist');
insert into area_of_specialization (area_of_specialization_id, name) values (6, 'Pulmonologist');
insert into area_of_specialization (area_of_specialization_id, name) values (7, 'Nephrologist');
insert into area_of_specialization (area_of_specialization_id, name) values (8, 'Surgeon');
insert into area_of_specialization (area_of_specialization_id, name) values (9, 'Dermatologist');
insert into area_of_specialization (area_of_specialization_id, name) values (10, 'Anesthesiologist');


#--- PRESCRIPTIONS

insert into prescriptions (prescription_id, prescription_text) values (1, 'Bypass R Hypogast Vein to Low Vein w Autol Sub, Perc Endo');
insert into prescriptions (prescription_id, prescription_text) values (2, 'Insert of Feeding Dev into Small Intest, Perc Endo Approach');
insert into prescriptions (prescription_id, prescription_text) values (3, 'Bypass Right Ureter to Colocutaneous, Perc Endo Approach');
insert into prescriptions (prescription_id, prescription_text) values (4, 'Chiropractic Manipulation of Pelvis, Long, Short Lever');
insert into prescriptions (prescription_id, prescription_text) values (5, 'Supplement L Low Leg Subcu/Fascia w Synth Sub, Perc');
insert into prescriptions (prescription_id, prescription_text) values (6, 'HDR Brachytherapy of Kidney using Oth Isotope');
insert into prescriptions (prescription_id, prescription_text) values (7, 'Excision of Bladder Neck, Endo, Diagn');
insert into prescriptions (prescription_id, prescription_text) values (8, 'Drainage of Lesser Omentum, Perc Endo Approach, Diagn');
insert into prescriptions (prescription_id, prescription_text) values (9, 'Destruction of Sigmoid Colon, Endo');
insert into prescriptions (prescription_id, prescription_text) values (10, 'Revise Nonaut Sub in Head & Neck Subcu/Fascia, Perc');
insert into prescriptions (prescription_id, prescription_text) values (11, 'Drainage of Right Humeral Shaft, Perc Approach, Diagn');
insert into prescriptions (prescription_id, prescription_text) values (12, 'Dilate R Renal Art, Bifurc, w 2 Intralum Dev, Perc');
insert into prescriptions (prescription_id, prescription_text) values (13, 'Excision of Right Cephalic Vein, Open Approach, Diagnostic');
insert into prescriptions (prescription_id, prescription_text) values (14, 'Bypass L Int Iliac Art to L Femor A, Perc Endo Approach');
insert into prescriptions (prescription_id, prescription_text) values (15, 'Revision of Autologous Tissue Substitute in Left Ear, Endo');
insert into prescriptions (prescription_id, prescription_text) values (16, 'Release Right Wrist Joint, Open Approach');
insert into prescriptions (prescription_id, prescription_text) values (17, 'Removal of Other Device from Male Perineum, Perc Approach');
insert into prescriptions (prescription_id, prescription_text) values (18, 'Introduction of Nutritional Substance into Male Reprod, Endo');
insert into prescriptions (prescription_id, prescription_text) values (19, 'Insertion of Int Fix into R Parietal Bone, Perc Approach');
insert into prescriptions (prescription_id, prescription_text) values (20, 'Supplement L Hip Jt, Acetab with Resurf Dev, Open Approach');
insert into prescriptions (prescription_id, prescription_text) values (21, 'Revision of Intraluminal Device in Vagina & Cul-de-sac, Endo');


#--- MEDICINES

insert into medicines (medicine_id, medicine_name, medicine_manufacturer,price_per_unit) values (1, 'Methocarbamol', 'Aidarex Pharmaceuticals LLC','100.52');
insert into medicines (medicine_id, medicine_name, medicine_manufacturer,price_per_unit) values (2, 'Proparacaine Hydrochloride', 'A-S Medication Solutions LLC','10.23');
insert into medicines (medicine_id, medicine_name, medicine_manufacturer,price_per_unit) values (3, 'CLARINS Skin Illusion SPF 10 Natural Radiance Foundation Tint 112.5', 'Laboratoires Clarins S.A.','1.1');
insert into medicines (medicine_id, medicine_name, medicine_manufacturer,price_per_unit) values (4, 'Carisoprodol', 'Cardinal Health','100.52');
insert into medicines (medicine_id, medicine_name, medicine_manufacturer,price_per_unit) values (5, 'Listerine', 'Johnson & Johnson Healthcare Products, Division of McNEIL-PPC, Inc.','2');
insert into medicines (medicine_id, medicine_name, medicine_manufacturer,price_per_unit) values (6, 'Arthritis pain reliever', 'Walgreen Company','4.6');
insert into medicines (medicine_id, medicine_name, medicine_manufacturer,price_per_unit) values (7, 'Health Smart Antibacterial original', 'International Wholesale, Inc.','9.76');
insert into medicines (medicine_id, medicine_name, medicine_manufacturer,price_per_unit) values (8, 'Acetaminophen And Codeine', 'Qualitest Pharmaceuticals','11.8');
insert into medicines (medicine_id, medicine_name, medicine_manufacturer,price_per_unit) values (9, 'Protect Skincare Sunscreen', 'Boots Retail USA Inc','6.3');
insert into medicines (medicine_id, medicine_name, medicine_manufacturer,price_per_unit) values (10, 'Olanzapine', 'Teva Pharmaceuticals USA Inc','8.3');


#--- LAB TEST

insert into lab_test (lab_test_id, test_name) values (1, 'B3749');
insert into lab_test (lab_test_id, test_name) values (2, 'W2203');
insert into lab_test (lab_test_id, test_name) values (3, 'S92155P');
insert into lab_test (lab_test_id, test_name) values (4, 'X111XXS');
insert into lab_test (lab_test_id, test_name) values (5, 'S83113A');
insert into lab_test (lab_test_id, test_name) values (6, 'S62357G');
insert into lab_test (lab_test_id, test_name) values (7, 'M11021');
insert into lab_test (lab_test_id, test_name) values (8, 'S79112P');
insert into lab_test (lab_test_id, test_name) values (9, 'S82854');
insert into lab_test (lab_test_id, test_name) values (10, 'M86129');
insert into lab_test (lab_test_id, test_name) values (11, 'S06374S');
insert into lab_test (lab_test_id, test_name) values (12, 'F1398');
insert into lab_test (lab_test_id, test_name) values (13, 'O361130');
insert into lab_test (lab_test_id, test_name) values (14, 'S92919S');
insert into lab_test (lab_test_id, test_name) values (15, 'S91205');
insert into lab_test (lab_test_id, test_name) values (16, 'S5292XB');
insert into lab_test (lab_test_id, test_name) values (17, 'S62655D');
insert into lab_test (lab_test_id, test_name) values (18, 'S56909S');
insert into lab_test (lab_test_id, test_name) values (19, 'E711');
insert into lab_test (lab_test_id, test_name) values (20, 'T655');
insert into lab_test (lab_test_id, test_name) values (21, 'R2972');


#--- LAB TEST DESCRIPTION

insert into lab_test_description (lab_test_description_id, description_text,price_per_lab) values (1, 'Deep necrosis of underlying tissues [deep third degree] with loss of a body part, of multiple sites of wrist(s) and hand(s)','20.58');
insert into lab_test_description (lab_test_description_id, description_text,price_per_lab) values (2, 'Other specified disorders of tooth development and eruption','30.18');
insert into lab_test_description (lab_test_description_id, description_text,price_per_lab) values (3, 'Localization-related (focal) (partial) epilepsy and epileptic syndromes with simple partial seizures, without mention of intractable epilepsy','10.23');
insert into lab_test_description (lab_test_description_id, description_text,price_per_lab) values (4, 'Diabetes with neurological manifestations, type I [juvenile type], not stated as uncontrolled','3.5');
insert into lab_test_description (lab_test_description_id, description_text,price_per_lab) values (5, 'Hodgkin''s disease, mixed cellularity, intrapelvic lymph nodes','15.99');
insert into lab_test_description (lab_test_description_id, description_text,price_per_lab) values (6, 'Chondrocalcinosis, unspecified, site unspecified','80.37');
insert into lab_test_description (lab_test_description_id, description_text,price_per_lab) values (7, 'Presence of other contraceptive device','40');
insert into lab_test_description (lab_test_description_id, description_text,price_per_lab) values (8, 'Suicide and self-inflicted poisoning by arsenic and its compounds','33');
insert into lab_test_description (lab_test_description_id, description_text,price_per_lab) values (9, 'Pleurisy with effusion, with mention of a bacterial cause other than tuberculosis','22');
insert into lab_test_description (lab_test_description_id, description_text,price_per_lab) values (10, 'Need for prophylactic vaccination and inoculation against measles alone','5.46');


#--- PAYMENTS

insert into payments (payment_id, payment_date, fees) values (1, '2021-06-02', '0');
insert into payments (payment_id, payment_date, fees) values (2, '2019-03-02', '0');
insert into payments (payment_id, payment_date, fees) values (3, '2019-10-25', '0');
insert into payments (payment_id, payment_date, fees) values (4, '2009-08-18', '0');
insert into payments (payment_id, payment_date, fees) values (5, '2005-10-24', '0');
insert into payments (payment_id, payment_date, fees) values (6, '2006-06-28', '0');
insert into payments (payment_id, payment_date, fees) values (7, '2016-05-22', '0');
insert into payments (payment_id, payment_date, fees) values (8, '2008-02-28', '0');
insert into payments (payment_id, payment_date, fees) values (9, '2008-12-16', '0');
insert into payments (payment_id, payment_date, fees) values (10, '2021-08-29', '0');

#--CARD DETAILS

insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (1, 'Hatti Musico', '5048375337577240', 'mastercard', '2010-06-26');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (2, 'Elly Anwell', '5108752968509881', 'mastercard', '2009-09-17');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (3, 'Lawton Liston', '5048374138490745', 'mastercard', '2018-09-13');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (4, 'Cyndy Sifleet', '5048373919605547', 'mastercard', '2004-06-24');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (5, 'Aldon Colmer', '5108755409497210', 'mastercard', '2005-07-03');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (6, 'Gaspar McGarvie', '5108754178917086', 'mastercard', '2018-03-16');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (7, 'Florencia Beckett', '5048373484454230', 'mastercard', '2007-07-15');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (8, 'Bailey Hawse', '5108759727581465', 'mastercard', '2020-02-23');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (9, 'Vachel Goulstone', '5048375519185333', 'mastercard', '2019-07-25');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (10, 'Harmonie Ryding', '5108752927007654', 'mastercard', '2011-05-12');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (11, 'Stacee Tappin', '5108755776864760', 'mastercard', '2008-01-15');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (12, 'Edlin Connor', '5108751560565523', 'mastercard', '2007-07-14');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (13, 'Dannye Daniellot', '5048372706308323', 'mastercard', '2006-10-09');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (14, 'Lewiss Giacoppoli', '5048371787899069', 'mastercard', '2012-01-03');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (15, 'Barbi Inworth', '5048375506019883', 'mastercard', '2011-12-22');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (16, 'Teriann Ashworth', '5048378293924901', 'mastercard', '2006-03-25');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (17, 'Wally Joselovitch', '5108756488842904', 'mastercard', '2020-07-07');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (18, 'Xenia Mikalski', '5048370360098990', 'mastercard', '2007-09-04');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (19, 'Natala Edmondson', '5108752102371560', 'mastercard', '2016-01-09');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (20, 'Sandi Burchfield', '5108758537577283', 'mastercard', '2021-10-31');
insert into card_details (card_details_id, card_holder_name, card_number, card_type, expiry_date) values (21, 'Arvin Southward', '5108757471291174', 'mastercard', '2003-06-16');

#--APPOINTMENTS

insert into appointments (appointment_id, appointment_date, appointment_time) values (1, '2022-11-28', '13:00:00');
insert into appointments (appointment_id, appointment_date, appointment_time) values (2, '2022-11-28', '14:00:00');
insert into appointments (appointment_id, appointment_date, appointment_time) values (3, '2022-11-28', '17:00:00');
insert into appointments (appointment_id, appointment_date, appointment_time) values (4, '2020-08-22', '10:00:00');
insert into appointments (appointment_id, appointment_date, appointment_time) values (5, '2016-08-26', '4:10:26');
insert into appointments (appointment_id, appointment_date, appointment_time) values (6, '2008-04-30', '10:25:59');
insert into appointments (appointment_id, appointment_date, appointment_time) values (7, '2008-11-17', '1:56:24');
insert into appointments (appointment_id, appointment_date, appointment_time) values (8, '2008-05-08', '20:36:46');
insert into appointments (appointment_id, appointment_date, appointment_time) values (9, '2002-05-30', '7:58:05');
insert into appointments (appointment_id, appointment_date, appointment_time) values (10, '2008-04-11', '17:10:53');
insert into appointments (appointment_id, appointment_date, appointment_time) values (11, '2016-09-09', '15:15:40');
insert into appointments (appointment_id, appointment_date, appointment_time) values (12, '2006-07-03', '22:15:50');
insert into appointments (appointment_id, appointment_date, appointment_time) values (13, '2022-08-26', '17:01:50');
insert into appointments (appointment_id, appointment_date, appointment_time) values (14, '2020-12-02', '3:50:09');
insert into appointments (appointment_id, appointment_date, appointment_time) values (15, '2017-01-31', '6:17:31');


#--- Hosp_Dept

insert into hosp_dept (hospital_id, department_id) values (1, 5);
insert into hosp_dept (hospital_id, department_id) values (2, 6);
insert into hosp_dept (hospital_id, department_id) values (3, 8);
insert into hosp_dept (hospital_id, department_id) values (4, 7);
insert into hosp_dept (hospital_id, department_id) values (5, 10);
insert into hosp_dept (hospital_id, department_id) values (6, 1);
insert into hosp_dept (hospital_id, department_id) values (7, 2);
insert into hosp_dept (hospital_id, department_id) values (8, 16);
insert into hosp_dept (hospital_id, department_id) values (9, 15);
insert into hosp_dept (hospital_id, department_id) values (10, 3);
insert into hosp_dept (hospital_id, department_id) values (11, 4);
insert into hosp_dept (hospital_id, department_id) values (12, 12);
insert into hosp_dept (hospital_id, department_id) values (13, 11);
insert into hosp_dept (hospital_id, department_id) values (14, 18);
insert into hosp_dept (hospital_id, department_id) values (15, 19);
insert into hosp_dept (hospital_id, department_id) values (1, 21);
insert into hosp_dept (hospital_id, department_id) values (16, 20);
insert into hosp_dept (hospital_id, department_id) values (17, 9);
insert into hosp_dept (hospital_id, department_id) values (18, 7);
insert into hosp_dept (hospital_id, department_id) values (19, 14);
insert into hosp_dept (hospital_id, department_id) values (20, 17);
insert into hosp_dept (hospital_id, department_id) values (21, 13);



#--- Doc_Dept

insert into doc_dept (doctor_id, department_id) values (11, 5);
insert into doc_dept (doctor_id, department_id) values (12, 6);
insert into doc_dept (doctor_id, department_id) values (13, 8);
insert into doc_dept (doctor_id, department_id) values (14, 7);
insert into doc_dept (doctor_id, department_id) values (15, 10);
insert into doc_dept (doctor_id, department_id) values (16, 1);
insert into doc_dept (doctor_id, department_id) values (17, 2);
insert into doc_dept (doctor_id, department_id) values (18, 16);

#--- Doc_Schedule

insert into doc_schedule (monday_work, tuesday_work, wednesday_work, thursday_work, friday_work, shift_start, shift_end, doctor_id) values (true, true, false, true, false, '08:22:00', '23:01:00', 11);
insert into doc_schedule (monday_work, tuesday_work, wednesday_work, thursday_work, friday_work, shift_start, shift_end, doctor_id) values (false, false, false, false, false, '11:14:00', '03:21:00', 12);
insert into doc_schedule (monday_work, tuesday_work, wednesday_work, thursday_work, friday_work, shift_start, shift_end, doctor_id) values (true, false, true, true, false, '17:07:00', '00:00:00', 13);
insert into doc_schedule (monday_work, tuesday_work, wednesday_work, thursday_work, friday_work, shift_start, shift_end, doctor_id) values (false, true, true, true, true, '13:04:00', '16:47:00', 14);
insert into doc_schedule (monday_work, tuesday_work, wednesday_work, thursday_work, friday_work, shift_start, shift_end, doctor_id) values (false, true, false, false, true, '09:17:00', '20:17:00', 15);
insert into doc_schedule (monday_work, tuesday_work, wednesday_work, thursday_work, friday_work, shift_start, shift_end, doctor_id) values (true, true, true, false, true, '18:05:00', '04:33:00', 16);
insert into doc_schedule (monday_work, tuesday_work, wednesday_work, thursday_work, friday_work, shift_start, shift_end, doctor_id) values (false, true, true, true, false, '04:21:00', '15:23:00', 17);
insert into doc_schedule (monday_work, tuesday_work, wednesday_work, thursday_work, friday_work, shift_start, shift_end, doctor_id) values (false, true, true, true, false, '07:21:00', '00:33:00', 18);


#--- Specializes

insert into specializes (doctor_id, area_of_specialization_id) values (11, 5);
insert into specializes (doctor_id, area_of_specialization_id) values (12, 6);
insert into specializes (doctor_id, area_of_specialization_id) values (13, 8);
insert into specializes (doctor_id, area_of_specialization_id) values (14, 7);
insert into specializes (doctor_id, area_of_specialization_id) values (15, 10);
insert into specializes (doctor_id, area_of_specialization_id) values (16, 1);
insert into specializes (doctor_id, area_of_specialization_id) values (17, 2);
insert into specializes (doctor_id, area_of_specialization_id) values (18, 6);


#--- Pres Med

insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (1, 1, 3, 4);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (2, 1, 2, 4);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (3, 1, 1, 3);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (2, 2, 2, 4);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (3, 2, 1, 3);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (2, 3, 2, 4);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (3, 3, 1, 3);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (4, 4, 2, 5);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (5, 5, 3, 1);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (6, 6, 1, 7);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (7, 7, 2, 1);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (8, 8, 1, 4);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (9, 9, 3, 4);
insert into pres_med (prescription_id, medicine_id, daily_doses, number_of_days) values (10, 10, 2, 1);
#--- Lab

insert into lab (lab_test_description_id, lab_test_id) values (1, 1);
insert into lab (lab_test_description_id, lab_test_id) values (2, 1);
insert into lab (lab_test_description_id, lab_test_id) values (3, 3);
insert into lab (lab_test_description_id, lab_test_id) values (4, 4);
insert into lab (lab_test_description_id, lab_test_id) values (5, 5);
insert into lab (lab_test_description_id, lab_test_id) values (6, 6);
insert into lab (lab_test_description_id, lab_test_id) values (7, 7);
insert into lab (lab_test_description_id, lab_test_id) values (8, 8);
insert into lab (lab_test_description_id, lab_test_id) values (9, 9);
insert into lab (lab_test_description_id, lab_test_id) values (10, 10);



#--- user_card

insert into user_card (card_details_id, user_id) values (1, 1);
insert into user_card (card_details_id, user_id) values (2, 2);
insert into user_card (card_details_id, user_id) values (3, 3);
insert into user_card (card_details_id, user_id) values (4, 4);
insert into user_card (card_details_id, user_id) values (5, 5);
insert into user_card (card_details_id, user_id) values (6, 6);
insert into user_card (card_details_id, user_id) values (7, 7);
insert into user_card (card_details_id, user_id) values (8, 8);
insert into user_card (card_details_id, user_id) values (9, 9);
insert into user_card (card_details_id, user_id) values (10, 10);

#--- appointment_details

insert into appointment_details (appointment_id, user_id, hospital_id, doctor_id) values (1, 1, 1, 11);
insert into appointment_details (appointment_id, user_id, hospital_id, doctor_id) values (2, 2, 1, 11);
insert into appointment_details (appointment_id, user_id, hospital_id, doctor_id) values (3, 3, 1, 11);
insert into appointment_details (appointment_id, user_id, hospital_id, doctor_id) values (4, 1, 4, 15);
insert into appointment_details (appointment_id, user_id, hospital_id, doctor_id) values (5, 5, 5, 16);
insert into appointment_details (appointment_id, user_id, hospital_id, doctor_id) values (6, 6, 6, 13);
insert into appointment_details (appointment_id, user_id, hospital_id, doctor_id) values (7, 7, 7, 17);
insert into appointment_details (appointment_id, user_id, hospital_id, doctor_id) values (8, 8, 8, 16);




#--- diagnosis

#insert into diagnosis (appointment_id, prescription_id, lab_test_id) values (1, 1, 1);
insert into diagnosis (appointment_id, prescription_id, lab_test_id) values (2, 2, 2);
insert into diagnosis (appointment_id, prescription_id, lab_test_id) values (3, 3, 3);
insert into diagnosis (appointment_id, prescription_id, lab_test_id) values (4, 4, 4);
insert into diagnosis (appointment_id, prescription_id, lab_test_id) values (5, 5, 5);
insert into diagnosis (appointment_id, prescription_id, lab_test_id) values (6, 6, 6);
insert into diagnosis (appointment_id, prescription_id, lab_test_id) values (7, 7, 7);
insert into diagnosis (appointment_id, prescription_id, lab_test_id) values (8, 8, 8);
insert into diagnosis (appointment_id, prescription_id, lab_test_id) values (9, 9, 9);
insert into diagnosis (appointment_id, prescription_id, lab_test_id) values (10, 10, 10);

#-- appt_pay

insert into appt_pay (appointment_id, payment_id) values (1,1);
insert into appt_pay (appointment_id, payment_id) values (2,2);
insert into appt_pay (appointment_id, payment_id) values (3,3);
insert into appt_pay (appointment_id, payment_id) values (4,4);
insert into appt_pay (appointment_id, payment_id) values (5,5);
insert into appt_pay (appointment_id, payment_id) values (6,6);
insert into appt_pay (appointment_id, payment_id) values (7,7);
insert into appt_pay (appointment_id, payment_id) values (8,8);
insert into appt_pay (appointment_id, payment_id) values (9,9);
insert into appt_pay (appointment_id, payment_id) values (10,10);



#-- pay_card
/*
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (1, 1, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (2, 2, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (3, 3, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (4, 4, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (5, 5, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (6, 6, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (7, 7, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (8, 8, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (9, 9, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (10, 10, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (11, 11, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (12, 12, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (13, 13, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (14, 14, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (15, 15, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (16, 16, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (17, 17, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (18, 18, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (19, 19, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (20, 20, null, null);
insert into pay_card (card_details_id, payment_id, cvv, appointment_id) values (21, 21, null, null);
*/

drop view if exists userInfo;
create view userInfo as ( select user_id, concat(firstname, ' ',lastname) as name, gender, date_of_birth, address,city,state,pincode, phone_number,email_id from users);


drop procedure if exists get_this_week_dates;
delimiter $$

create procedure get_this_week_dates(in cur_date date, out start_date date, out end_date date)

begin
    set start_date = DATE_ADD(cur_date, INTERVAL(-WEEKDAY(cur_date)) DAY);
    set end_date = DATE_ADD(cur_date, INTERVAL(6-WEEKDAY(cur_date)) DAY);
end $$

delimiter ;


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
;

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


drop trigger if exists payment_discount;
delimiter $$
create trigger payment_discount before update on payments 
for each row
begin
	
    if new.fees > '5000' then
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
    declare bill_id int;
    
    select appt_pay.payment_id into bill_id
    from appt_pay
    where appt_pay.appointment_id = new.appointment_id;

	select  prescription_amt(new.prescription_id) into presc_amt;
    
    select lab_test_amt(new.lab_test_id) into lab_amt;
    
    
    
    
	update payments 
	set fees = fees + presc_amt + lab_amt
	where payments.payment_id = bill_id;
    
end $$
delimiter ;


#update payments set fees = '6000' where payment_id = '1';

drop view if exists generate_bill_view;
create view generate_bill_view as
(select appointments.appointment_id, appointments.appointment_date, appointments.appointment_time,
		concat(u1.firstname, ' ',u1.lastname) as 'patient_name',concat(u2.firstname, ' ',u2.lastname) as 'doctor_name', hospitals.name as 'hospital_name',
        prescription_amt(diagnosis.prescription_id) as 'prescription_amt',lab_test_amt(diagnosis.lab_test_id) as 'lab_test_amt',payments.fees as 'final_bill'
from payments, appt_pay, appointments, diagnosis,appointment_details,hospitals,users u1, users u2
where payments.payment_id = appt_pay.payment_id and
		appt_pay.appointment_id = appointments.appointment_id and
        appointments.appointment_id = diagnosis.appointment_id and
        appointments.appointment_id = appointment_details.appointment_id and
        appointment_details.hospital_id = hospitals.hospital_id and
        appointment_details.user_id = u1.user_id and
        appointment_details.doctor_id = u2.user_id);


use mydoc;

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

use mydoc;

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

use mydoc;
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

use mydoc;

delimiter $$
create function numAppointmentsToday(today_date date , hospital_id int)
returns int
deterministic
begin
	declare count_appointments int;
	select count(*) into count_appointments 
    from appointments a , appointment_details as ad 
    where a.appointment_id = ad.appointment_id 
    and ad.hospital_id = hospital_id;
    
    return count_appointments;

end $$
delimiter ;

use mydoc;

delimiter $$;
create function billTotal( user_id int ) 
returns float
begin
	declare amount float;
    
    select sum(p.fees) int amount from payments p, pay_card pc, user_card uc where uc.user_id = user_id and uc.card_details_id = pc.card_details_id and pc.payment_id = p.payment_id group by uc.user_id;

	return amount;
end;
delimiter ;

use mydoc;
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





