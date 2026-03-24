#Part 1: Creating the Database 
CREATE DATABASE ntuc_schema;

USE ntuc_schema;

CREATE TABLE CUSTOMER (
  customer_id char(11) NOT NULL,
  name varchar(255) NOT NULL,
  d_o_b date NOT NULL,
  gender varchar(6) NOT NULL,
  email varchar(100) NOT NULL,
  phone_no varchar(11) NOT NULL,
  insured boolean NOT NULL,
  beneficiary boolean NOT NULL,
  policyholder boolean NOT NULL,
  street_name varchar(100) NOT NULL,
  postal_code varchar(6) NOT NULL,
  CONSTRAINT customer_pk PRIMARY KEY(customer_id)
);


CREATE TABLE EMPLOYEE (
  employee_id int NOT NULL,
  name varchar(30) NOT NULL,
  date_hired date NOT NULL,
  phone_no varchar(11) NOT NULL,
  employee_type varchar(15) NOT NULL,
  street_name varchar(100) NOT NULL,
  block_no varchar(3)  NOT NULL,
  postal_code varchar(6) NOT NULL,
  CONSTRAINT employee_pk PRIMARY KEY(employee_id)
  );
 
  
CREATE TABLE INSURANCE_AGENT (
  i_employee_id int NOT NULL,
  license_no int NOT NULL,
  CONSTRAINT insurance_agent_pk PRIMARY KEY (i_employee_id),
  CONSTRAINT insurance_agent_fk FOREIGN KEY (i_employee_id) REFERENCES EMPLOYEE (employee_id)
);


CREATE TABLE UNDERWRITER (
   u_employee_id int NOT NULL,
   approval_limit int NOT NULL,
  CONSTRAINT underwriter_pk PRIMARY KEY (u_employee_id),
  CONSTRAINT underwriter_fk FOREIGN KEY (u_employee_id) REFERENCES EMPLOYEE (employee_id)
);


CREATE TABLE POLICYHOLDER (
   p_customer_id char(11) NOT NULL,
   bank_account_no varchar(13) NOT NULL,
   relationship_to_insured varchar(50) NOT NULL,
   i_employee_id int NOT NULL,
   referral_code varchar(9) NOT NULL,
   referred_policyholder_id char(11) NULL,
   CONSTRAINT policyholder_id_pk PRIMARY KEY (p_customer_id),
   CONSTRAINT policyholder_id_fk FOREIGN KEY (p_customer_id) REFERENCES CUSTOMER(customer_id),
   CONSTRAINT policyholder_id_fk1 FOREIGN KEY (i_employee_id) REFERENCES INSURANCE_AGENT(i_employee_id),
   CONSTRAINT policyholder_id_fk2 FOREIGN KEY (referred_policyholder_id) REFERENCES POLICYHOLDER(p_customer_id)
); 


CREATE TABLE BENEFICIARY (
   b_customer_id char(11) NOT NULL,
   relationship_to_insured  varchar(50) NOT NULL,
   bank_account_no varchar(13) NOT NULL,
CONSTRAINT beneficiary_pk PRIMARY KEY (b_customer_id),
CONSTRAINT beneficiary_fk FOREIGN KEY (b_customer_id) REFERENCES CUSTOMER(customer_id)
);


CREATE TABLE INSURED (
  i_customer_id char(11) NOT NULL,
  is_smoker boolean NOT NULL,
  clinic_visited varchar(50) NOT NULL,
  CONSTRAINT insured_pk PRIMARY KEY (i_customer_id),
  CONSTRAINT insured_fk FOREIGN KEY (i_customer_id) REFERENCES CUSTOMER (customer_id)
);


CREATE TABLE PERSONAL_INSURANCE (
  policy_id varchar(4) NOT NULL,
  purchase_date date NOT NULL,
  start_of_cover_date date NOT NULL,
  insured_sum int NOT NULL,
  policy_status varchar(7) NOT NULL,
  expiry_date date NULL, 
  insurance_type varchar (50) NOT NULL,
  p_customer_id char(11) NOT NULL,
  i_customer_id char(11) NOT NULL,
  u_employee_id int NOT NULL,
  CONSTRAINT personal_insurance_pk PRIMARY KEY (policy_id),
  CONSTRAINT personal_insurance_fk FOREIGN KEY (p_customer_id) REFERENCES POLICYHOLDER (p_customer_id),
  CONSTRAINT personal_insurance_fk1 FOREIGN KEY (i_customer_id) REFERENCES INSURED (i_customer_id),
  CONSTRAINT personal_insurance_fk2 FOREIGN KEY (u_employee_id) REFERENCES UNDERWRITER (u_employee_id)
);


