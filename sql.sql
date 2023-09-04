CREATE TABLE persons (
  id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  email varchar(255),
  name varchar(255),
  ssn varchar(11)
);

INSERT INTO persons (email, name, ssn) VALUES ('testlarare@test.test', 'Test Läraresson', '761124-9876');
INSERT INTO persons (email, name, ssn) VALUES ('test1@test.test', 'Test1 Testsson', '960916-1234');
INSERT INTO persons (email, name, ssn) VALUES ('test2@test.test', 'Test2 Testsson', '010101-1234');
INSERT INTO persons (email, name, ssn) VALUES ('test3@test.test', 'Test3 Testsson', '050203-1234');
INSERT INTO persons (email, name, ssn) VALUES ('test4@test.test', 'Test1 Testsson', '020916-1234');
INSERT INTO persons (email, name, ssn) VALUES ('test5@test.test', 'Test2 Testsson', '990101-1234');
INSERT INTO persons (email, name, ssn) VALUES ('test6@test.test', 'Test3 Testsson', '120203-1234');
INSERT INTO persons (email, name, ssn) VALUES ('test7@test.test', 'Test1 Testsson', '090916-1234');
INSERT INTO persons (email, name, ssn) VALUES ('test8@test.test', 'Test2 Testsson', '070101-1234');
INSERT INTO persons (email, name, ssn) VALUES ('test9@test.test', 'Test3 Testsson', '080203-1234');

CREATE TABLE classes (
  id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name varchar(255),
  school varchar(255),
  teacher int
);

INSERT INTO classes (name, school, teacher) VALUES ('Klass 1', 'Skola 1', 1);
INSERT INTO classes (name, school, teacher) VALUES ('Klass 2', 'Skola 2', 1);

CREATE TABLE class_persons (
  id int NOT NULL PRIMARY KEY AUTO_INCREMENT,
  person_id int,
  class_id int,
  FOREIGN KEY (person_id) REFERENCES persons(id),
  FOREIGN KEY (class_id) REFERENCES classes(id)
);

INSERT INTO class_persons (person_id, class_id) VALUES (2, 1), (3, 2);
INSERT INTO class_persons (person_id, class_id) VALUES (4, 1), (5, 2);
INSERT INTO class_persons (person_id, class_id) VALUES (6, 1), (7, 2);
INSERT INTO class_persons (person_id, class_id) VALUES (8, 1), (9, 2);

DELIMITER //
CREATE FUNCTION age(ssn varchar(11)) RETURNS int DETERMINISTIC
BEGIN
 DECLARE age int;
 DECLARE date date;
  SELECT current_date() into date;
  SELECT DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), SUBSTRING(ssn, 1, 6))), '%Y') + 0 into age;
  RETURN age;
END;
//
DELIMITER ;

SELECT p.*, c.name AS klass FROM persons AS p 
	LEFT OUTER JOIN class_persons AS cp ON p.id = cp.person_id
    LEFT OUTER JOIN classes AS c ON c.id = cp.class_id
    WHERE p.id NOT IN (SELECT DISTINCT(teacher) FROM classes);

SELECT c.*, SUM(IF(age(p.ssn) >= 18, 1, 0)) AS myndig, SUM(IF(age(p.ssn) < 18, 1, 0)) AS omyndig FROM classes AS c
	LEFT JOIN class_persons AS cp ON cp.class_id = c.id
    LEFT JOIN persons AS p ON cp.person_id = p.id
    GROUP BY c.id;
