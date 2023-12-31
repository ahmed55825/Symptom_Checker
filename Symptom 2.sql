-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema symptom_checker
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema symptom_checker
-- -----------------------------------------------------
DROP DATABASE IF EXISTS symptom_checker;
CREATE SCHEMA IF NOT EXISTS `symptom_checker` DEFAULT CHARACTER SET utf8mb3 ;
USE `symptom_checker`;

-- -----------------------------------------------------
-- Table `symptom_checker`.`admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`admin` (
  `admin_id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NOT NULL,
  `Age` INT NOT NULL,
  `Gender` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`admin_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`doctor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`doctor` (
  `doctor_id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NOT NULL,
  `Age` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`doctor_id`),
  FOREIGN KEY (`user_id`)
    REFERENCES `symptom_checker`.`user` (`user_id`) on delete cascade
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NOT NULL,
  `Age` INT NOT NULL,
  `CNIC` VARCHAR(50) NOT NULL,
  `Phone` VARCHAR(50) NOT NULL,
  role ENUM('Doctor', 'General User', 'Admin') NOT NULL,
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`account` (
  `admin_id` INT NOT NULL,
  `doctor_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `Email` VARCHAR(50) NOT NULL,
  `Verification` VARCHAR(50) NOT NULL,
  INDEX `fk_Account_Admin1_idx` (`admin_id` ASC) VISIBLE,
  INDEX `fk_Account_Doctor1_idx` (`doctor_id` ASC) VISIBLE,
  INDEX `fk_Account_User1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_Account_Admin1`
    FOREIGN KEY (`admin_id`)
    REFERENCES `symptom_checker`.`admin` (`admin_id`),
  CONSTRAINT `fk_Account_Doctor1`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `symptom_checker`.`doctor` (`doctor_id`),
  CONSTRAINT `fk_Account_User1`
    FOREIGN KEY (`user_id`)
    REFERENCES `symptom_checker`.`user` (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`cure`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`cure` (
  `cure_id` INT NOT NULL AUTO_INCREMENT,
  `Name` TEXT NOT NULL,
  PRIMARY KEY (`cure_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`disease`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`disease` (
  `disease_id` INT NOT NULL AUTO_INCREMENT,
  `Medical History` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`disease_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`medical_reports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`medical_reports` (
  `reports_id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`reports_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`disease_reports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`disease_reports` (
  `disease_id` INT NOT NULL,
  `reports_id` INT NOT NULL,
  INDEX `fk_Disease_Reports_Medical_Reports1_idx` (`reports_id` ASC) VISIBLE,
  INDEX `fk_Disease_Reports_Disease1_idx` (`disease_id` ASC) VISIBLE,
  CONSTRAINT `fk_Disease_Reports_Disease1`
    FOREIGN KEY (`disease_id`)
    REFERENCES `symptom_checker`.`disease` (`disease_id`),
  CONSTRAINT `fk_Disease_Reports_Medical_Reports1`
    FOREIGN KEY (`reports_id`)
    REFERENCES `symptom_checker`.`medical_reports` (`reports_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`symptoms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`symptoms` (
  `symptom_id` INT NOT NULL AUTO_INCREMENT,
  `symptom_name` VARCHAR(50) NOT NULL,
  `Description` TEXT NOT NULL,
  PRIMARY KEY (`symptom_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`disease_symptoms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`disease_symptoms` (
  `Symptoms_oberved_date` DATE NOT NULL,
  `Diagnosis_Method` VARCHAR(50) NOT NULL,
  `Disease_disease_id` INT NOT NULL,
  `Symptoms_symptom_id` INT NOT NULL,
  INDEX `fk_Disease_Symptoms_Disease1_idx` (`Disease_disease_id` ASC) VISIBLE,
  INDEX `fk_Disease_Symptoms_Symptoms1_idx` (`Symptoms_symptom_id` ASC) VISIBLE,
  CONSTRAINT `fk_Disease_Symptoms_Disease1`
    FOREIGN KEY (`Disease_disease_id`)
    REFERENCES `symptom_checker`.`disease` (`disease_id`),
  CONSTRAINT `fk_Disease_Symptoms_Symptoms1`
    FOREIGN KEY (`Symptoms_symptom_id`)
    REFERENCES `symptom_checker`.`symptoms` (`symptom_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`speciality`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`speciality` (
  `speciality_id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`speciality_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`doctor_speciality`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`doctor_speciality` (
  `doctor_id` INT NOT NULL,
  `speciality_id` INT NOT NULL,
  INDEX `fk_Doctor_Speciality_Doctor1_idx` (`doctor_id` ASC) VISIBLE,
  INDEX `fk_Doctor_Speciality_Speciality1_idx` (`speciality_id` ASC) VISIBLE,
  CONSTRAINT `fk_Doctor_Speciality_Doctor1`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `symptom_checker`.`doctor` (`doctor_id`) ON delete cascade,
  CONSTRAINT `fk_Doctor_Speciality_Speciality1`
    FOREIGN KEY (`speciality_id`)
    REFERENCES `symptom_checker`.`speciality` (`speciality_id`)ON delete cascade)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`post` (
  `post_id` INT NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(50) NOT NULL,
  `Description` VARCHAR(50) NOT NULL,
  `Date` DATE NOT NULL,
  `doctor_id` INT NOT NULL,
  PRIMARY KEY (`post_id`),
  INDEX `fk_post_doctor1_idx` (`doctor_id` ASC) VISIBLE,
  CONSTRAINT `fk_post_doctor1`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `symptom_checker`.`doctor` (`doctor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`symptoms_cure`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`symptoms_cure` (
  `symptom_id` INT NOT NULL,
  `cure_id` INT NOT NULL,
  INDEX `fk_Symptoms_Cure_Symptoms1_idx` (`symptom_id` ASC) VISIBLE,
  INDEX `fk_Symptoms_Cure_Cure1_idx` (`cure_id` ASC) VISIBLE,
  CONSTRAINT `fk_Symptoms_Cure_Cure1`
    FOREIGN KEY (`cure_id`)
    REFERENCES `symptom_checker`.`cure` (`cure_id`),
  CONSTRAINT `fk_Symptoms_Cure_Symptoms1`
    FOREIGN KEY (`symptom_id`)
    REFERENCES `symptom_checker`.`symptoms` (`symptom_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `symptom_checker`.`user_disease`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `symptom_checker`.`user_disease` (
  `Name` VARCHAR(50) NOT NULL,
  `Description` TEXT NOT NULL,
  `user_id` INT NOT NULL,
  `disease_id` INT NULL DEFAULT NULL,
  INDEX `fk_User_Disease_User1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_User_Disease_Disease1_idx` (`disease_id` ASC) VISIBLE,
  CONSTRAINT `fk_User_Disease_Disease1`
    FOREIGN KEY (`disease_id`)
    REFERENCES `symptom_checker`.`disease` (`disease_id`),
  CONSTRAINT `fk_User_Disease_User1`
    FOREIGN KEY (`user_id`)
    REFERENCES `symptom_checker`.`user` (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



INSERT INTO symptoms ( symptom_name, Description) VALUE
  ("Fever "," Influenza, COVID-19, Malaria"),
  ("Cough "," Common cold, Bronchitis, Pneumonia"),
  ("Shortness of breath "," Asthma, Chronic obstructive pulmonary disease (COPD), Pulmonary embolism"),
  ("Chest pain "," Angina, Heart attack, Costochondritis"),
  ("Fatigue "," Chronic fatigue syndrome, Anemia, Hypothyroidism"),
  ("Headache "," Migraine, Tension headache, Sinusitis"),
  ("Muscle aches "," Influenza, Fibromyalgia, Polymyalgia rheumatica"),
  ("Joint pain "," Osteoarthritis, Rheumatoid arthritis, Gout"),
  ("Abdominal pain "," Gastritis, Appendicitis, Kidney stones"),
  ("Nausea "," Gastroenteritis, Migraine, Pregnancy"),
  ("Vomiting "," Food poisoning, Gastroenteritis, Norovirus"),
  ("Diarrhea "," Irritable bowel syndrome (IBS), Inflammatory bowel disease (IBD), Gastroenteritis"),
  ("Constipation "," Bowel obstruction, Irritable bowel syndrome (IBS), Medication side effects"),
  ("Weight loss "," Cancer, Hyperthyroidism, Diabetes"),
  ("Loss of appetite "," Depression, Liver disease, Gastrointestinal disorders"),
  ("Swollen lymph nodes "," Infection, Lymphoma, Autoimmune diseases"),
  ("Rash "," Allergic reaction, Eczema, Shingles"),
  ("Itching "," Allergic reaction, Dermatitis, Scabies"),
  ("Redness "," Conjunctivitis, Rosacea, Sunburn"),
  ("Night sweats "," Tuberculosis, Menopause, Lymphoma"),
  ("Chills "," Influenza, Urinary tract infection (UTI), Malaria"),
  ("Dizziness "," Vertigo, Inner ear infection, Low blood pressure"),
  ("Confusion "," Alzheimer's disease, Delirium, Stroke"),
  ("Memory problems "," Dementia, Mild cognitive impairment, Depression"),
  ("Vision changes "," Cataracts, Glaucoma, Macular degeneration"),
  ("Hearing loss "," Presbycusis, Noise-induced hearing loss, Ear infection"),
  ("Numbness or tingling "," Peripheral neuropathy, Carpal tunnel syndrome, Multiple sclerosis"),
  ("Difficulty swallowing "," Dysphagia, Esophageal stricture, Gastroesophageal reflux disease (GERD)"),
  ("Difficulty speaking "," Stroke, Brain tumor, Parkinson's disease"),
  ("Seizures "," Epilepsy, Febrile seizure, Brain injury"),
  ("Tremors "," Parkinson's disease, Essential tremor, Anxiety"),
  ("Weakness "," Anemia, Myasthenia gravis, Chronic fatigue syndrome"),
  ("Loss of coordination "," Multiple sclerosis, Stroke, Cerebellar ataxia"),
  ("Unexplained bleeding "," Hemophilia, Von Willebrand disease, Leukemia"),
  ("Easy bruising "," Vitamin K deficiency, Platelet disorders, Leukemia"),
  ("Palpitations "," Atrial fibrillation, Panic disorder, Hyperthyroidism"),
  ("Chest tightness "," Asthma, Angina, Panic attack"),
  ("Swelling in the legs or ankles "," Edema, Deep vein thrombosis (DVT), Heart failure"),
  ("Frequent urination "," Urinary tract infection (UTI), Diabetes, Overactive bladder"),
  ("Excessive thirst "," Diabetes, Dehydration, Hypercalcemia");
  
  -- ------------------------------------------------------------------------------------------          
  
  INSERT INTO cure(Name) VALUE
("Over-counter fever reducers"),
("resting"),
("staying hydrated"),
("Cough suppressants"),
("expectorants"),
("staying hydrated"),
(""),
("oxygen therapy"),
("pulmonary rehabilitation"),
(""),
(""),
("such as nitroglycerin for angina or emergency medical intervention for a heart attack"),
(""),
("improving sleep habits"),
("managing stress"),
("acetaminophen"),
("ibuprofen"),
("rest in a quiet"),
("applying heat or cold packs"),
("gentle stretching"),
("rest"),
(" acetaminophen"),
(" physical therapy"),
("joint injections"),
(""),
(""),
(" ranging from antacids for gastritis to surgery for appendicitis"),
("eating bland foods"),
("avoiding triggers"),
("staying hydrated"),
(""),
("staying hydrated"),
("avoiding solid foods until vomiting subsides"),
(""),
(" antidiarrheal medications (under medical guidance)"),
("avoiding certain foods and beverages"),
(" drinking plenty of fluids"),
("exercise"),
("over-counter laxatives if necessary"),
(" dietary changes"),
("increasing calorie intake"),
("working with a healthcare professional or dietitian"),
(" eating small"),
("frequent meals"),
("trying appetite"),
(" antibiotics for bacterial infections)"),
("over-counter pain relievers"),
("warm compresses"),
(" antihistamines"),
("identifyingavoiding triggers or allergens"),
("soothing creams"),
(" antihistamines"),
("avoiding irritants or allergens"),
("moisturizers"),
(" soothing creams or ointments"),
("avoiding triggers"),
("sunlight for photosensitivity"),
(" hormone therapy for menopause)"),
("adjusting bedroom temperature"),
("using moisture"),
(""),
(" dressing warmly"),
("using blankets or heating pads"),
(" maintaining hydration"),
("avoiding sudden movements"),
("staying in a safe position"),
(" medications for dementia)"),
("ensuring a safe environment"),
("providing supportreassurance"),
(" cognitive training exercises"),
("memory aids"),
("organizing strategies"),
(" medication for specific eye conditions"),
("regular eye check"),
("surgical interventions (if applicable)"),
(" cochlear implants (for severe hearing loss)"),
("assistive listening devices"),
("communication strategies"),
(" medications for neuropathy or addressing vitamin deficiencies)"),
("nerve stimulation techniques"),
("physical therapy"),
(" dietary modifications"),
("soft or pureed foods"),
("swallowing therapy"),
(""),
(""),
(" speech therapy for stroke"),
(" lifestyle modifications"),
("sleep hygiene"),
("stress management"),
(" physical therapy"),
("deep brain stimulation (in severe cases)"),
("lifestyle changes"),
(" physical therapy"),
("lifestyle modifications"),
("occupational therapy"),
(" physical therapy"),
("balance exercises"),
("occupational therapy"),
(" clotting factor replacement for hemophilia)"),
("medications to manage bleeding disorders"),
("surgical interventions (if necessary)"),
(""),
(" protecting the skin from injury"),
("maintaining good nutrition"),
(" lifestyle modifications (e.g."),
("avoiding stimulants"),
("stress reduction"),
(" bronchodilators for asthma)"),
("managing triggers"),
("relaxation techniques"),
(" diuretics for edema or lifestyle changes for venous insufficiency)"),
("compression stockings"),
("elevation of legs"),
(" lifestyle modifications (e.g."),
("bladder training"),
("fluid management"),
(" maintaining hydration"),
("diabetes"),
("managing any underlying conditions");

-- ----------------------------------------------------------------------------------------- 
INSERT INTO symptoms_cure(symptom_id, cure_id) VALUE
    (1,1),
	(1,2),
	(1,3),
	(2,4),
	(2,5),
	(2,6),
	(3,7),
	(3,8),
	(3,9),
	(4,10),
	(4,11),
	(4,12),
	(5,13),
	(5,14),
	(5,15),
	(6,16),
	(6,17),
	(6,18),
	(7,19),
	(7,20),
	(7,21),
	(8,22),
	(8,23),
	(8,24),
	(9,25),
	(9,26),
	(9,27),
	(10,28),
	(10,29),
	(10,30),
	(11,31),
	(11,32),
	(11,33),
	(12,34),
	(12,35),
	(12,36),
	(13,37),
	(13,38),
	(13,39),
	(14,40),
	(14,41),
	(14,42),
	(15,43),
	(15,44),
	(15,45),
	(16,46),
	(16,47),
	(16,48),
	(17,49),
	(17,50),
	(17,51),
	(18,52),
	(18,53),
	(18,54),
	(19,55),
	(19,56),
	(19,57),
	(20,58),
	(20,59),
	(20,60),
	(21,61),
	(21,62),
	(21,63),
	(22,64),
	(22,65),
	(22,66),
	(23,67),
	(23,68),
	(23,69),
	(24,70),
	(24,71),
	(24,72),
	(25,73),
	(25,74),
	(25,75),
	(26,76),
	(26,77),
	(26,78),
	(27,79),
	(27,80),
	(27,81),
	(28,82),
	(28,83),
	(28,84),
	(29,85),
	(29,86),
	(29,87),
	(30,88),
	(30,89),
	(30,90),
	(31,91),
	(31,92),
	(31,93),
	(32,94),
	(32,95),
	(32,96),
	(33,97),
	(33,98),
	(33,99),
	(34,100),
	(34,101),
	(34,102),
	(35,103),
	(35,104),
	(35,105),
	(36,106),
	(36,107),
	(36,108),
	(37,109),
	(37,110),
	(37,111),
	(38,112),
	(38,113),
	(38,114),
	(39,115),
	(39,116),
	(39,117),
	(40,118),
	(40,119),
	(40,120);
    
    
INSERT INTO user (Name, Age, Phone, CNIC, role) VALUE
	("Mukhtar Ahmed", 21, "03020181856", "97389234892", "Admin" ),
    ("Maaz Ahmed", 19, "2168466554", "97389234892", "Admin" ),
    ("Beta", 45, "38947823", "223233", "Doctor" ),
    ("Syed Zahaab Hussain", 20, "23893", "338392", "General User" );
    
INSERT INTO doctor (Name, Age, user_id) VALUE
	("Beta", 45, 2);
    
INSERT INTO speciality (Name) VALUE
	("Cardiology"),
    ("Neurology"),
    ("Oncology"),
    ("Gastroenterology"),
    ("Orthopedics"),
    ("Dermatology");