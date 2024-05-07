CREATE DATABASE IF NOT EXISTS AdmissionCommittee;
use AdmissionCommittee;

CREATE TABLE Post (
    ID_Post INT NOT NULL AUTO_INCREMENT,
    Post_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_Post)
);
-- Включаем опцию AUTO_INCREMENT для 'Post'
SET @@auto_increment_increment=1;

-- Заполнение данными таблицу 'Post'
INSERT INTO Post (Post_name)
VALUES ('Администратор'),
       ('Секретарь приемной комиссии'),
       ('Абитуриент');

SET @@auto_increment_increment=1;
-- Вывод данных из таблицы 'Post'
Select * from Post;

-- ----------------------------------------------------
CREATE TABLE Status (
    ID_Status INT PRIMARY KEY AUTO_INCREMENT,
    Status_Name VARCHAR(50) NOT NULL CHECK (Status_Name IN ('Поступил', 'Не проходит', 'Проходит', 'Отказ', 'На рассмотрении'))
);

-- Выключаем опцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
INSERT INTO Status (Status_Name)
	VALUES ('Поступил'),
       ('Не проходит'),
       ('Проходит'),
       ('На рассмотрении'),
	   ('Отказ');
-- Завершаем операцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
Select * from Status;

-- -------------------------------------------------------------------
CREATE TABLE Education_Form (
    ID_Education_Form INT PRIMARY KEY AUTO_INCREMENT,
    Form_Name VARCHAR(50) NOT NULL CHECK (Form_Name IN ('Внебюджетная', 'Бюджетная'))
);
-- Выключаем опцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
INSERT INTO Education_Form (Form_Name)
VALUES ('Внебюджетная'),
       ('Бюджетная');
-- Завершаем операцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
Select * from Education_Form;
-- ------------------------------------------------------------------------
CREATE TABLE Class (
    ID_Class INT PRIMARY KEY AUTO_INCREMENT,
    Class_Name VARCHAR(50) NOT NULL CHECK (Class_Name IN ('На базе 11-го', 'На базе 9-го'))
);
-- Выключаем опцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
INSERT INTO Class (Class_Name)
VALUES ('На базе 9-го'),
       ('На базе 11-го');
-- Завершаем операцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
Select * from Class;

-- -----------------------------------------------------------------------------------
CREATE TABLE DirectionOfSpecialization (
    ID_Direction INT PRIMARY KEY AUTO_INCREMENT,
    Direction_Code VARCHAR(10) NOT NULL unique,
	Direction_Name VARCHAR(100) NOT NULL unique
);
-- Выключаем опцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
INSERT INTO DirectionOfSpecialization (Direction_Code, Direction_Name)
VALUES ('54.03.01', 'Дизайн'),
       ('09.02.00', 'Прикладная информатика'),
       ('40.03.01', 'Юриспруденция'),
       ('19.03.04', 'Технология продукции и организации общественного питания');
-- Завершаем операцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
Select * from DirectionOfSpecialization;

CREATE TABLE Specialization (
    ID_Specialization INT PRIMARY KEY AUTO_INCREMENT,
    Specialty_Code VARCHAR(8) NOT NULL UNIQUE,
    Specialty_Name VARCHAR(100) NOT NULL UNIQUE,
    Qualification_Name VARCHAR(100) NOT NULL,
    Description VARCHAR(5000) NOT NULL, 
    Training_Duration VARCHAR(20) NOT NULL,
    Direction_ID INT NOT NULL,
    CONSTRAINT FK_Specialization_Direction FOREIGN KEY (Direction_ID)
        REFERENCES Specialization (ID_Specialization)
);

-- Выключаем опцию AUTO_INCREMENT
SET @@auto_increment_increment=1;

