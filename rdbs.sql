CREATE DATABASE IF NOT EXISTS RDBS;
USE RDBS;

CREATE TABLE Gender(
	gender_id INT NOT NULL PRIMARY KEY,
    pohlavi ENUM('muz', 'zena') NOT NULL
    );
    
INSERT INTO Gender (gender_id, pohlavi)
VALUES
  (1, 'muz'),
  (2, 'zena');
  
  CREATE TABLE Psychologicke_profily(
	profil_id INT NOT NULL PRIMARY KEY,
	diagnoza VARCHAR(50)
	); 
    
    INSERT INTO Psychologicke_profily (profil_id, diagnoza)
	VALUES 
	(1, 'Antisocial Personality Disorder'),
	(2, 'Schizophrenia'),
	(3, 'Psychopathy'),
	(4, 'Munchausen syndrome by proxy'),
    (5, 'Depression'),
	(6, 'Paranoid Personality Disorder');
    
    CREATE TABLE Zbrane(
    zbrane_id INT NOT NULL PRIMARY KEY,
    druh_zbrane VARCHAR(50)
    );
    
    INSERT INTO Zbrane (zbrane_id, druh_zbrane)
	VALUES 
	(1, 'Nuz'),
	(2, 'Palna zbran'),
	(3, 'Jed'),
	(4, 'Provaz'),
    (5, 'Uskrceni'),
	(6, 'Sekera'),
    (7, 'Muceni');
    
    CREATE TABLE Typ_zbrane (
    typ_z_id INT NOT NULL PRIMARY KEY,
    nazev_typu_z VARCHAR(49) NOT NULL,
    parent_id INT,
    
	CONSTRAINT parent_id_fk FOREIGN KEY (parent_id) 
	REFERENCES Typ_zbrane (typ_z_id)
    );
    
INSERT INTO Typ_zbrane(typ_z_id, nazev_typu_z, parent_id)
    VALUES
    (1, 'zbraň', NULL),                  
    (2, 'bodná zbraň', 1),               
    (3, 'střelná zbraň', 1),             
    (4, 'chemická zbraň', 1),            
    (5, 'škrticí zbraň', 1),             
    (6, 'sekací zbraň', 1),              
    (7, 'mučící nástroje', 1),
    (8, 'dýka', 2),
    (9, 'pistole', 3),
    (10, 'slzný plyn', 4),
    (11, 'sarin', 4),
    (12, 'garrota', 5),
    (13, 'sekera', 6),
    (14, 'škrtidlo', 5),
    (15, 'mačeta', 6),
    (16, 'palečnice', 7),
    (17, 'kopí', 2),
    (18, 'puška', 3),
    (19, 'zelezná panna', 7);

    
    CREATE TABLE Zemi (
    zemi_id INT NOT NULL PRIMARY KEY,
    nazev_zemi VARCHAR(49)
    );
    DROP TABLE Zemi;
    
    INSERT INTO Zemi (zemi_id, nazev_zemi)
    VALUES
    (1, 'USA'),
    (2, 'Kanada'),
    (3, 'Japonsko'),
    (4, 'Rusko'),
    (5, 'Ceskoslovensko'),
    (6, 'Brazilie'),
    (7, 'Anglie'),
    (8, 'Kolumbie'),
    (9, 'Pakistan');
    
    
    CREATE TABLE Zabijaci (
	zabijaci_id INT NOT NULL PRIMARY KEY,
	full_name VARCHAR(104),
	vek_doziti INT NOT NULL,
	gender_id INT NOT NULL,
	misto_naroz VARCHAR(50),
    profil_id INT NULL,
    zbrane_id INT NOT NULL,
    
    CONSTRAINT gender_id_fk FOREIGN KEY (gender_id) 
	REFERENCES Gender (gender_id),
    
    CONSTRAINT profil_id_fk FOREIGN KEY (profil_id) 
	REFERENCES psychologicke_profily (profil_id),
    
    CONSTRAINT zbrane_id_fk FOREIGN KEY(zbrane_id)
    REFERENCES Zbrane(zbrane_id)
);

