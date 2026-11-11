-- Tennis Tournament Database - schema and sample data
-- Ernesto Pico

DROP DATABASE IF EXISTS TennisDB;
CREATE DATABASE TennisDB;
USE TennisDB;

CREATE TABLE Coaches (
    coachID         INT PRIMARY KEY,
    firstName       VARCHAR(30) NOT NULL,
    lastName        VARCHAR(30) NOT NULL,
    country         CHAR(3)     NOT NULL,
    yearsExperience INT
);

CREATE TABLE Players (
    playerID   INT PRIMARY KEY,
    firstName  VARCHAR(30) NOT NULL,
    lastName   VARCHAR(30) NOT NULL,
    country    CHAR(3)     NOT NULL,
    ranking    INT,
    coachID    INT,
    FOREIGN KEY (coachID) REFERENCES Coaches(coachID)
);

CREATE TABLE Tournaments (
    tournamentID INT PRIMARY KEY,
    name         VARCHAR(50) NOT NULL,
    city         VARCHAR(30),
    surface      VARCHAR(10),
    startDate    DATE
);

CREATE TABLE Matches (
    matchID      INT PRIMARY KEY,
    tournamentID INT NOT NULL,
    winnerID     INT NOT NULL,
    loserID      INT NOT NULL,
    round        VARCHAR(10),
    score        VARCHAR(20),
    FOREIGN KEY (tournamentID) REFERENCES Tournaments(tournamentID),
    FOREIGN KEY (winnerID)     REFERENCES Players(playerID),
    FOREIGN KEY (loserID)      REFERENCES Players(playerID)
);

INSERT INTO Coaches VALUES
(1, 'Raul',   'Mendoza', 'ECU', 15),
(2, 'Sofia',  'Andrade', 'ECU',  8),
(3, 'Mark',   'Davis',   'USA', 20),
(4, 'Carlos', 'Navarro', 'ESP', 12),
(5, 'Martin', 'Ibarra',  'ARG', 10);

INSERT INTO Players VALUES
(1, 'Mateo',  'Vera',     'ECU',  45, 1),
(2, 'Diego',  'Zambrano', 'ECU',  88, 1),
(3, 'Andres', 'Cedeno',   'ECU', 130, 2),
(4, 'Lucas',  'Bennett',  'USA',  22, 3),
(5, 'Ryan',   'Cole',     'USA',  67, 3),
(6, 'Pablo',  'Ruiz',     'ESP',  15, 4),
(7, 'Javier', 'Molina',   'ESP',  52, 4),
(8, 'Tomas',  'Ferreyra', 'ARG',  34, 5);

INSERT INTO Tournaments VALUES
(1, 'Manta Open',           'Manta',     'Clay', '2026-02-09'),
(2, 'Guayaquil Challenger', 'Guayaquil', 'Clay', '2026-03-02'),
(3, 'Memphis Indoor',       'Memphis',   'Hard', '2026-02-16'),
(4, 'Miami Classic',        'Miami',     'Hard', '2026-03-23'),
(5, 'Madrid Cup',           'Madrid',    'Clay', '2026-04-27');

INSERT INTO Matches VALUES
(1,  1, 1, 2, 'SF', '6-4 6-3'),
(2,  1, 8, 3, 'SF', '7-5 6-2'),
(3,  1, 1, 8, 'F',  '6-3 4-6 6-4'),
(4,  2, 6, 2, 'SF', '6-2 6-1'),
(5,  2, 7, 1, 'SF', '6-4 7-6'),
(6,  2, 6, 7, 'F',  '6-3 6-4'),
(7,  3, 4, 5, 'SF', '7-6 6-4'),
(8,  3, 4, 8, 'F',  '6-4 6-4'),
(9,  4, 5, 4, 'F',  '6-7 6-3 6-4'),
(10, 5, 6, 8, 'F',  '6-1 6-4');