INSERT INTO Specialization (Specialty_Code, Specialty_Name, Qualification_Name, Description, Training_Duration, Direction_ID) 
VALUES 
('54.01.00', 'Изобразительное и прикладные виды искусств', 'Специалист по изобразительному искусству', 'Изучение различных техник искусства, создание произведений в различных стилях и направлениях. Работа с различными материалами и технологиями.', '4 года', 1),
('07.02.01', 'Архитектура', 'Архитектор', 'Проектирование и планирование архитектурных объектов. Изучение строительных технологий, материалов и дизайна. Работа с профессиональными программами.', '5 лет', 1),
('54.01.20', 'Графический дизайнер', 'Графический дизайнер', 'Разработка графических концепций и дизайна. Использование графических программ и технологий. Создание дизайна для печати и цифровых медиа.', '3,5 года', 1),
('54.02.01', 'Дизайн (по отраслям)', 'Дизайнер по отраслям', 'Разработка дизайна в специфических отраслях. Изучение требований и особенностей конкретной отрасли. Применение творческих решений.', '4 года', 1),
('09.02.00', 'Информатика и вычислительная техника и управления', 'Инженер по информатике и вычислительной технике', 'Разработка программного обеспечения, управление информационными системами, обслуживание компьютерной техники.', '4 года', 2),
('09.02.06', 'Сетевое и системное администрирование', 'Системный администратор', 'Настройка и обслуживание компьютерных сетей, серверов, обеспечение безопасности информации. Решение проблем сетевого взаимодействия.', '3,5 года', 2),
('09.02.01', 'Компьютерные системы и комплексы', 'Системный инженер', 'Проектирование и разработка компьютерных систем и комплексов. Изучение аппаратных и программных решений для компьютерных технологий.', '4 года', 2),
('09.02.07', 'Информационные системы и программирование', 'Программист', 'Разработка программных продуктов, программирование на различных языках. Анализ и оптимизация информационных систем.', '4 года', 2),
('40.02.01', 'Право и организация социального обеспечения', 'Юрист по социальному обеспечению', 'Изучение законодательства, организация социального обеспечения. Правовая поддержка и консультирование граждан.', '4 года', 3),
('40.02.02', 'Правоохранительная деятельность', 'Сотрудник правоохранительных органов', 'Обучение методам борьбы с преступностью, охрана общественного порядка, расследование преступлений. Защита прав и законных интересов.', '5 лет', 3),
('40.02.04', 'Юриспруденция', 'Юрист', 'Изучение юридических дисциплин, подготовка к профессиональной практике. Правовое консультирование и защита интересов в суде.', '4 года', 3),
('19.01.18', 'Аппаратчик-оператор производства продуктов питания из растительного сырья', 'Аппаратчик-оператор', 'Управление процессами производства пищевых продуктов из растительного сырья. Обеспечение качества и безопасности продукции.', '3,5 года', 4),
('19.02.00', 'Промышленная экология и биотехнологии', 'Специалист по промышленной экологии и биотехнологиям', 'Исследование и внедрение экологически чистых технологий. Работа с биотехнологическими процессами в промышленности.', '4 года', 4);

-- Завершаем операцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
Select * from Specialization;


-- -------------------------------------------------
CREATE TABLE Programs (
    ID_Program INT PRIMARY KEY AUTO_INCREMENT,
    Photo_URL VARCHAR(255),
    Education_Form_ID INT NOT NULL,
    Class_ID INT NOT NULL,
    Specialization_ID INT NOT NULL,
    CONSTRAINT FK_Programs_Education_Form FOREIGN KEY (Education_Form_ID)
        REFERENCES Education_Form (ID_Education_Form),
    CONSTRAINT FK_Programs_Class FOREIGN KEY (Class_ID)
        REFERENCES Class (ID_Class),
    CONSTRAINT FK_Programs_Specialization FOREIGN KEY (Specialization_ID)
        REFERENCES Specialization (ID_Specialization)
);
-- Выключаем опцию AUTO_INCREMENT
SET @@auto_increment_increment=1;