INSERT INTO Zabijaci (zabijaci_id, full_name, vek_doziti, gender_id, misto_naroz, profil_id, zbrane_id)
VALUES
(1, 'Theodore Bundy', 42, 1, 'USA', 1, 5),  
(2, 'Gertrude Baniszewski', 61, 2, 'USA', 5, 7),  
(3, 'Gerald Gallego', 56, 1, 'USA', NULL, 2),  
(4, 'Charlene Gallego', 67, 2, 'USA', NULL, 7),  
(5, 'Henry Wallace', 58, 1, 'USA', NULL, 5),  
(6, 'Aileen Wuornos', 46, 2, 'USA', 1, 2),  
(7, 'Dennis Rader', 79, 1, 'USA', NULL, 5),  
(8, 'David Berkowitz', 71, 1, 'USA', 2, 2),  
(9, 'Edmund Kemper', 75, 1, 'USA', 2, 2), 
(10, 'Richard Ramirez', 53, 1, 'USA', NULL, 2),  
(11, 'Ted Kaczynski', 81, 1, 'USA', 6, 2),  
(12, 'Bruce McArthur', 72, 1, 'Kanada', NULL, 5),  
(13, 'Karla Homolka', 53, 2, 'Kanada', NULL, 7),  
(14, 'Robert Pickton', 74, 1, 'Kanada', NULL, 7),  
(15, 'Tsutomu Miyazaki', 46, 1, 'Japonsko', 2, 5),
(16, 'Alexander Pichushkin', 49, 1, 'Rusko', 1, 1), 
(17, 'Mikhail Popkov', 59, 1, 'Rusko', NULL, 1), 
(18, 'Darya Saltykova', 71, 2, 'Rusko', NULL, 7), 
(19, 'Hubert Pilčík', 60, 1, 'Czech Republic', NULL, 3),  
(20, 'Václav Mrázek', 39, 1, 'Czech Republic', NULL, 5), 
(21, 'Pedro Rodrigues Filho', 71, 1, 'Brazilie', 1, 2),  
(22, 'Myra Hindley', 60, 2, 'Anglie', NULL, 7),  
(23, 'Luis Garavito', 67, 1, 'Kolumbie', 3, 5),  
(24, 'Javed Iqbal', 42, 1, 'Pakistan', NULL, 5),  
(25, 'Beverley Allitt', 56, 2, 'Anglie', 4, 3),  
(26, 'Amelia Dyer', 57, 2, 'Anglie', 3, 7); 

UPDATE Zabijaci
SET misto_naroz = 'Ceskoslovensko' WHERE misto_naroz = 'Ceska Republika';


CREATE TABLE Psych_Zabijaci(
	profil_id INT NOT NULL,
    zabijaci_id INT NOT NULL,
    PRIMARY KEY (profil_id, zabijaci_id),
    
    CONSTRAINT fk_profil_id FOREIGN KEY (profil_id) 
	REFERENCES psychologicke_profily (profil_id),
    
    CONSTRAINT fk_zabijaci_id FOREIGN KEY (zabijaci_id)
    REFERENCES Zabijaci (zabijaci_id)
);  

INSERT INTO Psych_Zabijaci (profil_id, zabijaci_id)
VALUES
(1, 1),  
(5, 2),   
(1, 6),  
(2, 8),  
(2, 9),  
(6, 11), 
(2, 15), 
(1, 16), 
(1, 21), 
(3, 23), 
(4, 25), 
(3, 26);

CREATE TABLE Pricina_smrti(	
	pricina_id INT NOT NULL PRIMARY KEY,
	reason VARCHAR(49)
    );
    
    INSERT INTO Pricina_smrti (pricina_id, reason)
	VALUES
	(1, 'Bodnuti'),
	(2, 'Strileni'),
	(3, 'Otrava'),
	(4, 'Uskrceni'),
	(5, 'Nasili');
    
CREATE TABLE Obeti(
	obeti_id INT NOT NULL PRIMARY KEY,
	full_name VARCHAR(104) NOT NULL,
	vek_doziti INT,
	gender_id INT NOT NULL, 
	misto_naroz VARCHAR(49),
	zabijaci_id INT NOT NULL,
	pricina_id INT NOT NULL,
    
    CONSTRAINT fk_gender_id FOREIGN KEY (gender_id)
    REFERENCES Gender (gender_id),
    
    CONSTRAINT zabijaci_f_k FOREIGN KEY (zabijaci_id)
    REFERENCES Zabijaci (zabijaci_id),
    
    CONSTRAINT pricina_id_fk FOREIGN KEY (pricina_id)
    REFERENCES Pricina_smrti (pricina_id)
);