CREATE TABLE CLAIM (
  claim_id varchar(10) NOT NULL,
  claim_date date NOT NULL,
  claim_amount INT NOT  NULL,
  policy_id varchar(4) NOT NULL,
  CONSTRAINT claim_pk PRIMARY KEY (claim_id),
  CONSTRAINT claim_fk FOREIGN KEY (policy_id) REFERENCES PERSONAL_INSURANCE(policy_id)
);


CREATE TABLE LIFE (
  l_policy_id varchar(4) NOT NULL,
  maturity_date date NOT NULL,
  surrender_value int NOT NULL,
  CONSTRAINT life_pk PRIMARY KEY (l_policy_id),
  CONSTRAINT life_pk FOREIGN KEY (l_policy_id) REFERENCES PERSONAL_INSURANCE(policy_id)
);


CREATE TABLE HEALTH (
  h_policy_id varchar(4) NOT NULL,
  coverage_type varchar(50) NOT NULL,
  medical_limit int NOT NULL,
  CONSTRAINT health_pk PRIMARY KEY (h_policy_id),
  CONSTRAINT health_fk FOREIGN KEY (h_policy_id) REFERENCES PERSONAL_INSURANCE(policy_id)
);


CREATE TABLE PAYMENT (
  invoice_no varchar(6) NOT NULL,
  amount int NOT NULL,
  payment_date date NOT NULL,
  payment_method varchar(15) NOT NULL,
  policy_id varchar(4) NOT NULL,
  CONSTRAINT payment_pk PRIMARY KEY (invoice_no),
  CONSTRAINT payment_fk FOREIGN KEY (policy_id) REFERENCES PERSONAL_INSURANCE(policy_id)
);


CREATE TABLE PAYOUT_ALLOCATION (
  policy_id varchar(4) NOT NULL,
  b_customer_id char(11) NOT NULL,
  percentage_allocation dec(5,2) NOT NULL,
  CONSTRAINT payout_allocation_pk PRIMARY KEY (policy_id, b_customer_id),
  CONSTRAINT payout_allocation_fk FOREIGN KEY (policy_id) REFERENCES PERSONAL_INSURANCE(policy_id),
  CONSTRAINT payout_allocation_fk2 FOREIGN KEY (b_customer_id) REFERENCES BENEFICIARY(b_customer_id)
);