INSERT INTO Programs (Education_Form_ID, Class_ID, Specialization_ID, Photo_URL)
VALUES (2, 1, 1, 'https://static.tildacdn.com/tild6432-3035-4535-a364-303366656436/scale_1200-1-2.jpg' ),
		(1, 2, 2,'https://abrakadabra.fun/uploads/posts/2022-02/1644201390_1-abrakadabra-fun-p-arkhitektor-prezentatsiya-2.jpg' ),
		(2, 1, 2, 'https://abrakadabra.fun/uploads/posts/2022-02/1644201390_1-abrakadabra-fun-p-arkhitektor-prezentatsiya-2.jpg'),
		(2, 1,  3, 'https://ostrovrusa.ru/wp-content/uploads/2021/12/blobid1638023117252.jpg'),
		(1, 2,  3, 'https://ostrovrusa.ru/wp-content/uploads/2021/12/blobid1638023117252.jpg'),
		(2, 1,  4, 'https://architecture-and-design.ru/wp-content/uploads/e/a/c/eacd44dfc6ea95e82195950dbbd051d5.jpeg'),
		(1, 2,  4, 'https://architecture-and-design.ru/wp-content/uploads/e/a/c/eacd44dfc6ea95e82195950dbbd051d5.jpeg'),
		(2, 1,  5, 'https://mgutm.ru/wp-content/uploads/img/np/college/090205-prikladnaya-informatika.jpg'),
		(1, 2,  5, 'https://mgutm.ru/wp-content/uploads/img/np/college/090205-prikladnaya-informatika.jpg'),
		(2, 1,  6, 'https://itspectr.ru/wp-content/uploads/2021/09/aks1.jpg'),
		(1, 2,  6, 'https://itspectr.ru/wp-content/uploads/2021/09/aks1.jpg'),		
        (2, 1,  7, 'https://kamensk-uralyskiy.myguru.ru/img/cke/Master-remontiruet-PK-v-ofise.jpg'),
		(1, 2,  7, 'https://kamensk-uralyskiy.myguru.ru/img/cke/Master-remontiruet-PK-v-ofise.jpg'),
		(2, 1,  8,'https://cdn-ru.bitrix24.ru/b13797914/landing/3fd/3fdccf2ec2625a6d2d87429a6ac3f7d1/EaKEstDVAAIwU4e.jpg-large_1x.jpg'),
		(1, 2,  8, 'https://cdn-ru.bitrix24.ru/b13797914/landing/3fd/3fdccf2ec2625a6d2d87429a6ac3f7d1/EaKEstDVAAIwU4e.jpg-large_1x.jpg'),
		(2, 1,  9, 'https://clever-lady.ru/wp-content/uploads/2023/11/285dcc7a1ffa2d82446b21ba475333fd.jpg'),
		(1, 2,  9, 'https://clever-lady.ru/wp-content/uploads/2023/11/285dcc7a1ffa2d82446b21ba475333fd.jpg'),
		(2, 1,  10, 'https://gamebomb.ru/files/galleries/001/f/fa/419114.jpg'),
		(1, 2,  10, 'https://gamebomb.ru/files/galleries/001/f/fa/419114.jpg'),
		(2, 1,  11, 'https://do.ssau.ru/gos/pluginfile.php/21101/course/overviewfiles/608c2f443cdba866621589.jpg'),
		(1, 2,  11, 'https://do.ssau.ru/gos/pluginfile.php/21101/course/overviewfiles/608c2f443cdba866621589.jpg');

-- Завершаем операцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
Select * from Programs;

-- -----------------------------------------------
CREATE TABLE Places (
    ID_Place INT PRIMARY KEY AUTO_INCREMENT,
    Available_Seats INT NOT NULL,
    Programs_ID INT NOT NULL,
    CONSTRAINT FK_Places_Programs FOREIGN KEY (Programs_ID)
        REFERENCES Programs (ID_Program)
);
-- Выключаем опцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
INSERT INTO Places (Available_Seats, Programs_ID)
VALUES (5, 1),
		(10, 2 ),
		(5,  3),
		(25, 4),
		(20,  5),
		(25,  6),
		(15,  7),
		(10,  8),
		(15,  9),
		(10,  10),
		(20,  11),
		(10, 12),
		(5,  13),
		(25,  14),
		(15,  15),
		(10,  16),
		(15,  17),	
        (20, 18),
		(20,  19),
		(10,  20),
		(15,  21);
-- Завершаем операцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
Select * from Places;

-- ---------------------------------------------------------------
CREATE TABLE Administrator (
    ID_Administrator INT PRIMARY KEY AUTO_INCREMENT,
    Surname VARCHAR(50) NOT NULL,
    First_Name VARCHAR(50) NOT NULL,
    Middle_Name VARCHAR(50) NULL,
    Date_of_Birth DATE NOT NULL,  
    Login VARCHAR(50) UNIQUE NOT NULL,
    Password LONGTEXT NOT NULL,
    Post_ID INT NOT NULL,
    CONSTRAINT CHK_Password_Length_Ad CHECK (LENGTH(Password) BETWEEN 5 AND 255),
    CONSTRAINT CHK_Login_Length_Format_Ad CHECK (LENGTH(Login) >= 5 AND POSITION('@' IN Login) > 0 AND POSITION('.' IN SUBSTRING(Login, POSITION('@' IN Login)+1)) > 0),
	FOREIGN KEY (Post_ID) REFERENCES Post(ID_Post)
);

