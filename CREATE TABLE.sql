CREATE TABLE Gender(
	gender_id INT NOT NULL PRIMARY KEY,
    pohlavi ENUM('muz', 'zena') NOT NULL
    );
    
CREATE TABLE Psychologicke_profily(
	profil_id INT NOT NULL PRIMARY KEY,
	diagnoza VARCHAR(50)
	); 
    
CREATE TABLE Zbrane(
    zbrane_id INT NOT NULL PRIMARY KEY,
    druh_zbrane VARCHAR(50)
    );
    
CREATE TABLE Typ_zbrane (
    typ_z_id INT NOT NULL PRIMARY KEY,
    nazev_typu_z VARCHAR(49) NOT NULL,
    parent_id INT,
    
	CONSTRAINT parent_id_fk FOREIGN KEY (parent_id) 
	REFERENCES Typ_zbrane (typ_z_id)
    );
    
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

CREATE TABLE Psych_Zabijaci(
	profil_id INT NOT NULL,
    zabijaci_id INT NOT NULL,
    PRIMARY KEY (profil_id, zabijaci_id),
    
    CONSTRAINT fk_profil_id FOREIGN KEY (profil_id) 
	REFERENCES psychologicke_profily (profil_id),
    
    CONSTRAINT fk_zabijaci_id FOREIGN KEY (zabijaci_id)
    REFERENCES Zabijaci (zabijaci_id)
);  

CREATE TABLE Pricina_smrti(	
	pricina_id INT NOT NULL PRIMARY KEY,
	reason VARCHAR(49)
    );
    
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
ALTER TABLE Obeti
ADD vekova_skupina VARCHAR(10) GENERATED ALWAYS AS (
	CASE
		WHEN vek_doziti < 18 THEN 'Dite'
		ELSE 'Dospely'
	END
) STORED;

CREATE TABLE Background_obeti(
	background_id INT NOT NULL PRIMARY KEY,
    obeti_id INT NOT NULL,
    zamestnani VARCHAR(49),
    rodina VARCHAR(104),
    
    CONSTRAINT obeti_id_fk FOREIGN KEY (obeti_id)
    REFERENCES Obeti (obeti_id)
);

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

CREATE TABLE Zabijaci_Zlociny(
	zabijaci_id INT NOT NULL,
    zlociny_id INT NOT NULL,
    PRIMARY KEY(zabijaci_id, zlociny_id),
    
    CONSTRAINT zabijaci_ffk FOREIGN KEY (zabijaci_id)
    REFERENCES Zabijaci (zabijaci_id),
    
    CONSTRAINT fk_zlociny_id FOREIGN KEY (zlociny_id)
    REFERENCES Zlociny(zlociny_id)
);   

CREATE TABLE Vezeni(
	vezeni_id INT NOT NULL PRIMARY KEY,
	nazev_vezeni VARCHAR(49) NULL,
	lokace VARCHAR(49) NULL
);  

CREATE TABLE Zabijaci_Vezeni(
	zabijaci_id INT NOT NULL,
    vezeni_id INT NOT NULL,
    PRIMARY KEY(zabijaci_id, vezeni_id),
    
    CONSTRAINT zabijaci_fck FOREIGN KEY (zabijaci_id)
    REFERENCES Zabijaci (zabijaci_id),
    
    CONSTRAINT fk_vezeni_id FOREIGN KEY (vezeni_id)
    REFERENCES Vezeni(vezeni_id)
);

CREATE TABLE Terapie(
	terapie_id INT NOT NULL PRIMARY KEY,
    terapie VARCHAR(49)
    );
    
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

CREATE TABLE Dospeli (
	id INT PRIMARY KEY,
    jmeno VARCHAR(40),
    vek INT NOT NULL
    );
    
CREATE TABLE Audit_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(10),  -- INSERT, UPDATE, DELETE
    zlociny_id INT,           -- ID of the record being modified
    old_data TEXT,            -- Old values (for updates)
    new_data TEXT,            -- New values (for updates or inserts)
    change_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);