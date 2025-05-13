CREATE DATABASE Academy1_1;
USE Academy1_1;
-- 1. Curators
CREATE TABLE Curators (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
);

-- 2. Faculties
CREATE TABLE Faculties (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

-- 3. Departments
CREATE TABLE Departments (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Building INT NOT NULL CHECK (Building BETWEEN 1 AND 5),
    Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing >= 0),
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
    FacultyId INT NOT NULL,
    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
);

-- 4. Groups
CREATE TABLE Groups (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Name NVARCHAR(10) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
    Year INT NOT NULL CHECK (Year BETWEEN 1 AND 5),
    DepartmentId INT NOT NULL,
    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);

-- 5. GroupsCurators
CREATE TABLE GroupsCurators (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    CuratorId INT NOT NULL,
    GroupId INT NOT NULL,
    FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
    FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);

-- 6. GroupsLectures
CREATE TABLE GroupsLectures (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    GroupId INT NOT NULL,
    LectureId INT NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
);

-- 7. GroupsStudents
CREATE TABLE GroupsStudents (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    GroupId INT NOT NULL,
    StudentId INT NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (StudentId) REFERENCES Students(Id)
);

-- 8. Subjects
CREATE TABLE Subjects (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
);

-- 9. Teachers
CREATE TABLE Teachers (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    IsProfessor BIT NOT NULL DEFAULT 0,
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Salary MONEY NOT NULL CHECK (Salary > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
);

-- 10. Lectures
CREATE TABLE Lectures (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Date DATE NOT NULL CHECK (Date <= GETDATE()),
    SubjectId INT NOT NULL,
    TeacherId INT NOT NULL,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

-- 11. Students
CREATE TABLE Students (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
    Rating INT NOT NULL CHECK (Rating BETWEEN 0 AND 5),
    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
);

-- Faculties
INSERT INTO Faculties (Name) VALUES 
('Engineering'),
('Humanities'),
('Sciences');

-- Departments
INSERT INTO Departments (Building, Financing, Name, FacultyId) VALUES 
(1, 100000, 'Computer Science', 1),
(2, 80000, 'Philosophy', 2),
(3, 120000, 'Physics', 3);

-- Curators
INSERT INTO Curators (Name, Surname) VALUES 
('Alice', 'Johnson'),
('Bob', 'Smith'),
('Carol', 'Davis');

-- Groups
INSERT INTO Groups (Name, Year, DepartmentId) VALUES 
('CS-101', 1, 1),
('PH-202', 2, 3),
('PHL-303', 3, 2);

-- GroupsCurators
INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES 
(1, 1),
(2, 2),
(3, 3);

-- Subjects
INSERT INTO Subjects (Name) VALUES 
('Algorithms'),
('Ethics'),
('Quantum Mechanics');

-- Teachers
INSERT INTO Teachers (IsProfessor, Name, Salary, Surname) VALUES 
(1, 'John', 5000, 'Williams'),
(0, 'Emily', 3500, 'Brown'),
(1, 'Daniel', 6000, 'Taylor');

-- Lectures
INSERT INTO Lectures (Date, SubjectId, TeacherId) VALUES 
('2025-03-01', 1, 1),
('2025-04-15', 2, 2),
('2025-02-20', 3, 3);

-- GroupsLectures
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES 
(1, 1),
(2, 3),
(3, 2);

-- Students
INSERT INTO Students (Name, Rating, Surname) VALUES 
('Michael', 5, 'Clark'),
('Sarah', 4, 'Lewis'),
('David', 3, 'Walker');

-- GroupsStudents
INSERT INTO GroupsStudents (GroupId, StudentId) VALUES 
(1, 1),
(2, 2),
(3, 3);

GO
SELECT Building FROM Departments
WHERE SUM(Departments.Financing)< 100000;

GO
SELECT Groups.Name FROM Groups
INNER JOIN Departments
ON Departments.Id = Groups.Id
WHERE Groups.Year=5 AND Departments.Name = 'Software Development';

GO
SELECT Groups.Name FROM Groups
INNER JOIN Students
ON Groups.Id = Students.Id
WHERE AVG(Students.Rating)>Students.Rating AND Groups.Name = 'D221';

GO
SELECT Teachers.Surname, Teachers.Name FROM Teachers
WHERE Teachers.IsProfessor=1 AND
Teachers.Salary>AVG(Teachers.Salary);

GO
SELECT Groups.Name FROM Groups
INNER JOIN Curators
ON Groups.Id = Curators.Id
WHERE COUNT(Curators.Id)>1;

GO
SELECT Groups.Name FROM Groups
INNER JOIN Students
ON Groups.Id = Students.Id
WHERE AVG(Students.Rating)<MIN(Students.Rating) AND Groups.Year=5;

GO
SELECT Faculties.Name FROM Faculties
INNER JOIN Departments
ON Faculties.Id = Departments.Id
WHERE Faculties.Name='Computer Science' AND
SUM(Departments.Financing)>SUM(Departments.Financing);

GO
SELECT Subjects.Name, Teachers.Name, Teachers.Surname FROM Subjects
INNER JOIN Teachers
ON Subjects.Id = Teachers.Id
INNER JOIN Lectures
ON Subjects.Id = Lectures.Id
WHERE COUNT(*)= MAX(Lectures.Id);

GO
SELECT Subjects.Name, Teachers.Name, Teachers.Surname FROM Subjects
INNER JOIN Teachers
ON Subjects.Id = Teachers.Id
INNER JOIN Lectures
ON Subjects.Id = Lectures.Id
WHERE COUNT(*)= MIN(Lectures.Id);

GO
SELECT COUNT(Students.Id) AS numbers, COUNT(Subjects.Id) AS numbers FROM Students,Subjects
INNER JOIN Departments
ON Subjects.Id = Departments.Id
WHERE Departments.Name = 'Software Development';