INSERT INTO Obeti (obeti_id, full_name, vek_doziti, gender_id, misto_naroz, zabijaci_id, pricina_id)
VALUES
(1,  'Lynda Ann Healy', 21, 2, 'USA', 1, 4),
(2, 'Kimberly Leach', 12, 2, 'USA', 1, 4),
(3, 'Sylvia Likens', 16, 2, 'USA', 2, 5),
(4, 'Kippi Vaught', 16, 2, 'USA', 3, 2),
(5, 'Rhonda Scheffler', 17, 2, 'USA', 4, 5),
(6, 'Caroline Love', 20, 2, 'USA', 5, 4),
(7, 'Shawna Denise Hawk', 20, 2, 'USA', 5, 4),
(8, 'Richard Mallory', 51, 1, 'USA', 6, 2),
(9, 'Joseph Otero', 38, 1, 'USA', 7, 4),
(10, 'Julie Otero', 33, 2, 'USA', 7, 4),
(11, 'Donna Lauria', 18, 2, 'USA', 8, 2),
(12, 'Christine Freund', 26, 2, 'USA', 8, 2),
(13, 'Mary Ann Pesce', 19, 2, 'USA', 9, 2),
(14, 'Aiko Koo', 15, 2, 'USA', 9, 1),
(15, 'Jennie Vincow', 79, 2, 'USA', 10, 2),
(16, 'Mei Leung', 9, 2, 'USA', 10, 1),
(17, 'Hugh Scrutton', 38, 1, 'USA', 11, 2),
(18, 'Andrew Kinsman', 49, 1, 'Kanada', 12, 4),
(19, 'Selim Esen', 44, 1, 'Kanada', 12, 4),
(20, 'Kristen French', 15, 2, 'Kanada', 13, 5),
(21, 'Leslie Mahaffy', 14, 2, 'Kanada', 13, 5),
(22, 'Sereena Abotsway', 29, 2, 'Kanada', 14, 5),
(23, 'Mari Konno', 4, 2, 'Japonsko', 15, 4), 
(24, 'Sergei Kozhukhov', 42, 1, 'Rusko', 16, 1),    
(25, 'Svetlana Misochko', 32, 2, 'Rusko', 17, 1),
(26, 'Irina Guk', 20, 2, 'Rusko', 17, 1),
(27, 'Yelena Ivanova', 28, 2, 'Rusko', 18, 5),
(28, 'Emanuel Balley', 37, 1, 'Ceskoslovensko', 19, 3),
(29, 'Hana Choloubova', 15, 2, 'Ceskoslovensko', 20, 4), 
(30, 'Pedro Rodrigues Sr.', 47, 1, 'Brazilie', 21, 2),
(31, 'Lesley Ann Downey', 10, 2, 'Anglie', 22, 5),
(32, 'Anderson Roja', 12, 1, 'Kolumbie', 23, 4),
(33, 'Mohammad Imran', 13, 1, 'Pakistan', 24, 4),
(34, 'Timothy Hardwick', 11, 1, 'Anglie', 25, 3),
(35, 'Doris Marmon', 0, 1, 'Anglie', 26, 5); 

UPDATE Obeti
SET misto_naroz = 'Pakistan' WHERE misto_naroz = '9';
DESCRIBE Obeti;


CREATE TABLE Background_obeti(
	background_id INT NOT NULL PRIMARY KEY,
    obeti_id INT NOT NULL,
    zamestnani VARCHAR(49),
    rodina VARCHAR(104),
    
    CONSTRAINT obeti_id_fk FOREIGN KEY (obeti_id)
    REFERENCES Obeti (obeti_id)
);