-- Выключаем опцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
INSERT INTO Administrator (Surname, First_Name, Middle_Name, Date_of_Birth, Login, Password, Post_ID) VALUES
('Ефремов', 'Виктор', 'Степанович', '1999-01-15', 'viktor2@mail.ru', 'gjEss123a!', 1),
('Исаева', 'Наталья', 'Петровна', '1998-05-22', 'natalyw3@mail.ru', 'Pas456f!', 1),
('Димидова', 'Анастасия', 'Павловна', '1978-02-26', 'anastas123@mail.ru', 'Pass!852i', 1),
('Иванов', 'Александр', 'Сергеевич', '1985-07-10', 'alex_ivanov@mail.ru', 'Pass123!', 2),
('Петрова', 'Екатерина', 'Дмитриевна', '1992-11-28', 'katya_petrov@mail.ru', 'K@tPetr789', 2),
('Смирнов', 'Дмитрий', 'Александрович', '1990-04-15', 'dmitry_smirv@mail.ru', 'Sm!rnov45', 2),
('Соколов', 'Андрей', 'Владимирович', '1980-10-01', 'andrey_sokolov@mail.ru', 'Sokol@ndr123', 1),
('Лебедева', 'Елена', 'Алексеевна', '1985-03-14', 'elena_lebedeva@mail.ru', 'Lebed!va456', 1),
('Федоров', 'Николай', 'Иванович', '1977-11-20', 'nikolay_fedorov@mail.ru', 'Fedorov777', 2),
('Иванова', 'Ольга', 'Сергеевна', '1995-06-18', 'olga_kozlova@mail.ru', 'Kozlova!321', 2),
('Кузнецова', 'Марина', 'Андреевна', '1988-09-03', 'marina_kuznt@mail.ru', 'M@r!nKuz72', 2);
-- Завершаем операцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
Select * from Administrator;

-- ---------------------------------------------
CREATE TABLE EmailAddresses (
    ID_Email INT PRIMARY KEY AUTO_INCREMENT,
    EmailAddress VARCHAR(255) NOT NULL UNIQUE,
	CONSTRAINT CHK_Email_Address_Format CHECK (LENGTH(EmailAddress) >= 5 AND POSITION('@' IN EmailAddress) > 0 AND POSITION('.' IN SUBSTRING(EmailAddress, POSITION('@' IN EmailAddress)+1)) > 0)
);

-- Выключаем опцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
INSERT INTO EmailAddresses (EmailAddress) VALUES ('kscerus@mail.ru');
Select * from EmailAddresses;

-- ---------------------------------------------

CREATE TABLE Abiturient (
    ID_Abiturient INT PRIMARY KEY AUTO_INCREMENT,
    Surname VARCHAR(50) NOT NULL,
    First_Name VARCHAR(50) NOT NULL,
    Middle_Name VARCHAR(50) NULL,
    Date_of_Birth DATE NOT NULL,  
    Login VARCHAR(50) UNIQUE NOT NULL,
    Password LONGTEXT NOT NULL,
	Post_ID INT NOT NULL DEFAULT 3,
    CONSTRAINT CHK_Password_Length_Ab CHECK (LENGTH(Password) BETWEEN 5 AND 255),
    CONSTRAINT CHK_Login_Length_Format_Ab CHECK (LENGTH(Login) >= 5 AND POSITION('@' IN Login) > 0 AND POSITION('.' IN SUBSTRING(Login, POSITION('@' IN Login)+1)) > 0),
	FOREIGN KEY (Post_ID) REFERENCES Post(ID_Post)
);

-- Выключаем опцию AUTO_INCREMENT
SET @@auto_increment_increment=1;