#Part 2: Inserting values into the Database 
INSERT INTO CUSTOMER VALUES
("TFO62MQN8UH","Isabella Andrews","2017-03-14","male","dapibus@yahoo.com","+6572474769",TRUE,TRUE,FALSE,"Sagittis Ave.","862506"),
("SYT47KIG6YO","Basil Potter","1970-10-14","female","integer.eu@protonmail.net","+6518177724",TRUE,FALSE,FALSE,"Non Ave.","817300"),
("QLT73WLH8BC","Kibo Hendrix","1960-08-17","female","elementum.lorem@aol.couk","+6582402473",TRUE,FALSE,TRUE,"Sagittis Ave.","353800"),
("LVO96HNU3CQ","Sara Coffey","1980-04-07","male","massa.quisque@hotmail.edu","+6547782563",TRUE,TRUE,FALSE,"Neque Rd.","212750"),
("RTO62MOR7OS","Ahmed Reynolds","1957-10-11","male","primis.in@icloud.couk","+6585194463",FALSE,TRUE,TRUE,"Congue Ave.","676530"),
("OKB00CGH4BE","Kameko Phelps","1981-05-15","female","tortor.integer@yahoo.com","+6535372714",FALSE,TRUE,TRUE,"Volutpat Rd.","365400"),
("IUM52PSV7AT","Velma Moore","1990-07-16","male","cursus.vestibulum@yahoo.edu","+6513724864",FALSE,FALSE,TRUE,"Ullamcorper St.","602750"),
("BMY18MYQ8OL","Lareina Patel","2012-10-21","female","nunc.risus@icloud.net","+6592266206",FALSE,FALSE,FALSE,"Vestibulum St.","939500"),
("ORI28MIN0VM","Wynne Robles","2010-03-28","male","facilisis.facilisis.magna@yahoo.com","+6573318148",TRUE,TRUE,TRUE,"Ac Rd.","382638"),
("MZM58QNB8DQ","Cairo Lancaster","1983-12-16","male","fringilla@icloud.net","+6525714153",TRUE,FALSE,TRUE,"Eget Rd.","345234"),
("APZ74GOG8TW","Adara Arnold","1964-03-15","male","dolor.nonummy.ac@google.org","+6500327242",TRUE,FALSE,FALSE,"Tortor Ave.","722800"),
("QMU82BSB3WC","Gage Patrick","1994-03-20","male","ultrices.vivamus.rhoncus@icloud.ca","+6593502765",FALSE,TRUE,TRUE,"Dapibus Ave.","777300"),
("NOK61XZV2UK","Alfreda Peters","1983-07-10","female","orci.quis.lectus@hotmail.couk","+6563820960",FALSE,TRUE,FALSE,"Vulputate Ave.","472922"),
("RUC51FOY6WY","Jamal Guthrie","1973-01-28","male","non@aol.net","+6531421418",FALSE,TRUE,FALSE,"Sed Rd.","223100"),
("MFD07MSF6LJ","Linda Mack","2007-10-05","male","eu.turpis@outlook.com","+6553563363",FALSE,TRUE,FALSE,"Nullam St.","658330"),
("CDW86SLE7RK","Hedwig Coleman","1986-04-27","female","orci@hotmail.com","+6561689874",TRUE,FALSE,FALSE,"Tellus Rd.","952270"),
("SFU24KZP0QK","Dennis Hoffman","1975-01-13","male","ultrices.sit.amet@icloud.com","+6536116931",TRUE,TRUE,FALSE,"Sit St.","127640"),
("MXJ23TGA9XN","Felix Parsons","1957-07-11","male","maecenas.malesuada.fringilla@yahoo.edu","+6575146174",FALSE,TRUE,TRUE,"Id Rd.","895750"),
("BHE17HTU5EM","Nell Fowler","2018-12-05","female","urna.nullam@google.net","+6512918684",FALSE,FALSE,TRUE,"Nonummy Rd.","063100"),
("YDC29OZO6DD","Alden Cleveland","1952-04-02","male","lorem.ipsum@outlook.edu","+6555367515",TRUE,FALSE,TRUE,"Nec Rd.","844115");


INSERT INTO EMPLOYEE VALUES
(1713,"Keiko Reyes","1986-07-06","+6583641924","Underwriter","Phasellus St.",579,"438234"),
(1662,"Cruz May","1999-06-22","+6581978031","Underwriter","Molestie Avenue",596,"342342"),
(1259,"Fletcher Macdonald","1989-10-19","+6584766646","Underwriter","Hollysmith Ave",591,"234385"),
(1462,"Germaine Lawrence","1990-04-07","+6583464674","Insurance_Agent","Waterworld St.",700,"349583"),
(1560,"Bruce Buckner","1987-05-30","+6592214713","Insurance_Agent","Donec St.",575,"741334"),
(1921,"Lily Chen","1985-11-30","+6584924456","Underwriter","Swan Lake Rd.",623,"583492"),
(1754,"Oliver Moore","1982-02-16","+6582755712","Underwriter","Maplewood Dr.",595,"397583"),
(1802,"Sophia Jackson","1994-06-21","+6581209282","Insurance_Agent","Coral Reef Rd.",718,"284349"),
(1678,"Mason Thomas","1989-10-03","+6589315498","Underwriter","Sunset Blvd",645,"943855"),
(1795,"Isla Harris","1992-01-27","+6583607831","Insurance_Agent","Redwood Rd.",579,"854623"),
(1650,"Ethan Williams","1987-04-12","+6585476309","Underwriter","Tangerine St.",603,"659784"),
(1701,"Ava Brown","1995-09-18","+6583247658","Insurance_Agent","Blueberry Hill",624,"576492"),
(1645,"Mia Davis","1990-08-04","+6585097531","Underwriter","Lakeside Drive",567,"903876"),
(1832,"Leo Martinez","1988-11-12","+6588734029","Insurance_Agent","Oakwood St.",595,"734275");