INSERT INTO Background_obeti (background_id, obeti_id, zamestnani, rodina) 
VALUES
(1, 1, 'Studentka', 'Bydlení s rodinou'),  
(2, 2, 'Školačka', 'Bydlení s rodiči'), 
(3, 3, 'Školačka', 'Byla jedním z 5 dětí a měla blízký vztah se svou mladší sestrou'),  
(4, 4, 'Studentka', 'Bydlení s rodiči'),  
(5, 5, 'Studentka', 'Bydlení s rodiči'),  
(6, 6, 'Studentka a Manažerka', 'Bydlení se starší sestrou'), 
(7, 7, 'Studentka a Číšnice', 'Bydlení s maminkou'),  
(8, 8, 'Majitel obchodu s elektronikou', 'Měl kriminální minulost'),  
(9, 9, ' Mechanik', 'Manžel a otec 5. dětí'),  
(10, 10, 'Hospodyňka', 'Manželka a matka 5. dětí'),
(11, 11, 'Zdravotní technik na částečný úvazek', 'Bydlení s rodiči'), 
(12, 12, 'Sekretářka', 'Byla zasnoubená'),  
(13, 13, 'Studentka', 'Bydlení s rodinou'),  
(14, 14, 'Školačka', 'Bydlení s rodinou'), 
(15, 15, 'Důchodce', 'Bydlení sama'),  
(16, 16, 'Školačka', 'Bydlení s rodinou'),  
(17, 17, 'Majitel firmy', 'Ve své komunitě byl velmi respektován'),  
(18, 18, 'Sociální pracovnik a komunitní aktivist.', 'Bydlení s kamaradi'),  
(19, 19, 'Nezaměstnaný', 'Měl se svou rodinou napjatý vztah'),  
(20, 20, 'Studentka', 'Bydlení s rodinou'),  
(21, 21, 'Školačka', 'Bydlení s rodinou'),  
(22, 22, 'Nezaměstnana', 'Většinu svého života strávila v systému pěstounské péče'),  
(23, 23, 'Předškolačka', 'Bydlení s rodinou'),  
(24, 24, 'Nezaměstnaný', 'Bezdomovec'),  
(26, 26, 'Učitelka', 'Byla vdaná a měla děti'),  
(27, 27, 'Nezaměstnana', 'Byla mladá'),  
(28, 28, 'Student', 'Bydlení s rodinou'),  
(29, 29, 'Studentka', 'Bydlení s babickou'),  
(30, 30, 'Nezaměstnaný', 'Měl kriminální minulost'),
(31, 31, 'Školačka', 'Bydlení s rodinou'),
(32, 32, 'Dítě ulice,', 'Neznámý'),
(33, 33, 'Žebrák', 'Bezdomovec'),
(34, 34, 'Školak', 'Bydlení s rodinou'),
(35, 35, 'Miminko', 'Bydlení s matkou');

CREATE TABLE Zlociny(
	zlociny_id INT NOT NULL PRIMARY KEY,
    datum DATE,
    mesto VARCHAR(49),
    zabijaci_id INT NOT NULL,
    obeti_id INT NOT NULL,
    zbrane_id INT NOT NULL,
    
    CONSTRAINT zabijak_id FOREIGN KEY(zabijaci_id)
    REFERENCES Zabijaci (zabijaci_id),
    
    CONSTRAINT fk_obeti_id FOREIGN KEY(obeti_id)
    REFERENCES Obeti (obeti_id),
    
    CONSTRAINT zbrane_fk FOREIGN KEY(zbrane_id)
    REFERENCES Zbrane(zbrane_id)
);

INSERT INTO Zlociny (zlociny_id, datum, mesto, zabijaci_id, obeti_id, zbrane_id)
VALUES
    (1, '1974-02-01', 'Seattle', 1, 1, 5),      
    (2, '1978-02-09', 'Lake City', 1, 2, 5),    
    (3, '1965-10-26', 'Indianapolis', 2, 3, 7), 
    (4, '1980-06-24', 'Sacramento', 3, 4, 2),
    (5, '1980-07-17', 'Sacramento', 4, 5, 7),
    (6, '1992-06-15', 'Charlotte', 5, 6, 5), 
    (7, '1993-02-19', 'Charlotte', 5, 7, 5),
    (8, '1989-12-01', 'Daytona Beach', 6, 8, 2), 
    (9, '1974-01-15', 'Wichita', 7, 9, 5),      
    (10, '1976-07-29', 'Wichita', 7, 10, 5), 
    (11, '1977-01-30', 'The Bronx', 8, 11, 2),    
    (12, '1972-08-18', 'Queens', 8, 12, 2), 
    (13, '1972-09-14', 'Santa Cruz', 9, 13, 2), 
    (14, '1984-06-28', 'Santa Cruz', 9, 14, 2), 
    (15, '1984-04-10', 'Los Angeles', 10, 15, 2), 
    (16, '1985-12-11', 'San Francisco', 10, 16, 2), 
    (17, '2017-06-26', 'Sacramento', 11, 17, 2),   
    (18, '2017-04-14', 'Toronto', 12, 18, 5),   
    (19, '1992-01-04', 'Toronto', 12, 19, 5),
    (20, '1992-04-19', 'St. Catharines', 13, 20, 7),
    (21, '2001-08-01', 'Burlington', 13, 21, 7), 
    (22, '1988-08-22', 'Port Coquitlam', 14, 22, 7),    
    (23, '1992-09-20', 'Saitama', 15, 23, 5),     
    (24, '1994-01-15', 'Moskva', 16, 24, 1),     
    (25, '1994-03-18', 'Moskva', 17, 25, 1),     
    (26, '1762-07-14', 'St. Peterburg', 17, 26, 1),   
    (27, '1951-04-03', 'Moskva', 18, 27, 7),
    (28, '1957-04-21', 'Plzen', 19, 28, 3), 
    (29, '1973-05-18', 'Chomutov', 20, 29, 6), 
    (30, '1964-12-26', 'Brazilia', 21, 30, 2), 
    (31, '1998-10-04', 'Greater Manchester', 22, 31, 7),   
    (32, '1999-04-22', 'Valledupar', 23, 32, 5),   
    (33, '1999-02-24', 'Lahore', 24, 33, 5),  
    (34, '1991-03-05', 'Grantham', 25, 34, 3),
    (35, '1896-04-10', 'Reading', 26, 35, 7);
    
    UPDATE Zlociny
    SET mesto = 'Irkutsk' WHERE zabijaci_id = 17;
    UPDATE Zlociny
    SET mesto = 'Kazan' WHERE zabijaci_id = 18;
    
