drop database mydoc;
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