INSERT INTO INSURANCE_AGENT VALUES
(1462, "36568147"),
(1560, "42375618"),
(1802, "78049633"),
(1795, "85029456"),
(1701, "52595929"),
(1832, "83607784");


INSERT INTO UNDERWRITER VALUES 
(1713, 20000),
(1662, 40000),
(1259, 120000),
(1921, 60000),
(1754, 140000),
(1678, 80000),
(1650, 160000),
(1645, 100000);


INSERT INTO POLICYHOLDER
VALUES 
('BHE17HTU5EM', '719-314172165', 'Other', 1802, 'JSBN978', NULL);

INSERT INTO POLICYHOLDER
VALUES 
('IUM52PSV7AT', '797-018516082', 'Others', 1560, 'IZTQ721', 'BHE17HTU5EM');

INSERT INTO POLICYHOLDER
VALUES 
('MXJ23TGA9XN', '180-549675641', 'Sibling', 1462, 'TUQH648', NULL);

INSERT INTO POLICYHOLDER
VALUES 
('MZM58QNB8DQ', '448-378438113', 'Parent', 1832, 'PYYT472', NULL),
('OKB00CGH4BE', '517-125110554', 'Parent', 1795, 'SUSX823', NULL),
('ORI28MIN0VM', '589-917571934', 'Sibling', 1701, 'CEHV436', NULL);

INSERT INTO POLICYHOLDER
VALUES 
('QLT73WLH8BC', '214-226400705', 'Guardian', 1560, 'RNNR981', 'OKB00CGH4BE'),
('QMU82BSB3WC', '027-314211752', 'Parent', 1795, 'IGJD153', 'MXJ23TGA9XN'),
('RTO62MOR7OS', '155-613747273', 'Sibling', 1802, 'RLUO358', NULL),
('YDC29OZO6DD', '545-531537764', 'Other', 1462, 'AEUQ806', 'MXJ23TGA9XN');
  
INSERT INTO BENEFICIARY VALUES
("TFO62MQN8UH","Spouse","763-438528842"),
("RTO62MOR7OS","Sibling","446-470433618"),
("OKB00CGH4BE","Parent","517-125110554"),
("QMU82BSB3WC","Parent","027-314211752"),
("NOK61XZV2UK","Parent","451-508362415"),
("RUC51FOY6WY","Other","127-472523681"),
("MFD07MSF6LJ","Spouse","333-803876322"),
("SFU24KZP0QK","Other","224-847834966"),
("LVO96HNU3CQ","Spouse","111-234567890"),
("MXJ23TGA9XN","Sibling","223-123456789"),
("ORI28MIN0VM","Sibling","789-987654321");

INSERT INTO INSURED VALUES
("APZ74GOG8TW", TRUE, "L&G MEDICAL CLINIC"), 
("CDW86SLE7RK", FALSE, "BARTLEY CLINIC"), 
("LVO96HNU3CQ", FALSE, "T MEDICAL CLINIC"), 
("MZM58QNB8DQ", TRUE, "T MEDICAL CLINIC"), 
("ORI28MIN0VM", TRUE, "BARTLEY CLINIC"), 
("QLT73WLH8BC", FALSE, "YAP FAMILY CLINIC"), 
("SFU24KZP0QK", TRUE, "T MEDICAL CLINIC"), 
("SYT47KIG6YO", TRUE, "YAP FAMILY CLINIC"), 
("TFO62MQN8UH", FALSE, "PANHEALTH FAMILY CLINIC"), 
("YDC29OZO6DD", FALSE, "YAP FAMILY CLINIC");