CREATE TABLE Zabijaci_Zlociny(
	zabijaci_id INT NOT NULL,
    zlociny_id INT NOT NULL,
    PRIMARY KEY(zabijaci_id, zlociny_id),
    
    CONSTRAINT zabijaci_ffk FOREIGN KEY (zabijaci_id)
    REFERENCES Zabijaci (zabijaci_id),
    
    CONSTRAINT fk_zlociny_id FOREIGN KEY (zlociny_id)
    REFERENCES Zlociny(zlociny_id)
);   

INSERT INTO Zabijaci_Zlociny (zabijaci_id, zlociny_id)
VALUES
(1, 1),  
(1, 2),  
(2, 3),  
(3, 4),  
(4, 5),  
(5, 6),  
(5, 7),
(6, 8),  
(7, 9),  
(7, 10),  
(8, 11),  
(8, 12),
(9, 13), 
(9, 14), 
(10, 15),  
(10, 16),  
(11, 17),  
(12, 18),  
(12, 19),  
(13, 20), 
(13, 21),   
(14, 22),  
(15, 23),  
(16, 24),  
(17, 25),
(17, 26),
(18, 27),
(19, 28),
(20, 29),
(21, 30),
(22, 31),
(23, 32),
(24, 33),
(25, 34),
(26, 35);

CREATE TABLE Vezeni(
	vezeni_id INT NOT NULL PRIMARY KEY,
	nazev_vezeni VARCHAR(49) NULL,
	lokace VARCHAR(49) NULL
);  

INSERT INTO Vezeni (vezeni_id, nazev_vezeni, lokace)
VALUES
(1, 'Věznice San Quentin', 'Kalifornie, USA'),   
(2, 'Věznice Indiana Women’s Prison', 'Indiana, USA'), 
(3, 'Věznice Folsom', 'Kalifornie, USA'),               
(4, 'Věznice Florida State Prison', 'Florida, USA'), 
(5, 'Věznice El Dorado', 'Kansas, USA'),            
(6, 'Věznice Rikers Island', 'New York, USA'),      
(7, 'Věznice Pelican Bay', 'Kalifornie, USA'),       
(8, 'Věznice ADX Florence', 'Colorado, USA'),     
(9, 'Věznice Supermax', 'Florence, Colorado, USA'), 
(10, 'Věznice Kingston', 'Ontario, Kanada'),         
(11, 'Věznice Grand Valley Institution', 'Ontario, Kanada'), 
(12, 'Věznice Pacific Institution', 'Britská Kolumbie, Kanada'), 
(13, 'Věznice Tokyo', 'Tokio, Japonsko'),
(14, 'Věznice Butyrka', 'Moskva, Rusko'),             
(15, 'Věznice Irkutsk', 'Irkutsk, Rusko'),          
(16, 'Věznice SIZO-6', 'Kazan, Rusko'),             
(17, 'Věznice Pankrác', 'Praha, Česká republika'),   
(18, 'Věznice Všehrdy', 'Všehrdy, Česká republika'),  
(19, 'Věznice Catanduvas', 'Brazílie'),                       
(20, 'Věznice La Picota', 'Bogotá, Kolumbie'),      
(21, 'Věznice Adiala', 'Lahore, Pákistán'),          
(22, 'Věznice Rampton', 'Nottingham, Anglie'),       
(23, 'Věznice Holloway', 'Londýn, Anglie');  
 
CREATE TABLE Zabijaci_Vezeni(
	zabijaci_id INT NOT NULL,
    vezeni_id INT NOT NULL,
    PRIMARY KEY(zabijaci_id, vezeni_id),
    
    CONSTRAINT zabijaci_fck FOREIGN KEY (zabijaci_id)
    REFERENCES Zabijaci (zabijaci_id),
    
    CONSTRAINT fk_vezeni_id FOREIGN KEY (vezeni_id)
    REFERENCES Vezeni(vezeni_id)
);

