
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