INSERT INTO PERSONAL_INSURANCE VALUES
('P001','2025-03-12','2025-04-01',39234,'Pending',NULL,'Health','YDC29OZO6DD','ORI28MIN0VM', 1662),
('P002','2020-03-15','2020-04-01',41234,'Expired','2024-04-02','Life','QMU82BSB3WC','QLT73WLH8BC', 1754),
('P003','2025-03-18','2025-04-20',23456,'Pending',NULL,'Health','OKB00CGH4BE','MZM58QNB8DQ', 1645),
('P004','2018-01-01','2018-01-15',54123,'Active',NULL,'Health','ORI28MIN0VM','YDC29OZO6DD', 1259),
('P005','2024-11-11','2024-12-01',45321,'Expired','2025-11-28','Life','YDC29OZO6DD','QLT73WLH8BC', 1678), 
('P006','2010-06-25','2010-07-10',36780,'Active',NULL,'Health','MZM58QNB8DQ','TFO62MQN8UH', 1921),
('P007','2025-03-17','2025-04-18',28945,'Pending',NULL,'Life','MZM58QNB8DQ','CDW86SLE7RK', 1662),
('P008','2025-03-16','2025-04-12',30212,'Pending',NULL,'Health','BHE17HTU5EM','SFU24KZP0QK', 1713),
('P009','2021-08-10','2021-08-25',56789,'Active',NULL,'Life','OKB00CGH4BE','ORI28MIN0VM', 1645),
('P010','2022-09-01','2022-09-15',12345,'Active',NULL,'Health','ORI28MIN0VM','MZM58QNB8DQ', 1662),
('P011','2025-03-01','2025-04-01',23456,'Pending',NULL,'Life','QMU82BSB3WC','SYT47KIG6YO', 1713),
('P012','2024-11-01','2024-11-15',45678,'Expired','2025-01-02','Health','QLT73WLH8BC','SYT47KIG6YO', 1754),
('P013','1985-04-01','1985-04-15',67890,'Expired','1989-12-09','Health','MXJ23TGA9XN','MZM58QNB8DQ', 1678),
('P014','2020-06-05','2020-06-20',10987,'Expired','2022-08-02','Health','IUM52PSV7AT','ORI28MIN0VM', 1259),
('P015','2018-03-16','2018-04-18',76543,'Pending',NULL,'Life','OKB00CGH4BE','LVO96HNU3CQ', 1645),
('P016','2003-07-25','2003-08-05',23412,'Expired','2006-07-06','Health','QLT73WLH8BC','QLT73WLH8BC', 1662),
('P017','2025-02-10','2025-02-25',54321,'Pending',NULL,'Life','MXJ23TGA9XN','APZ74GOG8TW', 1754),
('P018','2021-12-15','2022-01-01',67821,'Active',NULL,'Health','IUM52PSV7AT','ORI28MIN0VM', 1713),
('P019','2024-09-08','2024-09-20',98765,'Active',NULL,'Life','RTO62MOR7OS','SFU24KZP0QK', 1662),  
('P020','2024-05-18','2024-06-01',11223,'Active',NULL,'Health','MXJ23TGA9XN','SFU24KZP0QK', 1921);


INSERT INTO CLAIM VALUES
("d-59283368","2021-09-07",41234,"P002"),
("w-82655560","2025-01-01",45321,"P005"),
("b-42468402","1987-11-23",400,"P013"),
("d-37851127","2021-10-06",888,"P014"),
("j-34846751","1985-12-15",1865,"P013"),
("x-58713242","1987-06-10",500,"P013");


INSERT INTO LIFE VALUES
('P002', '2060-07-08', 1378),
('P005', '2073-10-20', 2329),
('P007', '2057-09-26', 3879),
('P009', '2065-02-04', 9376),
('P011', '2069-01-13', 5778),
('P015', '2072-11-09', 4887),
('P017', '2056-04-22', 7655),
('P019', '2075-07-14', 3513);


INSERT INTO HEALTH VALUES
('P001','Premium',3141.60),
('P003','Basic',1102.63),
('P004','Premium',2100.52),
('P006','Basic',504.95),
('P008','Luxury',8045.50),
('P010','Premium',1800.25),
('P012','Basic',1200.50),
('P013','Basic',1050.50),
('P014','Luxury',9200.75),
('P016','Premium',3200.90),
('P018','Basic',750.40),
('P020','Luxury',10500.30);