--  INSERT-запросов
INSERT INTO Abiturient (Surname, First_Name, Middle_Name, Date_of_Birth, Login, Password, Post_ID) VALUES
('Васильев', 'Иван', 'Савельевич', '2000-01-15', 'ivan123@mail.ru', 'Pass123a!', 3),
('Петров', 'Лев', 'Николаевич', '2004-05-22', 'petr456@mail.ru', 'Pass456f!', 3),
('Дробницкая', 'Ксения', 'Ивановна', '2004-10-18', 'kscerus@mail.ru', 'Pass789y!', 3),
('Алиев', 'Магомед', 'Рамазанович', '2004-09-10', 'magomed123@mail.ru', 'Pass!123a', 3),
('Козлов', 'Алексей', 'Сергеевич', '2006-03-30', 'alex123@mail.ru', 'Pass987!y', 3),
('Никитина', 'Екатерина', 'Александровна', '2007-11-05', 'ekaterina456@mail.ru', 'Pass!654y',  3),
('Васнецов', 'Дмитрий', 'Владимирович', '2001-06-18', 'dmitry789@mail.ru', 'Pass!321h', 3),
('Абасова', 'Фатима', 'Руслановна', '2005-05-03', 'fatima123@mail.ru', 'Pass!123a', 3),
('Андреева', 'Анна', 'Алексеевна', '2008-09-12', 'anna1andr@mail.ru', 'Pass789k!',  3),
('Григорьев', 'Сергей', 'Игоревич', '2003-02-25', 'sergei456@mail.ru', 'Pass15!9n', 3),
('Жуков', 'Павел', 'Николаевич', '2006-07-03', 'pavel789@mail.ru', 'Pass357s!', 3),
('Кузнецова', 'Ольга', 'Владимировна', '2007-12-08', 'olga123@mail.ru', 'Pass!852i', 3),
('Лебедев', 'Антон', 'Сергеевич', '2005-04-01', 'anton123@mail.ru', 'Pass!123j', 3),
('Смирнова', 'Мария', 'Викторовна', '2002-10-14', 'maria456@mail.ru', 'Pass456!m', 3),
('Федоров', 'Денис', 'Александрович', '2001-07-22', 'denis789@mail.ru', 'Pass789!f', 3),
('Меликова', 'Лейла', 'Эльдаровна', '2006-02-27', 'leyla456@mail.ru', 'Pass456!m', 3),
('Хасанов', 'Тимур', 'Маратович', '2003-10-18', 'timur789@mail.ru', 'Pass789!h', 3),
('Попова', 'Елизавета', 'Андреевна', '2003-11-28', 'elizaveta123@mail.ru', 'Pass!321e', 3),
('Морозов', 'Артем', 'Петрович', '2007-06-06', 'artem456@mail.ru', 'Pass456!t', 3),
('Волкова', 'Виктория', 'Николаевна', '2004-03-17', 'viktoria789@mail.ru', 'Pass789!w', 3),
('Емельянов', 'Максим', 'Игоревич', '2000-12-27', 'maxim123@mail.ru', 'Pass!123r', 3),
('Шарипов', 'Руслан', 'Ильясович', '2007-11-21', 'ruslan456@mail.ru', 'Pass456!s', 3),
('Магомедова', 'Амина', 'Магомедрасуловна', '2001-07-13', 'amina789@mail.ru', 'Pass789!m', 3),
('Исмаилов', 'Абдулла', 'Абдулхакович', '2002-03-29', 'abdulla123@mail.ru', 'Pass!123i', 3),
('Дадашева', 'Зарина', 'Алиевна', '2006-08-07', 'zarina456@mail.ru', 'Pass456!d', 3),
('Магомедов', 'Шамиль', 'Магомедович', '2005-01-23', 'shamil789@mail.ru', 'Pass789!m', 3),
('Соколова', 'Анастасия', 'Владимировна', '2006-08-09', 'anastasia456@mail.ru', 'Pass456!y', 3),
('Романов', 'Никита', 'Алексеевич', '2005-02-11', 'nikita789@mail.ru', 'Pass789!u', 3),
('Терехова', 'Анна', 'Сергеевна', '2007-09-20', 'anna123@mail.ru', 'Pass!123t', 3),
('Соловьев', 'Даниил', 'Викторович', '2003-05-30', 'danil456@mail.ru', 'Pass456!u', 3),
('Кузьмина', 'Юлия', 'Андреевна', '2002-01-07', 'yuliya789@mail.ru', 'Pass789!i', 3),
('Орлов', 'Илья', 'Петрович', '2004-12-16', 'ilya123@mail.ru', 'Pass!123o', 3),
('Семёнова', 'Елена', 'Николаевна', '2006-04-24', 'elena456@mail.ru', 'Pass456!p', 3),
('Борисов', 'Андрей', 'Александрович', '2001-09-05', 'andrey789@mail.ru', 'Pass789!a', 3),
('Ларионова', 'Наталья', 'Владимировна', '2007-11-13', 'natalya123@mail.ru', 'Pass!123s', 3),
('Михайлов', 'Кирилл', 'Игоревич', '2005-07-23', 'kirill456@mail.ru', 'Pass456!d', 3),
('Королёва', 'Дарья', 'Сергеевна', '2003-03-01', 'darya789@mail.ru', 'Pass789!f', 3),
('Мусаева', 'Айша', 'Магомедовна', '2007-12-11', 'aysha123@mail.ru', 'Pass!123m', 3),
('Голубев', 'Егор', 'Викторович', '2006-08-14', 'egor123@mail.ru', 'Pass!123g', 3),
('Фокина', 'Полина', 'Алексеевна', '2007-12-25', 'polina456@mail.ru', 'Pass456!h', 3);