INSERT INTO Zabijaci_Vezeni (zabijaci_id, vezeni_id)
VALUES
(1, 1),  
(2, 2),  
(3, 3),  
(4, 1),  
(5, 4),  
(6, 4),
(7, 5),  
(8, 6),  
(9, 7),  
(10, 8),  
(11, 9),
(12, 10), 
(13, 11), 
(14, 12),  
(15, 13),  
(16, 14),  
(17, 15),  
(18, 16),  
(19, 17), 
(20, 18),   
(21, 19),  
(22, 23),  
(23, 20),  
(24, 21),
(25, 22),
(26, 23);

CREATE TABLE Terapie(
	terapie_id INT NOT NULL PRIMARY KEY,
    terapie VARCHAR(49)
    );

INSERT INTO Terapie (terapie_id, terapie) 
VALUES
(1, 'Cognitive Behavioral Therapy'),
(2, 'Individual Psychotherapy'),                           
(3, 'Group Therapy'),                   
(4, 'Psychiatric Evaluation'),  
(5, 'Dialectical Behavior Therapy'),                          
(6, 'Psychotherapy'),  
(7, 'Psychiatric Evaluation');

CREATE TABLE Zivot_potom(
	potom_id INT NOT NULL PRIMARY KEY,
    zabijaci_id INT NOT NULL,
    terapie_id INT NULL,
    vezeni_id INT NULL,
    
    CONSTRAINT zab_id_gk FOREIGN KEY (zabijaci_id)
    REFERENCES Zabijaci (zabijaci_id),
    
    CONSTRAINT vezeni_fUk FOREIGN KEY (vezeni_id)
    REFERENCES Vezeni (vezeni_id),
    
    CONSTRAINT terapie_fk FOREIGN KEY (terapie_id)
    REFERENCES Terapie (terapie_id)
);  

INSERT INTO Zivot_potom (potom_id, zabijaci_id, terapie_id, vezeni_id)
VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 3),
(4, 4, 1, 1),
(5, 5, 4, 5),
(6, 6, 5, 5),
(7, 7, 1, 6),
(8, 8, 6, 7),
(9, 9, 1, 8),
(10, 10, 3, 9),
(11, 11, 6, 10),
(12, 12, 1, 11),
(13, 13, NULL, 12),
(14, 14, 6, 13),
(15, 15, 2, 14),
(16, 16, NULL, 15),
(17, 17, NULL, 16),
(18, 18, 1, 17),
(19, 19, 1, 18),
(21, 21, 7, 19),
(22, 22, 2, 20),
(23, 23, 1, 23),
(24, 24, 4, 21),
(25, 25, NULL, 22),
(26, 26, 5, 23);
      
#SELECT
SELECT AVG(records_count) AS avg_records_per_table
FROM (
    SELECT COUNT(*) AS records_count FROM Zabijaci
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Zlociny
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Obeti
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Vezeni
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Zabijaci_Zlociny
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Zabijaci_Vezeni
    UNION ALL
	SELECT COUNT(*) AS records_count FROM Background_obeti
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Gender
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Pricina_smrti
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Psych_zabijaci
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Psychologicke_profily
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Terapie
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Zbrane
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Zemi
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Zivot_potom
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Zabijaci
    UNION ALL
    SELECT COUNT(*) AS records_count FROM Typ_zbrane
	) AS records;  #UNION ALL se používá k sloučení výsledků více SELECT dotazů do jednoho výsledku. (neodstranuje duplicity)
    
SELECT z.zabijaci_id, z.full_name
FROM Zabijaci z
WHERE z.zabijaci_id IN (
    SELECT o.zabijaci_id
    FROM Obeti o
    GROUP BY o.zabijaci_id
    HAVING COUNT(o.obeti_id) > 1
);

SELECT p.diagnoza, COUNT(z.zabijaci_id) AS diagnoza_count
FROM Zabijaci z
RIGHT JOIN Psychologicke_profily p ON p.profil_id = z.profil_id
GROUP BY p.profil_id
ORDER BY diagnoza_count DESC;

INSERT INTO Psychologicke_profily
VALUES
(7, 'Zadny');


#REKURZE 
WITH RECURSIVE Zbrane_Hierarchy AS (
    SELECT 
        typ_z_id,
        nazev_typu_z,
        parent_id,
        1 AS hierarchy_level
    FROM Typ_Zbrane WHERE parent_id IS NULL

    UNION ALL

    SELECT 
        t.typ_z_id,
        t.nazev_typu_z,
        t.parent_id,
        wh.hierarchy_level + 1 AS hierarchy_level
    FROM Typ_Zbrane t
    JOIN Zbrane_Hierarchy wh ON t.parent_id = wh.typ_z_id
)
SELECT * 
FROM Zbrane_Hierarchy
ORDER BY hierarchy_level, nazev_typu_z;

