

USE master;
DROP DATABASE IF EXISTS AviationGraphDB;
CREATE DATABASE AviationGraphDB;
USE AviationGraphDB;

CREATE TABLE Planes (
    id INT NOT NULL PRIMARY KEY,
    model NVARCHAR(100) NOT NULL,
    manufacturer NVARCHAR(100) NOT NULL,
    year INT NOT NULL,
    country NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE Airlines (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    country NVARCHAR(50) NOT NULL,
    year_founded INT NOT NULL,
    airline_type NVARCHAR(20) NOT NULL
) AS NODE;

CREATE TABLE Pilots (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    total_flight_hours INT DEFAULT 0,
    rank NVARCHAR(50) NOT NULL
) AS NODE;

CREATE TABLE FliesFor AS EDGE;
CREATE TABLE Employs AS EDGE;
CREATE TABLE Operates AS EDGE;

ALTER TABLE FliesFor
ADD CONSTRAINT EC_FliesFor CONNECTION (Planes TO Airlines);

ALTER TABLE Employs
ADD CONSTRAINT EC_Employs CONNECTION (Airlines TO Pilots);

ALTER TABLE Operates
ADD CONSTRAINT EC_Operates CONNECTION (Pilots TO Planes);

-- Заполнение таблицы Planes
INSERT INTO Planes (id, model, manufacturer, year, country) VALUES
(1, N'Boeing 737-800', N'Boeing', 2015, N'США'),
(2, N'Airbus A320neo', N'Airbus', 2020, N'Франция'),
(3, N'Sukhoi Superjet 100', N'Сухой', 2018, N'Россия'),
(4, N'Boeing 777-300ER', N'Boeing', 2017, N'США'),
(5, N'Airbus A350-900', N'Airbus', 2022, N'Франция'),
(6, N'Embraer E195-E2', N'Embraer', 2021, N'Бразилия'),
(7, N'Bombardier CRJ900', N'Bombardier', 2019, N'Канада'),
(8, N'COMAC C919', N'COMAC', 2023, N'Китай'),
(9, N'Ан-148', N'Антонов', 2016, N'Украина'),
(10, N'Ил-96-400М', N'Ильюшин', 2020, N'Россия');

-- Заполнение таблицы Airlines
INSERT INTO Airlines (id, name, country, year_founded, airline_type) VALUES
(1, N'Aeroflot', N'Россия', 1923, N'flag carrier'),
(2, N'Delta Air Lines', N'США', 1924, N'flag carrier'),
(3, N'Emirates', N'ОАЭ', 1985, N'flag carrier'),
(4, N'Air France', N'Франция', 1933, N'flag carrier'),
(5, N'Ryanair', N'Ирландия', 1984, N'low-cost'),
(6, N'S7 Airlines', N'Россия', 1992, N'regional'),
(7, N'Qatar Airways', N'Катар', 1993, N'flag carrier'),
(8, N'Lufthansa', N'Германия', 1953, N'flag carrier'),
(9, N'Ural Airlines', N'Россия', 1943, N'regional'),
(10, N'British Airways', N'Великобритания', 1974, N'flag carrier');

-- Заполнение таблицы Pilots
INSERT INTO Pilots (id, name, total_flight_hours, rank) VALUES
(1, N'Иванов Алексей Петрович', 12500, N'Капитан'),
(2, N'Смирнов Дмитрий Игоревич', 9800, N'Старший пилот'),
(3, N'Kurtis Mitchell', 15400, N'Инструктор'),
(4, N'Петрова Анна Сергеевна', 6700, N'Второй пилот'),
(5, N'Jean-Luc Dubois', 13200, N'Капитан'),
(6, N'Zhang Wei', 8900, N'Первый офицер'),
(7, N'John O`Connor', 14300, N'Штурман'),
(8, N'Абрамов Максим Викторович', 10500, N'Командир ВС'),
(9, N'Kim Yoo-jin', 7600, N'Второй пилот'),
(10, N'Соколов Артём Николаевич', 11200, N'Капитан');


INSERT INTO FliesFor ($from_id, $to_id) VALUES
((SELECT $node_id FROM Planes WHERE id=1), (SELECT $node_id FROM Airlines WHERE id=1)), -- Boeing 737-800 принадлежит компании Aeroflot
((SELECT $node_id FROM Planes WHERE id=2), (SELECT $node_id FROM Airlines WHERE id=4)), -- Airbus A320neo принадлежит компании Air France
((SELECT $node_id FROM Planes WHERE id=3), (SELECT $node_id FROM Airlines WHERE id=1)), -- Sukhoi Superjet 100 принадлежит компании Aeroflot
((SELECT $node_id FROM Planes WHERE id=4), (SELECT $node_id FROM Airlines WHERE id=2)), -- Boeing 777-300ER принадлежит компании Delta Air Lines
((SELECT $node_id FROM Planes WHERE id=5), (SELECT $node_id FROM Airlines WHERE id=7)), -- Airbus A350-900 принадлежит компании Qatar Airways
((SELECT $node_id FROM Planes WHERE id=6), (SELECT $node_id FROM Airlines WHERE id=5)), -- Embraer E195-E2 принадлежит компании Ryanair
((SELECT $node_id FROM Planes WHERE id=7), (SELECT $node_id FROM Airlines WHERE id=8)), -- Bombardier CRJ900 принадлежит компании Lufthansa
((SELECT $node_id FROM Planes WHERE id=8), (SELECT $node_id FROM Airlines WHERE id=10)), -- COMAC C919 принадлежит компании British Airways
((SELECT $node_id FROM Planes WHERE id=9), (SELECT $node_id FROM Airlines WHERE id=9)), -- Ан-148 принадлежит компании Ural Airlines
((SELECT $node_id FROM Planes WHERE id=10), (SELECT $node_id FROM Airlines WHERE id=6)), -- Ил-96-400М принадлежит компании S7 Airlines
((SELECT $node_id FROM Planes WHERE id=1), (SELECT $node_id FROM Airlines WHERE id=10)), -- Boeing 737-800 принадлежит компании British Airways 
((SELECT $node_id FROM Planes WHERE id=4), (SELECT $node_id FROM Airlines WHERE id=1)), -- Boeing 777-300ER принадлежит компании Aeroflot
((SELECT $node_id FROM Planes WHERE id=10), (SELECT $node_id FROM Airlines WHERE id=2)), -- Ил-96-400М принадлежит компании Delta Air Lines
((SELECT $node_id FROM Planes WHERE id=5), (SELECT $node_id FROM Airlines WHERE id=3)), -- Airbus A350-900 принадлежит компании Emirates
((SELECT $node_id FROM Planes WHERE id=8), (SELECT $node_id FROM Airlines WHERE id=6)); -- COMAC C919 принадлежит компании S7 Airlines



INSERT INTO Employs ($from_id, $to_id) VALUES
((SELECT $node_id FROM Airlines WHERE id=1), (SELECT $node_id FROM Pilots WHERE id=1)), -- Aeroflot наняла пилота Иванов Алексей Петрович
((SELECT $node_id FROM Airlines WHERE id=1), (SELECT $node_id FROM Pilots WHERE id=8)), -- Aeroflot наняла пилота Абрамов Максим Викторович
((SELECT $node_id FROM Airlines WHERE id=2), (SELECT $node_id FROM Pilots WHERE id=2)), -- Delta Air Lines наняла пилота Смирнов Дмитрий Игоревич
((SELECT $node_id FROM Airlines WHERE id=4), (SELECT $node_id FROM Pilots WHERE id=5)), -- Air France наняла пилота Jean-Luc Dubois
((SELECT $node_id FROM Airlines WHERE id=5), (SELECT $node_id FROM Pilots WHERE id=9)), -- Ryanair наняла пилота Kim Yoo-jin
((SELECT $node_id FROM Airlines WHERE id=6), (SELECT $node_id FROM Pilots WHERE id=10)), -- S7 Airlines наняла пилота Соколов Артём Николаевич
((SELECT $node_id FROM Airlines WHERE id=7), (SELECT $node_id FROM Pilots WHERE id=3)), -- Qatar Airways наняла пилота Kurtis Mitchell
((SELECT $node_id FROM Airlines WHERE id=8), (SELECT $node_id FROM Pilots WHERE id=7)), -- Lufthansa наняла пилота John O`Connor
((SELECT $node_id FROM Airlines WHERE id=9), (SELECT $node_id FROM Pilots WHERE id=4)), -- Ural Airlines наняла пилота Петрова Анна Сергеевна
((SELECT $node_id FROM Airlines WHERE id=10), (SELECT $node_id FROM Pilots WHERE id=6)), -- British Airways наняла пилота Zhang Wei
((SELECT $node_id FROM Airlines WHERE id=2), (SELECT $node_id FROM Pilots WHERE id=1)), -- Delta Air Lines наняла пилота Иванов Алексей Петрович
((SELECT $node_id FROM Airlines WHERE id=3), (SELECT $node_id FROM Pilots WHERE id=10)), -- Emirates наняла пилота Соколов Артём Николаевич
((SELECT $node_id FROM Airlines WHERE id=7), (SELECT $node_id FROM Pilots WHERE id=8)), -- Qatar Airways наняла пилота Абрамов Максим Викторович
((SELECT $node_id FROM Airlines WHERE id=6), (SELECT $node_id FROM Pilots WHERE id=4)), -- S7 Airlines наняла пилота Петрова Анна Сергеевна
((SELECT $node_id FROM Airlines WHERE id=10), (SELECT $node_id FROM Pilots WHERE id=5)); -- British Airways наняла пилота Jean-Luc Dubois


INSERT INTO Operates ($from_id, $to_id) VALUES
((SELECT $node_id FROM Pilots WHERE id=1), (SELECT $node_id FROM Planes WHERE id=3)), -- Пилот Иванов Алексей Петрович пилотирует Such Superjet 100
((SELECT $node_id FROM Pilots WHERE id=1), (SELECT $node_id FROM Planes WHERE id=10)), -- Пилот Иванов Алексей Петрович пилотирует Ил-96-400М
((SELECT $node_id FROM Pilots WHERE id=2), (SELECT $node_id FROM Planes WHERE id=4)), -- Пилот Смирнов Дмитрий Игоревич пилотирует Boeing 777-300ER
((SELECT $node_id FROM Pilots WHERE id=3), (SELECT $node_id FROM Planes WHERE id=5)), -- Пилот Kurtis Mitchell пилотирует Airbus A350-900
((SELECT $node_id FROM Pilots WHERE id=4), (SELECT $node_id FROM Planes WHERE id=9)), -- Пилот Петрова Анна Сергеевна пилотирует Ан-148
((SELECT $node_id FROM Pilots WHERE id=5), (SELECT $node_id FROM Planes WHERE id=2)), -- Пилот Jean-Luc Dubois пилотирует Airbus A320neo
((SELECT $node_id FROM Pilots WHERE id=6), (SELECT $node_id FROM Planes WHERE id=6)), -- Пилот Zhang Wei пилотирует Embraer E195-E2
((SELECT $node_id FROM Pilots WHERE id=7), (SELECT $node_id FROM Planes WHERE id=7)), -- Пилот John O`Connor пилотирует Bombardier CRJ900
((SELECT $node_id FROM Pilots WHERE id=8), (SELECT $node_id FROM Planes WHERE id=1)), -- Пилот Абрамов Максим Викторович пилотирует Boeing 737-800
((SELECT $node_id FROM Pilots WHERE id=9), (SELECT $node_id FROM Planes WHERE id=8)), -- Пилот Kim Yoo-jin пилотирует COMAC C919
((SELECT $node_id FROM Pilots WHERE id=10), (SELECT $node_id FROM Planes WHERE id=10)), -- Пилот Соколов Артём Николаевич пилотирует Ил-96-400М
((SELECT $node_id FROM Pilots WHERE id=10), (SELECT $node_id FROM Planes WHERE id=4)), -- Пилот Соколов Артём Николаевич пилотирует Boeing 777-300ER
((SELECT $node_id FROM Pilots WHERE id=1), (SELECT $node_id FROM Planes WHERE id=4)), -- Пилот Иванов Алексей Петрович пилотирует Boeing 777-300ER
((SELECT $node_id FROM Pilots WHERE id=5), (SELECT $node_id FROM Planes WHERE id=7)), -- Пилот Jean-Luc Dubois пилотирует Bombardier CRJ900
((SELECT $node_id FROM Pilots WHERE id=3), (SELECT $node_id FROM Planes WHERE id=1)); -- Пилот Kurtis Mitchell пилотирует Boeing 737-800

-- 1. Найти всех пилотов, работающих в авиакомпаниях России
SELECT pil.name AS [Пилот], a.name AS [Авиакомпания]
FROM Pilots pil, Airlines a, Employs e
WHERE MATCH(a-(e)->pil)
AND a.country = N'Россия';

-- 2. Найти пилотов, управляющих самолётами Boeing
SELECT pil.name AS [Пилот], p.model AS [Модель], p.manufacturer AS [Производитель]
FROM Pilots pil, Planes p, Operates o
WHERE MATCH(pil-(o)->p)
AND p.manufacturer = N'Boeing';

-- 3. Найти капитанов с налётом более 10000 часов и их самолёты
SELECT pil.name AS [Капитан], 
       pil.total_flight_hours AS [Налёт часов],
       p.model AS [Модель самолета]
FROM Pilots pil, Planes p, Operates o
WHERE MATCH(pil-(o)->p)
AND pil.rank = N'Капитан'
AND pil.total_flight_hours > 10000;

-- 4. Все капитаны авиакомпаний 
SELECT p.name AS Капитан, a.name AS Авиакомпания
FROM Pilots p, Airlines a, Employs e
WHERE MATCH(a-(e)->p)
AND p.rank = 'Капитан';

-- 5. Самолёты 2020 года выпуска и их пилоты
SELECT pl.model AS [Самолёт], pi.name AS [Пилот]
FROM Planes pl, Pilots pi, Operates o
WHERE MATCH(pi-(o)->pl)
AND pl.year = 2020;



---Поиск всех самолетов, которые могут быть доступны пилоту Иванов Алексей Петрович и Смирнов Дмитрий Игоревич через его связи с авиакомпаниями
SELECT
    Pilot.name AS [Пилот],
    STRING_AGG(Plane.model, ' -> ') WITHIN GROUP (GRAPH PATH) AS [Доступные самолеты],
    COUNT(Plane.model) WITHIN GROUP (GRAPH PATH) AS [Количество]
FROM
    Pilots AS Pilot,
    Operates FOR PATH AS o,
    Planes FOR PATH AS Plane,
    FliesFor FOR PATH AS ff,
    Airlines FOR PATH AS a
WHERE MATCH(SHORTEST_PATH(
    Pilot(-(o)->Plane-(ff)->a)+
))
    AND Pilot.name = N'Иванов Алексей Петрович'


    SELECT
    Pilot.name AS [Пилот],
    STRING_AGG(Plane.model, ' -> ') WITHIN GROUP (GRAPH PATH) AS [Доступные самолеты],
    COUNT(Plane.model) WITHIN GROUP (GRAPH PATH) AS [Количество]
FROM
    Pilots AS Pilot,
    Operates FOR PATH AS o,
    Planes FOR PATH AS Plane,
    FliesFor FOR PATH AS ff,
    Airlines FOR PATH AS a
WHERE MATCH(SHORTEST_PATH(
    Pilot(-(o)->Plane-(ff)->a)+
))
    AND Pilot.name = N'Смирнов Дмитрий Игоревич'