-- Завершаем операцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
Select * from Abiturient;
-- --------------------------------------------
CREATE TABLE User_tokens (
    ID_token INT AUTO_INCREMENT PRIMARY KEY,
    Abiturient_ID INT,
	Admin_ID INT,
    access_token TEXT,
    refresh_token TEXT,
	FOREIGN KEY (Admin_ID) REFERENCES Administrator(ID_Administrator),
    FOREIGN KEY (Abiturient_ID) REFERENCES Abiturient(ID_Abiturient)
);
-- CREATE USER 'new_user'@'%' IDENTIFIED BY 'password';
-- GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, PROCESS, REFERENCES, INDEX, ALTER, SHOW DATABASES, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER ON *.* TO 'root'@'%' WITH GRANT OPTION;
-- ------------------------------------------------

CREATE TABLE Personal_Data (
    ID_Personal_Data INT PRIMARY KEY AUTO_INCREMENT,
    Gender VARCHAR(1) CHECK (Gender IN ('М', 'Ж')) NOT NULL,
    Phone_Number VARCHAR(16) NOT NULL unique,
    Series VARCHAR(255) NOT NULL,
    Number VARCHAR(255) NOT NULL ,
    Subdivision_Code VARCHAR(255) NOT NULL ,   
    Issued_By VARCHAR(255) NOT NULL,
    Date_of_Issue DATE NOT NULL,
    Actual_Residence_Address VARCHAR(255) NOT NULL,
    Registration_Address VARCHAR(255) NOT NULL,
    SNILS VARCHAR(255) NOT NULL unique,
    Abiturient_ID INT NOT NULL, 
	Photo_certificate VARCHAR(255) NOT NULL,
	Photo_passport VARCHAR(255) NOT NULL,
	CONSTRAINT CHK_Phone_number CHECK (Phone_number LIKE '+7(%' AND Phone_number LIKE '%)___-__-__'),
	FOREIGN KEY (Abiturient_ID) REFERENCES Abiturient(ID_Abiturient)
);

-- ----------------------------------------------------------

CREATE TABLE Applications (
    Application_ID INT PRIMARY KEY AUTO_INCREMENT,
    Submission_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Average_Student_Grade DECIMAL(5, 2),
    Discount ENUM('Есть', 'Нет') DEFAULT 'Нет',
	Original_Document ENUM('Есть', 'Нет') DEFAULT 'Нет',
    Abiturient_ID INT,
    Status_ID INT,
    Programs_ID INT,
    FOREIGN KEY (Abiturient_ID) REFERENCES Abiturient(ID_Abiturient),
    FOREIGN KEY (Status_ID) REFERENCES Status(ID_Status),
    FOREIGN KEY (Programs_ID) REFERENCES Programs(ID_Program)
);