INSERT INTO PAYMENT VALUES
('A1B2C3', 1293, '2020-03-29', 'Credit Card', 'P002'),
('D4E5F6', 1293, '2021-03-31', 'Credit Card', 'P002'),
('G7H8I9', 1293, '2022-03-30', 'Credit Card', 'P002'),
('J1K2L3', 1293, '2023-03-28', 'Credit Card', 'P002'),
('L4N5O6', 1293, '2024-03-31', 'Credit Card', 'P002'),
('A3K432', 3923, '2018-01-13', 'GIRO', 'P004'),
('D3F313', 3923, '2019-01-14', 'GIRO', 'P004'),
('V7W8X9', 3923, '2020-01-12', 'GIRO', 'P004'),
('Y1Z2A3', 3923, '2021-01-15', 'GIRO', 'P004'),
('B4C5D6', 3923, '2022-01-14', 'GIRO', 'P004'),
('E7F8G9', 3923, '2023-01-15', 'GIRO', 'P004'),
('H1I2J3', 3923, '2024-01-12', 'GIRO', 'P004'),
('Z3K4A1', 1891, '2024-11-12', 'GIRO', 'P005'),
('K1L2M3', 3230, '2010-07-09', 'Bank Transfer', 'P006'),
('N4O5P6', 3230, '2011-07-08', 'Bank Transfer', 'P006'),
('Q7R8S9', 3230, '2012-07-07', 'Bank Transfer', 'P006'),
('T1U2V3', 3230, '2013-07-10', 'Bank Transfer', 'P006'),
('W4X5Y6', 3230, '2014-07-11', 'Bank Transfer', 'P006'),
('Z7A8B9', 3230, '2015-07-08', 'Bank Transfer', 'P006'),
('C1D2E3', 3230, '2016-07-09', 'Bank Transfer', 'P006'),
('F4G5H6', 3230, '2017-07-07', 'Bank Transfer', 'P006'),
('I7J8K9', 3230, '2018-07-08', 'Bank Transfer', 'P006'),
('L1M2N3', 3230, '2019-07-09', 'Bank Transfer', 'P006'),
('O4P5Q6', 3230, '2020-07-10', 'Bank Transfer', 'P006'),
('R7S8T9', 3230, '2021-07-08', 'Bank Transfer', 'P006'),
('U1V2W3', 3230, '2022-07-07', 'Bank Transfer', 'P006'),
('X4Y5Z6', 3230, '2023-07-09', 'Bank Transfer', 'P006'),
('A7B8C9', 3230, '2024-07-10', 'Bank Transfer', 'P006'),
('D1E2F3', 5639, '2021-08-23', 'PayNow', 'P009'),
('G4H5I6', 5639, '2022-08-24', 'PayNow', 'P009'),
('J7K8L9', 5639, '2023-08-25', 'PayNow', 'P009'),
('M1N2O3', 5639, '2024-08-22', 'PayNow', 'P009'),
('P1Q2R3', 1445, '2022-09-14', 'Credit Card', 'P010'),
('S4T5U6', 1445, '2023-09-15', 'Credit Card', 'P010'),
('Z1L4B2', 1445, '2024-09-12', 'Credit Card', 'P010'),
('J2K2L1', 1221, '2021-12-30', 'Credit Card', 'P018'),
('H1OL10', 1221, '2022-12-29', 'Credit Card', 'P018'),
('B21N1', 1221, '2023-12-30', 'Credit Card', 'P018'),
('J43D21', 1221, '2024-12-31', 'Credit Card', 'P018'),
('F22L11', 1331, '2024-05-30', 'PayNow', 'P020'),
('D1E2C3', 1754, '2024-11-08', 'Credit Card', 'P012'),
('G4H8I9', 1678, '1985-04-05', 'GIRO', 'P013'),
('J1K5L7', 1678, '1986-04-07', 'GIRO', 'P013'),
('M4N5O6', 1678, '1987-04-06', 'GIRO', 'P013'),
('N7O8P9', 1678, '1988-04-08', 'GIRO', 'P013'),
('F7G8H9', 1678, '1989-04-09', 'GIRO', 'P013'),
('I1J2K3', 1259, '2023-06-09', 'Bank Transfer', 'P014'),
('L4M5N6', 1259, '2024-06-11', 'Bank Transfer', 'P014'),
('Z7Q9A2', 1259, '2024-06-10', 'Bank Transfer', 'P014'),
('O7P8Q9', 1662, '2003-07-30', 'PayNow', 'P016'),
('R1S2T3', 1662, '2004-07-29', 'PayNow', 'P016'),
('U4V5W6', 1662, '2005-07-28', 'PayNow', 'P016'),
('B2H2A1', 1257, '2024-09-10', 'GIRO', 'P019');


