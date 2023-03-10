create database mydoc;

create table if not exists user(
	user_id int primary key auto_increment not null,
	firstname varchar(255) not null,
    lastname varchar(255) not null,
    gender varchar(10) not null,
    date_of_birth date not null,
    address varchar(255) not null,
    city varchar(255) not null,
    state varchar(255) not null,
    pincode varchar(5) not null,
    phone_number int(10) not null,
    email_id varchar(255) not null,
    ssn int(9) not null,
    password varchar(255) not null
    /* add user_type */
);

create table if not exists doctor(
    doctor_id int primary key auto_increment,
    license_number varchar(20) not null,
    start_of_practice date,
    salary float,
    -- Make below enum
    degree text, 
    university text,


    -- Start of foregin keys    
    user_id int,
    hospital_id int primary key,
    area_of_specialization_id int primary key
);

create table if not exists admin(
	admin_id int primary key auto_increment,

    -- Start of foregin keys    
    user_id int,
    hospital_id int primary key,
);

create table if not exists hospital(
	hospital_id int primary key auto_increment,
    name varchar(255),
    address varchar(255) not null,
    city varchar(255) not null,
    state varchar(255) not null,
    pincode varchar(5) not null,
    phone_number int(10) not null,
    email_id varchar(255) not null,
    date_of_establishment date,


    -- Start of foregin keys    
);

create table if not exists department(
	department_id int primary key auto_increment,
    name varchar(255),
    description text,
    number_doctors int,
    number_nurses int,
    department_location text,   
    department_spec varchar(255),
    department_budget float,
    phone_number int(10) not null,
    date_of_establishment date,


    -- Start of foregin keys    
    hospital_id int,
);

create table if not exists area_of_specialization(
	specialization_id int primary key auto_increment,
    name varchar(255)
);

create table if not exists schedule(
	schedule_id int primary key auto_increment,
    monday_work boolean,
    tuesday_work boolean,
    wednesday_work boolean,
    thursday_work boolean,
    friday_work boolean,
    shift_start time,
    shift_end time,
);

create table if not exists doc_schedule(
    -- Foregin Key from schedule
    monday_work boolean,
    tuesday_work boolean,
    wednesday_work boolean,
    thursday_work boolean,
    friday_work boolean,
    shift_start time,
    shift_end time,

    -- Foregin Key from doctor
    doctor_id

);

create table if not exists contact_us(
    contact_us_id int primary key auto_increment not null,
	firstname varchar(255) not null,
    lastname varchar(255) not null,
    email_id varchar(255) not null,
    phone_number int(10) not null,
    query text,

    -- Foregin Key
    hospital_id int
);

create table if not exists reviews(
    review_id int primary key auto_increment not null,
	title text,
    description text,
    rating int(1)

    -- Foregin Key
    user_id int,
    diagnosis_id int
);

create table if not exists appointment(
    appointment_id int primary key auto_increment not null,
    appointment_date date,
    appointment_time time,


    --Foreign Key
    doctor_id,
    user_id,
    hospital_id
)

create table if not exists insurance(
    insurance_id int primary key auto_increment not null,
    company_name varchar(15),
    policy_name varchar(15),
    coverage float,

    --Foreign Key
    user_id
)

create table if not exists diagnosis(
    diagnosis_id int primary key auto_increment not null,
    diagnosis_text text,

    --Foreign Key
    user_id,
    doctor_id,
    appointment_id,

)

create table if not exists medicine(
    medicine_id int primary key auto_increment not null,
    medicine_name varchar(255),
    medicine_manufacturer varchar(255)
)

create table if not exists presciption(
    prescription_id primary key not null,
    daily_dosage text,
    number_of_days int

    -- Foregin Key
    medicine_id 
    diagnosis_id
    medicine_name
)

-- Change
create table if not exists lab_test(
    lab_test_id primary key not null,
    test_name text,

    -- Foregin Key
    lab_test_description_id
    diagnosis_id
)

create table if not exists lab_test_description(
    lab_test_description_id primary key not null,
    test_name text,
    test_description text,
)

create table if not exists card_details(
    card_details_id primary key not null,
    card_holder_name varchar(15),
    card_number int(16),
    card_type varchar(20),
    cvv int(3),
    expiry_date date,

    -- Foreging Key
    user_id

)

create table if not exists payments(
    paymnet_id primary key not null,
    payments_date datetime,

    -- Foreging Key
    card_details_id,
    diagnosis_id

)

create table if not exists diagnoses(
     doctor_id int,
     diagnosis_id int,
     primary key (doctor_id) references doctor on delete cascade,
     diagnosis_id (diagnosis_id) references diagnosis on delete cascade,
)

create table if not exists feedback(
     review_id int,
     diagnosis_id int,
     primary key (review_id) references review on delete cascade,
     diagnosis_id (diagnosis_id) references diagnosis on delete cascade,
)

create table if not exists recommends(
     lab_test_id int,
     diagnosis_id int,
     primary key (lab_test_id) references lab_test on delete cascade,
     diagnosis_id (diagnosis_id) references diagnosis on delete cascade,
)

create table if not exists prescribe(
     prescription_id int,
     diagnosis_id int,
     primary key (prescription_id) references prescription on delete cascade,
     diagnosis_id (diagnosis_id) references diagnosis on delete cascade,
)

create table if not exists med(
     prescription_id int,
     medicine_id int,
     primary key (prescription_id) references prescription on delete cascade,
     diagnosis_id (medicine_id) references medicine on delete cascade,
)

create table if not exists description(
     lab_test_id int,
     lab_description_id int,
     primary key (lab_test_id) references lab_test on delete cascade,
     diagnosis_id (lab_description_id) references lab_description on delete cascade,
)