-- Выключаем опцию AUTO_INCREMENT
SET @@auto_increment_increment=1;
INSERT INTO Applications (Submission_Date, Average_Student_Grade, Abiturient_ID, Status_ID, Programs_ID) VALUES
(CURRENT_TIMESTAMP, 4.8, 1, 4, 10),
(CURRENT_TIMESTAMP, 4.8, 1, 4, 13),
(CURRENT_TIMESTAMP, 4.5, 2, 4, 11),
(CURRENT_TIMESTAMP, 4.5, 2, 4, 14),
(CURRENT_TIMESTAMP, 4.6, 3, 4, 12),
(CURRENT_TIMESTAMP, 4.6, 3, 4, 15),
(CURRENT_TIMESTAMP, 4.3, 4, 4, 13),
(CURRENT_TIMESTAMP, 4.3, 4, 4, 16),
(CURRENT_TIMESTAMP, 4.9, 5, 4, 14),
(CURRENT_TIMESTAMP, 4.9, 5, 4, 17),
(CURRENT_TIMESTAMP, 4.7, 6, 4, 15),
(CURRENT_TIMESTAMP, 4.7, 6, 4, 18),
(CURRENT_TIMESTAMP, 4.1, 7, 4, 16),
(CURRENT_TIMESTAMP, 4.1, 7, 4, 19),
(CURRENT_TIMESTAMP, 4.8, 8, 4, 17),
(CURRENT_TIMESTAMP, 4.8, 8, 4, 20),
(CURRENT_TIMESTAMP, 4.2, 9, 4, 18),
(CURRENT_TIMESTAMP, 4.2, 9, 4, 21),
(CURRENT_TIMESTAMP, 4.7, 10, 4, 19),
(CURRENT_TIMESTAMP, 4.7, 10, 4, 1),
(CURRENT_TIMESTAMP, 4.8, 11, 4, 20),
(CURRENT_TIMESTAMP, 4.8, 11, 4, 2),
(CURRENT_TIMESTAMP, 4.5, 12, 4, 21),
(CURRENT_TIMESTAMP, 4.5, 12, 4, 3),
(CURRENT_TIMESTAMP, 4.6, 13, 4, 1),
(CURRENT_TIMESTAMP, 4.6, 13, 4, 4),
(CURRENT_TIMESTAMP, 4.3, 14, 4, 2),
(CURRENT_TIMESTAMP, 4.3, 14, 4, 5),
(CURRENT_TIMESTAMP, 4.9, 15, 4, 3),
(CURRENT_TIMESTAMP, 4.9, 15, 4, 6),
(CURRENT_TIMESTAMP, 4.7, 16, 4, 4),
(CURRENT_TIMESTAMP, 4.7, 16, 4, 7),
(CURRENT_TIMESTAMP, 4.1, 17, 4, 5),
(CURRENT_TIMESTAMP, 4.1, 17, 4, 8),
(CURRENT_TIMESTAMP, 4.8, 18, 4, 6),
(CURRENT_TIMESTAMP, 4.8, 18, 4, 9),
(CURRENT_TIMESTAMP, 4.2, 19, 4, 7),
(CURRENT_TIMESTAMP, 4.2, 19, 4, 10),
(CURRENT_TIMESTAMP, 4.7, 20, 4, 8),
(CURRENT_TIMESTAMP, 4.7, 20, 4, 11),
(CURRENT_TIMESTAMP, 4.5, 21, 4, 9),
(CURRENT_TIMESTAMP, 4.5, 21, 4, 12),
(CURRENT_TIMESTAMP, 4.6, 22, 4, 10),
(CURRENT_TIMESTAMP, 4.6, 22, 4, 13),
(CURRENT_TIMESTAMP, 4.3, 23, 4, 11),
(CURRENT_TIMESTAMP, 4.3, 23, 4, 14),
(CURRENT_TIMESTAMP, 4.9, 24, 4, 12),
(CURRENT_TIMESTAMP, 4.9, 24, 4, 15),
(CURRENT_TIMESTAMP, 4.7, 25, 4, 13),
(CURRENT_TIMESTAMP, 4.7, 25, 4, 16),
(CURRENT_TIMESTAMP, 4.1, 26, 4, 14),
(CURRENT_TIMESTAMP, 4.1, 26, 4, 17),
(CURRENT_TIMESTAMP, 4.8, 27, 4, 15),
(CURRENT_TIMESTAMP, 4.8, 27, 4, 18),
(CURRENT_TIMESTAMP, 4.2, 28, 4, 16),
(CURRENT_TIMESTAMP, 4.2, 28, 4, 19),
(CURRENT_TIMESTAMP, 4.7, 29, 4, 17),
(CURRENT_TIMESTAMP, 4.7, 29, 4, 20),
(CURRENT_TIMESTAMP, 4.5, 30, 4, 18),
(CURRENT_TIMESTAMP, 4.5, 30, 4, 21),
(CURRENT_TIMESTAMP, 4.6, 31, 4, 1),
(CURRENT_TIMESTAMP, 4.6, 31, 4, 2),
(CURRENT_TIMESTAMP, 4.3, 32, 4, 3),
(CURRENT_TIMESTAMP, 4.3, 32, 4, 4),
(CURRENT_TIMESTAMP, 4.9, 33, 4, 5),
(CURRENT_TIMESTAMP, 4.9, 33, 4, 6),
(CURRENT_TIMESTAMP, 4.7, 34, 4, 7),
(CURRENT_TIMESTAMP, 4.7, 34, 4, 8),
(CURRENT_TIMESTAMP, 4.1, 35, 4, 9),
(CURRENT_TIMESTAMP, 4.1, 35, 4, 10),
(CURRENT_TIMESTAMP, 4.8, 36, 4, 11),
(CURRENT_TIMESTAMP, 4.8, 36, 4, 12),
(CURRENT_TIMESTAMP, 4.2, 37, 4, 13),
(CURRENT_TIMESTAMP, 4.2, 37, 4, 14),
(CURRENT_TIMESTAMP, 4.7, 38, 4, 15),
(CURRENT_TIMESTAMP, 4.7, 38, 4, 16),
(CURRENT_TIMESTAMP, 4.5, 39, 4, 17),
(CURRENT_TIMESTAMP, 4.5, 39, 4, 18),
(CURRENT_TIMESTAMP, 4.6, 40, 4, 19),
(CURRENT_TIMESTAMP, 4.6, 40, 4, 20),
(CURRENT_TIMESTAMP, 4.3, 40, 4, 21);
-- Завершаем операцию AUTO_INCREMENT
SET @@auto_increment_increment=1;

select * from Applications;
        
-- ------------------------------------------