#VIEW
CREATE VIEW zab_profil_zbrane_view AS
SELECT 
    z.full_name AS Killer_Name,
    p.diagnoza AS Psychological_Profile,
    w.druh_zbrane AS Weapon_Used
FROM 
    Zabijaci z
LEFT JOIN 
    Psychologicke_profily p ON z.profil_id = p.profil_id
INNER JOIN 
    Zbrane w ON z.zbrane_id = w.zbrane_id;
    
SELECT * FROM rdbs.zab_profil_zbrane_view;
    
#INDEX
ALTER TABLE Obeti
ADD vekova_skupina VARCHAR(10) GENERATED ALWAYS AS (
	CASE
		WHEN vek_doziti < 18 THEN 'Dite'
		ELSE 'Dospely'
	END
) STORED;

CREATE INDEX idx_vekova_skupina
ON Obeti (vekova_skupina);

SELECT full_name, vek_doziti, vekova_skupina
FROM Obeti
WHERE vekova_skupina = 'Dite';

CREATE FULLTEXT INDEX idx_background
ON Background_obeti(rodina);

SELECT obeti_id, rodina
FROM Background_obeti
WHERE MATCH(rodina) AGAINST ('Bezdomovec | rodinou');

#FUNCTION
DELIMITER $$
CREATE FUNCTION deti_procenta()
RETURNS FLOAT
BEGIN
DECLARE
	pocet_lidi INT;
DECLARE
	pocet_deti INT;
    
SELECT COUNT(*) INTO pocet_lidi FROM Obeti;

SELECT COUNT(*) INTO pocet_deti FROM Obeti WHERE vekova_skupina='Dite';

RETURN ( pocet_deti * 100.0 / pocet_lidi );
END $$

DELIMITER ;
SELECT deti_procenta() AS Deti_Procenta;

#PROCEDURE
DROP PROCEDURE Pocet_Zlocinu;

DELIMITER $$

CREATE PROCEDURE Pocet_Zlocinu (IN full_name VARCHAR(40), OUT pocet_zlocinu INT)
BEGIN
    -- Declare variables
    DECLARE done INT DEFAULT 0;  -- for cursor control
    DECLARE exit_message VARCHAR(100);  -- error message
    
    -- Error handler for SQL exception
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET exit_message = 'Vznikla chyba. Vratim se zpatky.';  -- Custom error message
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = exit_message;  -- Raise custom error message
        ROLLBACK;  -- Rollback if there is an error
    END;
    
    -- Start a transaction
    START TRANSACTION;

    -- Attempt to count the records
    SELECT COUNT(*) INTO pocet_zlocinu 
    FROM Zlociny c
    JOIN Zabijaci k ON c.zabijaci_id = k.zabijaci_id
    WHERE k.full_name = full_name;
    
    -- If no records were found, raise an error manually
    IF pocet_zlocinu = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Vznikla chyba. Vratim se zpatky.';
    END IF;

    -- Commit if no error
    COMMIT;

END $$

DELIMITER ;


CALL Pocet_Zlocinu('Gerald Gallego', @pocet_zlocinu);
SELECT @pocet_zlocinu;

DELIMITER $$

CREATE PROCEDURE Pocet_Zabijaku_Zemi(IN zemi_name VARCHAR(50), OUT killer_count INT)
BEGIN
    #variables
    DECLARE done INT DEFAULT 0;           
    DECLARE zabijak_id INT;               
    
    # cursor
    DECLARE zabijak_cursor CURSOR FOR
    SELECT zabijaci_id                  
    FROM Zabijaci 
    WHERE misto_naroz = zemi_name;             

    # handlers
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;  

   #killer_count
    SET killer_count = 0;

    OPEN zabijak_cursor;

    #loop pro kazdy radek
    zabijak_loop: LOOP
        FETCH zabijak_cursor INTO zabijak_id;  -- Get the next killer ID
        IF done = 1 THEN                        -- If no more data, exit the loop
            LEAVE zabijak_loop;
        END IF;

        SET killer_count = killer_count + 1;   -- Increment the count for each killer
    END LOOP;
    
    CLOSE zabijak_cursor;
END $$

DELIMITER ;

CALL Pocet_Zabijaku_Zemi('Japonsko', @killer_count);
SELECT @killer_count;

#TRANSACTION --predelat
DELIMITER $$