INSERT INTO PAYOUT_ALLOCATION VALUES
('P001', 'TFO62MQN8UH', 100.00),
('P002', 'RTO62MOR7OS', 50.00),
('P002', 'OKB00CGH4BE', 50.00),
('P003', 'QMU82BSB3WC', 100.00),
('P004', 'MFD07MSF6LJ', 100.00),
('P005', 'OKB00CGH4BE', 100.00),
('P006', 'QMU82BSB3WC', 100.00),
('P007', 'RUC51FOY6WY', 33.33),
('P007', 'SFU24KZP0QK', 33.33),
('P007', 'TFO62MQN8UH', 33.33),
('P008', 'RTO62MOR7OS', 100.00),
('P009', 'SFU24KZP0QK', 100.00),
('P010', 'TFO62MQN8UH', 100.00),
('P011', 'OKB00CGH4BE', 33.33),
('P011', 'NOK61XZV2UK', 33.33),
('P011', 'MFD07MSF6LJ', 33.33),
('P012', 'RUC51FOY6WY', 100.00),
('P013', 'OKB00CGH4BE', 100.00),
('P014', 'RUC51FOY6WY', 100.00),
('P015', 'TFO62MQN8UH', 33.33),
('P015', 'NOK61XZV2UK', 33.33),
('P015', 'RTO62MOR7OS', 33.33),
('P016', 'MFD07MSF6LJ', 100.00),
('P017', 'SFU24KZP0QK', 100.00),
('P018', 'RTO62MOR7OS', 100.00),
('P019', 'NOK61XZV2UK', 33.33),
('P019', 'QMU82BSB3WC', 33.33),
('P019', 'RUC51FOY6WY', 33.33),
('P020', 'TFO62MQN8UH', 100.00);


#Part 3: Querying the Database 

#Query 1: Most profitable Insurance Agent
SELECT 
	i.i_employee_id, 
    e.name AS Agent_Name, 
    SUM(pi.insured_sum) AS TotalInsuredSum, 
    COUNT(*) AS NoOfPoliciesSold, 
    e.date_hired
FROM insurance_agent i
INNER JOIN employee e 
	ON i.i_employee_id = e.employee_id
INNER JOIN policyholder p 
	ON i.i_employee_id = p.i_employee_id
INNER JOIN personal_insurance pi
	ON pi.p_customer_id = p.p_customer_id
WHERE EXTRACT(year from pi.purchase_date) = 2024
GROUP BY i.i_employee_id, e.date_hired;


#Query 2: Referral Policy Evaluation & Incentive 
SELECT 
	pi.policy_id, 
    pi.insurance_type, 
    p.p_customer_id, 
    p.referred_policyholder_id, 
    pi.insured_sum, 
    pi.insured_sum * 0.02 AS Incentive
FROM personal_insurance pi
INNER JOIN policyholder p 
	ON pi.p_customer_id = p.p_customer_id
WHERE p.referred_policyholder_id IS NOT NULL;


#Query 3: Customers with a policy but no payment yet
SELECT DISTINCT 
	c.customer_id, 
    c.name, 
    pi.purchase_date, 
    pi.start_of_cover_date,
    pi.policy_status
FROM customer c
INNER JOIN personal_insurance pi 
	ON c.customer_id = pi.p_customer_id
LEFT JOIN payment p 
	ON pi.policy_id = p.policy_id  #We used LEFT JOIN because payment has not been made yet
WHERE p.policy_id IS NULL AND pi.start_of_cover_date < CURRENT_DATE(); 


#Query 4: Subquery targeted at current Health customers to purchase Life
SELECT DISTINCT 
	c.name, 
	c.phone_no, 
    pi.policy_status
FROM customer c, personal_insurance pi
WHERE c.customer_id = pi.p_customer_id AND pi.policy_status IN ('Active', 'Pending') AND
	name IN (SELECT c.name
			FROM customer c, personal_insurance pi
			WHERE c.customer_id = pi.p_customer_id AND pi.insurance_type = 'Health') AND 
	name NOT IN (SELECT c.name
				FROM customer c, personal_insurance pi
				WHERE c.customer_id = pi.p_customer_id AND pi.insurance_type <> 'Health'); 
															#same result as = 'Life' since only 2 types