DELIMITER //

CREATE TRIGGER before_insert_Abiturient
BEFORE INSERT ON Abiturient
FOR EACH ROW
BEGIN
    IF NEW.Date_of_Birth >= CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Дата рождения не может быть в будущем';
    END IF;
END //

DELIMITER ;
-- ------------------------------------------------------------
DELIMITER //

CREATE TRIGGER before_insert_Administrator
BEFORE INSERT ON Administrator
FOR EACH ROW
BEGIN
    IF NEW.Date_of_Birth >= CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Дата рождения не может быть в будущем';
    END IF;
END //

DELIMITER ;

-- ------------------------------------------------------------
-- Триггер для 4 занчения статуса у заявки

DELIMITER //

CREATE TRIGGER SetDefaultStatus
BEFORE INSERT ON Applications
FOR EACH ROW
BEGIN
    SET NEW.Status_ID = IFNULL(NEW.Status_ID, 4);
END;

//

DELIMITER ;

-- Триггер для уникальности совместного значения Series и Number
DELIMITER $$
CREATE TRIGGER unique_series_number
BEFORE INSERT ON Personal_Data
FOR EACH ROW
BEGIN
    IF NEW.Series IS NOT NULL AND NEW.Number IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
            FROM Personal_Data
            WHERE Series = NEW.Series AND Number = NEW.Number
        ) THEN
            SET NEW.Series = NULL; 
            SET NEW.Number = NULL; 
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Комбинация серии и номера паспорта должны быть уникальными';
        END IF;
    END IF;
END$$
DELIMITER ;

-- Создание триггера для проверки, что дата выдачи не больше текущей даты
DELIMITER $$
CREATE TRIGGER check_date_of_issue
BEFORE INSERT ON Personal_Data
FOR EACH ROW
BEGIN
    IF NEW.Date_of_Issue > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Дата выдачи не может быть больше текущей даты';
    END IF;
END$$
DELIMITER ;
            
-- ТРИГЕРЫ для статисткии
DELIMITER $$
CREATE TRIGGER CountRegisteredUsersAfterInsert
AFTER INSERT
ON Administrator
FOR EACH ROW
BEGIN
    DECLARE totalUsers INT;
    SELECT COUNT(*) INTO totalUsers FROM Administrator;
    SELECT COUNT(*) INTO totalUsers FROM Abiturient;
END$$
DELIMITER ;

-- Абитуриент
DELIMITER $$
CREATE TRIGGER CountAbiturients
AFTER INSERT
ON Abiturient
FOR EACH ROW
BEGIN
    DECLARE totalAbiturients INT;
    SELECT COUNT(*) INTO totalAbiturients FROM Abiturient;
END$$
DELIMITER ;
SELECT COUNT(*) AS totalAbiturients FROM Abiturient;
-- ВСего
DELIMITER $$
CREATE TRIGGER CountRegisteredUsers
AFTER INSERT
ON Administrator
FOR EACH ROW
BEGIN
    DECLARE totalUsers INT;
    SELECT COUNT(*) INTO totalUsers FROM Administrator;
    SELECT COUNT(*) INTO totalUsers FROM Abiturient;
END$$
DELIMITER ;
-- ----------------------------------------------------

-- Создаем представление для поиска доступных мест для определенной программы
CREATE VIEW Passing_Grades AS
SELECT
    Places.Programs_ID,
    Places.Available_Seats,
    Sorted_Grades.Average_Student_Grade AS Passing_Grade
FROM
    Places
JOIN
    (
        SELECT
            ROW_NUMBER() OVER (PARTITION BY Programs_ID ORDER BY Average_Student_Grade DESC) AS RowNum,
            Average_Student_Grade,
            Programs_ID
        FROM
            Applications
    ) AS Sorted_Grades ON Places.Programs_ID = Sorted_Grades.Programs_ID
WHERE
    Places.Available_Seats = Sorted_Grades.RowNum;

SELECT *
FROM Passing_Grades WHERE Programs_ID = 3;
-- представление на общее количество

CREATE VIEW Application_Count AS
SELECT 
    Programs_ID,
    COUNT(*) AS Total_Count
FROM 
    Applications
GROUP BY 
    Programs_ID;
SELECT *
FROM Application_Count WHERE Programs_ID = 3;
-- 
-- Создаем представление для вывода оценок студентов по программе
CREATE VIEW Sorted_Grades AS
SELECT 
    Average_Student_Grade, Programs_ID
FROM 
    Applications
ORDER BY 
    Programs_ID, Average_Student_Grade DESC;

SELECT * FROM Sorted_Grades