START TRANSACTION;
CALL Pocet_Zabijaku_Zemi('Japonsko', @killer_count);

IF @killer_count < 2 THEN
    UPDATE Zabijaci
    SET misto_naroz = 'none';
    COMMIT;
ELSE
    ROLLBACK;
END IF$$

DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Oprava_Zbrane(IN zabijak_id INT, IN zbran_id INT)
BEGIN
	START TRANSACTION;
    UPDATE Zabijaci
    SET zbrane_id = zbran_id WHERE zabijaci_id = zabijak_id;
    
    IF zbran_id = (SELECT zbrane_id FROM Zabijaci WHERE zabijaci_id = zabijak_id) THEN
		COMMIT;
        ELSE
        ROLLBACK;
	END IF;
END$$

delimiter ;

CALL Oprava_Zbrane(2, 3);
#datum v Zlociny menit nebo ne
#udelat novou tabulku, ktera mi pomuze tam davat deti nebo dospeli pomoci transakce

CREATE TABLE Dospeli (
	id INT PRIMARY KEY,
    jmeno VARCHAR(40),
    vek INT NOT NULL
    );
    
DELIMITER $$
CREATE PROCEDURE Add_Adult(IN victim_id INT)
BEGIN
	DECLARE victim_name VARCHAR(40);
    DECLARE age_group VARCHAR(20);
    DECLARE age INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;
    
START TRANSACTION;

SELECT full_name, vekova_skupina, vek_doziti INTO victim_name, age_group, age
FROM Obeti WHERE obeti_id = victim_id;

IF age_group = 'Dospely' THEN
	INSERT INTO Dospeli(id, jmeno, vek) 
	VALUES (victim_id, victim_name, age);
	COMMIT;
ELSE
	ROLLBACK;
END IF;

END $$

DELIMITER ;

CALL Add_Adult(4);


#TRIGGER
CREATE TABLE Audit_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(10),  -- INSERT, UPDATE, DELETE
    zlociny_id INT,           -- ID of the record being modified
    old_data TEXT,            -- Old values (for updates)
    new_data TEXT,            -- New values (for updates or inserts)
    change_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER Zlociny_After
AFTER UPDATE ON Zlociny
FOR EACH ROW
BEGIN
INSERT INTO Audit_Log (action_type, zlociny_id, old_data, new_data, change_timestamp)
VALUES
	('UPDATE', 
	OLD.zlociny_id,
	CONCAT(
            'Old Datum: ', OLD.datum, 
            ', Old Mesto: ', OLD.mesto, 
            ', Old Zabijaci ID: ', OLD.zabijaci_id,
            ', Old Obeti ID: ', OLD.obeti_id,
            ', Old Zbrane ID: ', OLD.zbrane_id
        ),  -- Old data (before update)
	CONCAT(
            'New Datum: ', NEW.datum, 
            ', New Mesto: ', NEW.mesto, 
            ', Old Zabijaci ID: ', OLD.zabijaci_id,  -- Unchanged
            ', Old Obeti ID: ', OLD.obeti_id,  -- Unchanged
            ', Old Zbrane ID: ', OLD.zbrane_id  -- Unchanged
        ),  -- New data (after update)) 
        NOW()
        );
END $$
DELIMITER ;

#UPDATE Zlociny
#SET datum = '1974-03-09', mesto = 'Cali'
#WHERE zlociny_id = 1;

UPDATE Zlociny
SET datum = '1974-02-01', mesto = 'Seattle'
WHERE zlociny_id = 1;

#USER
CREATE USER 'Stazinka'@'localhost' IDENTIFIED BY 'hello';
DROP USER 'Stazinka'@'localhost';
CREATE ROLE 'read_write';
#DROP ROLE 'read_write';
GRANT SELECT, INSERT, UPDATE ON rdbs.* TO 'read_write';
GRANT 'read_write' TO 'Stazinka'@'localhost';
#GRANT SELECT, INSERT, UPDATE ON rdbs.* TO 'Stazinka'@'localhost';
REVOKE UPDATE ON rdbs.* FROM 'Stazinka'@'localhost';
SHOW GRANTS FOR 'Stazinka'@'localhost'; 

#SELECT * FROM rdbs.Zabijaci;
#DELETE FROM rdbs.Zabijaci;
#DROP DATABASE rdbs;

#LOCK
LOCK TABLES Zlociny WRITE, Zabijaci READ;
UPDATE Zabijaci
SET gender_id = 1 WHERE zabijaci_id = 1;
SELECT * FROM rdbs.Zabijaci;

UNLOCK TABLES;






 



 