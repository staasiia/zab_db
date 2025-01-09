     
#SELECT
SELECT AVG(records_count) AS avg_records_per_table
FROM (
    SELECT COUNT(*) AS records_count FROM Zabijaci
    UNION ALL
    SELECT COUNT(*) FROM Zlociny
    UNION ALL
    SELECT COUNT(*) FROM Obeti
    UNION ALL
    SELECT COUNT(*) FROM Vezeni
    UNION ALL
    SELECT COUNT(*) FROM Zabijaci_Zlociny
    UNION ALL
    SELECT COUNT(*) FROM Zabijaci_Vezeni
    UNION ALL
	SELECT COUNT(*) FROM Background_obeti
    UNION ALL
    SELECT COUNT(*) FROM Gender
    UNION ALL
    SELECT COUNT(*) FROM Pricina_smrti
    UNION ALL
    SELECT COUNT(*) FROM Psych_zabijaci
    UNION ALL
    SELECT COUNT(*) FROM Psychologicke_profily
    UNION ALL
    SELECT COUNT(*) FROM Terapie
    UNION ALL
    SELECT COUNT(*) FROM Zbrane
    UNION ALL
    SELECT COUNT(*) FROM Zivot_potom
    UNION ALL
    SELECT COUNT(*) FROM Zabijaci
    UNION ALL
    SELECT COUNT(*) FROM Typ_zbrane
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






 



 
