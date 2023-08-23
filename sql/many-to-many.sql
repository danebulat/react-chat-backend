-- Example of a many-to-many relationship

-- Student table
CREATE TABLE IF NOT EXISTS `Student` (
  `StudentID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(25),
  `LastName` VARCHAR(25),
  PRIMARY KEY (`StudentID`)
);

-- Course table
CREATE TABLE IF NOT EXISTS `Course` (
  `CourseID` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Code` VARCHAR(10) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `Name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`CourseID`)
);

-- Junction table
CREATE TABLE IF NOT EXISTS `CourseMembership` (
  `Student` INT UNSIGNED NOT NULL,
  `Course` SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (`Student`, `Course`),
  CONSTRAINT `Constr_CourseMembership_Student_fk`
    FOREIGN KEY `Student_fk` (`Student`) REFERENCES `Student` (`StudentID`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Constr_CourseMembership_Course_fk`
    FOREIGN KEY `Course_fk` (`Course`) REFERENCES `Course` (`CourseID`)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- find all students registere for a course
DELIMITER $$
CREATE PROCEDURE find_course_students(IN courseId INT)
BEGIN
  SELECT `Student`.*
  FROM `Student`
    JOIN `CourseMembership` ON `Student`.`StudentID` = `CourseMembership`.`Student`
  WHERE 
    `CourseMembership`.`Course` = courseId;
END $$
DELIMITER ;

-- insert some test data
INSERT INTO Student (FirstName, LastName) 
VALUES ('Bob', 'Trent'), 
       ('Rob', 'Dave'), 
       ('Tracy', 'Toole');

INSERT INTO Course (Code, Name)
VALUES ('CRS001', 'Course #1'),
       ('CRS002', 'Course #2');

-- Add students to courses
INSERT INTO CourseMembership (Student, Course)
VALUES (1, 1),
       (1, 2),
       (2, 1),
       (3, 1),
       (3, 2);

-- DROP PROCEDURE find_course_students;
