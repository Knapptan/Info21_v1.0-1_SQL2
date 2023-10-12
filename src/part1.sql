DROP TABLE IF EXISTS Peers CASCADE;
DROP TABLE IF EXISTS Tasks CASCADE;
DROP TABLE IF EXISTS Checks CASCADE;
DROP TABLE IF EXISTS P2P CASCADE;
DROP TABLE IF EXISTS Verter CASCADE;
DROP TABLE IF EXISTS Transferredpoints CASCADE;
DROP TABLE IF EXISTS Friends CASCADE;
DROP TABLE IF EXISTS Recommendations CASCADE;
DROP TABLE IF EXISTS XP CASCADE;
DROP TABLE IF EXISTS TimeTracking CASCADE;
DROP TYPE IF EXISTS check_status;


CREATE TABLE IF NOT EXISTS Peers
(
	Nickname VARCHAR PRIMARY KEY NOT NULL,
	Birthday DATE NOT NULL
);

INSERT INTO Peers (Nickname, Birthday)

VALUES ('maganand', '1975-10-31'),
       ('fideliai', '1991-12-30'),
       ('denyoror', '1987-09-01'),
       ('merkerta', '1987-01-11'),
       ('ccartman', '1985-09-30'),
       ('christim', '2001-11-03'),
       ('valeryje', '1995-02-16'),
       ('knapptan', '1998-07-20'),
       ('arianepo', '1991-10-22'),
       ('sippydon', '1993-12-24'),
       ('irishamy', '2000-05-24'),
       ('gilderoa', '1993-11-28'),
       ('manhuntc', '1993-11-06'),
       ('frenyaha', '1992-09-23'),
       ('tarthnay', '2002-09-29'),
       ('gummypol', '1985-01-23'),
       ('colemanm', '1999-10-05'),
       ('voorjane', '2001-03-17'),
       ('bretgabr', '1999-03-18'),
       ('ardellen', '1990-06-19'),
       ('elviaatt', '1999-04-22'),
       ('artisank', '1987-01-22'),
       ('sharnasv', '1992-02-07'),
       ('madeline', '2002-11-10'),
       ('joshuaco', '1993-07-02'),
       ('eboniest', '1989-04-16'),
       ('brandado', '2001-08-13'),
       ('gayespell', '1995-12-11'),
       ('arnellma', '1995-10-18'),
       ('heidedra', '1991-07-28'),
       ('effrafax', '2001-05-07'),
       ('mapescas', '1988-04-19'),
       ('willardc', '1986-07-22'),
       ('shantaeb', '1997-05-27'),
       ('staceymo', '1994-04-30'),
       ('jacquelc', '1991-02-27'),
       ('kossmali', '1987-03-09'),
       ('bmaegan', '2001-11-02'),
       ('leandroi', '1993-10-10'),
       ('pucklant', '1988-04-09'),
       ('steffani', '1999-06-01'),
       ('ocapers', '1989-02-26'),
       ('rhonakia', '1997-02-04'),
       ('eroehocl', '1997-09-23'),
       ('carsonza', '1999-08-22'),
       ('workerwa', '1999-03-08'),
       ('maryamgr', '1991-02-10'),
       ('oceanusp', '1993-08-07'),
       ('emerosro', '1998-05-24'),
       ('lalex', '1992-05-24');
       


CREATE TABLE IF NOT EXISTS Tasks
(
    Title VARCHAR PRIMARY KEY NOT NULL,
    ParentTask VARCHAR,
    MaxXP INTEGER NOT NULL,
    FOREIGN KEY (ParentTask) REFERENCES Tasks (Title)
);

INSERT INTO Tasks
VALUES ('C2_SimpleBashUtils', NULL, 250),
       ('C3_s21_string+', 'C2_SimpleBashUtils', 500),
       ('C4_s21_math', 'C2_SimpleBashUtils', 300),
       ('C5_s21_decimal', 'C4_s21_math', 350),
       ('C6_s21_matrix', 'C5_s21_decimal', 200),
       ('C7_SmartCalc_v1.0', 'C6_s21_matrix', 500),
       ('C8_3DViewer_v1.0', 'C7_SmartCalc_v1.0', 750),
       ('DO1_Linux', 'C3_s21_string+', 300),
       ('DO2_Linux Network', 'DO1_Linux', 250),
       ('DO3_LinuxMonitoring v1.0', 'DO2_Linux Network', 350),
       ('DO4_LinuxMonitoring v2.0', 'DO3_LinuxMonitoring v1.0', 350),
       ('DO5_SimpleDocker', 'DO3_LinuxMonitoring v1.0', 300),
       ('DO6_CICD', 'DO5_SimpleDocker', 300),
       ('CPP1_s21_matrix+', 'C8_3DViewer_v1.0', 300),
       ('CPP2_s21_containers', 'CPP1_s21_matrix+', 350),
       ('CPP3_SmartCalc_v2.0', 'CPP2_s21_containers', 600),
       ('CPP4_3DViewer_v2.0', 'CPP3_SmartCalc_v2.0', 750),
       ('CPP5_3DViewer_v2.1', 'CPP4_3DViewer_v2.0', 600),
       ('CPP6_3DViewer_v2.2', 'CPP4_3DViewer_v2.0', 800),
       ('CPP7_MLP', 'CPP4_3DViewer_v2.0', 700),
       ('CPP8_PhotoLab_v1.0', 'CPP4_3DViewer_v2.0', 450),
       ('CPP9_MonitoringSystem', 'CPP4_3DViewer_v2.0', 1000),
       ('A1_Maze', 'CPP4_3DViewer_v2.0', 300),
       ('A2_SimpleNavigator v1.0', 'A1_Maze', 400),
       ('A3_Parallels', 'A2_SimpleNavigator v1.0', 300),
       ('A4_Crypto', 'A2_SimpleNavigator v1.0', 350),
       ('A5_s21_memory', 'A2_SimpleNavigator v1.0', 400),
       ('A6_Transactions', 'A2_SimpleNavigator v1.0', 700),
       ('A7_DNA Analyzer', 'A2_SimpleNavigator v1.0', 800),
       ('A8_Algorithmic trading', 'A2_SimpleNavigator v1.0', 800),
       ('SQL1_Bootcamp', 'C8_3DViewer_v1.0', 1500),
       ('SQL2_Info21 v1.0', 'SQL1_Bootcamp', 500),
       ('SQL3_RetailAnalitycs v1.0', 'SQL2_Info21 v1.0', 600);

CREATE TYPE check_status AS ENUM ('Start', 'Success', 'Failure');

CREATE TABLE IF NOT EXISTS Checks
(
    ID   BIGINT PRIMARY KEY NOT NULL,
    Peer VARCHAR NOT NULL,
    Task VARCHAR NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (Peer) REFERENCES Peers (Nickname),
    FOREIGN KEY (Task) REFERENCES Tasks (Title)
);

INSERT INTO Checks
VALUES (1, 'maganand', 'C2_SimpleBashUtils', '2023-03-01'),
       (2, 'maganand', 'C2_SimpleBashUtils', '2023-03-02'),
       (3, 'fideliai', 'C4_s21_math', '2023-03-02'),
       (4, 'denyoror', 'C2_SimpleBashUtils', '2023-03-03'),
       (5, 'denyoror', 'C3_s21_string+', '2023-03-04'),
       (6, 'merkerta', 'DO1_Linux', '2023-03-05'),
       (7, 'ccartman', 'DO2_Linux Network', '2023-03-05'),
       (8, 'christim', 'DO2_Linux Network', '2023-03-05'),
       (9, 'valeryje', 'DO3_LinuxMonitoring v1.0', '2023-03-07'),
       (10, 'knapptan', 'C5_s21_decimal', '2023-03-08'),
       (11, 'arianepo', 'C3_s21_string+', '2023-03-08'),
       (12, 'sippydon', 'C4_s21_math', '2023-03-08'),
       (13, 'fideliai', 'C3_s21_string+', '2023-03-08'),
       (14, 'denyoror', 'DO1_Linux', '2023-03-09'),
       (15, 'maganand', 'C6_s21_matrix', '2023-03-10'),
       (16, 'knapptan', 'DO1_Linux', '2023-03-10'),
       (17, 'ccartman', 'C2_SimpleBashUtils', '2023-03-12'),
       (18, 'merkerta', 'C6_s21_matrix', '2023-04-01'),
       (19, 'valeryje', 'DO1_Linux', '2023-04-05'),
       (20, 'sippydon', 'C3_s21_string+', '2023-04-06'),
       (21, 'valeryje', 'DO2_Linux Network', '2023-04-06'),
       (22, 'valeryje', 'DO3_LinuxMonitoring v1.0', '2023-04-07'),
       (23, 'valeryje', 'DO4_LinuxMonitoring v2.0', '2023-04-08'),
       (24, 'valeryje', 'DO5_SimpleDocker', '2023-04-09'),
       (25, 'valeryje', 'DO6_CICD', '2023-04-10'),
       (26, 'denyoror', 'C4_s21_math', '2023-04-06'),
       (27, 'denyoror', 'C5_s21_decimal', '2023-03-07'),
       (28, 'denyoror', 'C6_s21_matrix', '2023-03-08'),
       (29, 'denyoror', 'C7_SmartCalc_v1.0', '2023-03-09'),
       (30, 'denyoror', 'C8_3DViewer_v1.0', '2023-03-10');
       --(31, 'denyoror', 'C3_s21_string+', '2023-04-03'),

CREATE TABLE IF NOT EXISTS P2P
(
    ID           BIGINT PRIMARY KEY NOT NULL,
    "Check"      BIGINT NOT NULL,
    CheckingPeer varchar NOT NULL,
    State        check_status NOT NULL,
    Time         time NOT NULL,
    FOREIGN KEY ("Check") REFERENCES Checks (ID),
    FOREIGN KEY (CheckingPeer) REFERENCES Peers (Nickname)
);

INSERT INTO P2P (id, "Check", CheckingPeer, State, Time)
VALUES (1, 1, 'fideliai', 'Start', '09:00:00'),
       (2, 1, 'fideliai', 'Failure', '10:00:00'),
       (3, 2, 'denyoror', 'Start', '13:00:00'),
       (4, 2, 'denyoror', 'Success', '14:00:00'),
       (5, 3, 'maganand', 'Start', '22:00:00'),
       (6, 3, 'maganand', 'Success', '23:00:00'),
       (7, 4, 'merkerta', 'Start', '15:00:00'),
       (8, 4, 'merkerta', 'Success', '16:00:00'),
       (9, 5, 'ccartman', 'Start', '14:00:00'),
       (10, 5, 'ccartman', 'Success', '15:00:00'),
       (11, 6, 'christim', 'Start', '01:00:00'),
       (12, 6, 'christim', 'Success', '02:00:00'),
       (13, 7, 'valeryje', 'Start', '10:00:00'),
       (14, 7, 'valeryje', 'Success', '12:00:00'),
       (15, 8, 'knapptan', 'Start', '12:00:00'),
       (16, 8, 'knapptan', 'Success', '13:00:00'),
       (17, 9, 'arianepo', 'Start', '12:00:00'),
       (18, 9, 'arianepo', 'Success', '13:00:00'),
       (19, 10, 'sippydon', 'Start', '19:00:00'),
       (20, 11, 'ccartman', 'Start', '15:00:00'),
       (21, 11, 'ccartman', 'Success', '15:01:00'),
       (22, 12, 'valeryje', 'Start', '22:00:00'),
       (23, 12, 'valeryje', 'Failure', '23:00:00'),
       (24, 13, 'merkerta', 'Start', '22:00:00'),
       (25, 13, 'merkerta', 'Success', '23:00:00'),
       (26, 14, 'maganand', 'Start', '22:00:00'),
       (27, 14, 'maganand', 'Success', '23:00:00'),
       (28, 15, 'arianepo', 'Start', '04:00:00'),
       (29, 15, 'arianepo', 'Success', '05:00:00'),
       (30, 16, 'maganand', 'Start', '05:00:00'),
       (31, 16, 'maganand', 'Failure', '06:00:00'),
       (32, 17, 'valeryje', 'Start', '07:00:00'),
       (33, 17, 'valeryje', 'Success', '08:00:00'),
       (34, 18, 'sippydon', 'Start', '08:00:00'),
       (35, 18, 'sippydon', 'Success', '09:00:00'),
       (36, 19, 'fideliai', 'Start', '09:00:00'),
       (37, 19, 'fideliai', 'Success', '10:00:00'),
       (38, 20, 'christim', 'Start', '11:00:00'),
       (39, 21, 'maganand', 'Start', '11:00:00'),
       (40, 21, 'maganand', 'Success', '12:00:00'),
       (41, 22, 'fideliai', 'Start', '05:00:00'),
       (42, 22, 'fideliai', 'Success', '06:00:00'),
       (43, 23, 'denyoror', 'Start', '10:00:00'),
       (44, 23, 'denyoror', 'Success', '11:00:00'),
       (45, 24, 'merkerta', 'Start', '11:00:00'),
       (46, 24, 'merkerta', 'Success', '12:00:00'),
       (47, 25, 'ccartman', 'Start', '18:00:00'),
       (48, 25, 'ccartman', 'Success', '19:00:00'),
       (49, 26, 'christim', 'Start', '15:00:00'),
       (50, 26, 'christim', 'Success', '16:00:00'),
       (51, 27, 'valeryje', 'Start', '13:00:00'),
       (52, 27, 'valeryje', 'Success', '14:00:00'),
       (53, 28, 'knapptan', 'Start', '13:00:00'),
       (54, 28, 'knapptan', 'Success', '14:00:00'),
       (55, 29, 'arianepo', 'Start', '16:00:00'),
       (56, 29, 'arianepo', 'Success', '17:00:00'),
       (57, 30, 'sippydon', 'Start', '22:00:00'),
       (58, 30, 'sippydon', 'Success', '23:00:00');
       --(59, 31, 'gilderoa', 'Success', 12:00:00),

CREATE TABLE Verter
(
    ID      bigint PRIMARY KEY NOT NULL,
    "Check" bigint  NOT NULL,
    State   check_status NOT NULL,
    Time    time    NOT NULL,
    FOREIGN KEY ("Check") REFERENCES Checks (ID)
);


INSERT INTO Verter
VALUES (1, 2, 'Start', '13:01:00'),
       (2, 2, 'Success', '13:02:00'),
       (3, 3, 'Start', '23:01:00'),
       (4, 3, 'Success', '23:02:00'),
       (5, 4, 'Start', '16:01:00'),
       (6, 4, 'Failure', '16:02:00'),
       (7, 5, 'Start', '15:01:00'),
       (8, 5, 'Success', '15:02:00'),
       (9, 13, 'Start', '23:01:00'),
       (10, 13, 'Success', '23:02:00'),
       (11, 15, 'Start', '05:01:00'),
       (12, 15, 'Failure', '05:02:00'),
       (13, 17, 'Start', '06:01:00'),
       (14, 17, 'Success', '06:02:00'),
       (15, 18, 'Start', '06:01:00'),
       (16, 18, 'Success', '06:02:00'),
       (17, 19, 'Start', '06:01:00'),
       (18, 19, 'Failure', '06:02:00'),
       (19, 21, 'Start', '12:01:00'),
       (20, 21, 'Success', '12:02:00'),
       (21, 22, 'Start', '06:01:00'),
       (22, 22, 'Success', '06:02:00'),
       (23, 23, 'Start', '11:01:00'),
       (24, 23, 'Success', '11:02:00'),
       (25, 24, 'Start', '12:01:00'),
       (26, 24, 'Success', '12:02:00'),
       (27, 25, 'Start', '19:01:00'),
       (28, 25, 'Success', '19:02:00'),
       (29, 26, 'Start', '16:01:00'),
       (30, 26, 'Success', '16:02:00'),
       (31, 27, 'Start', '14:01:00'),
       (32, 27, 'Success', '14:02:00'),
       (33, 28, 'Start', '14:01:00'),
       (34, 28, 'Success', '14:02:00'),
       (35, 29, 'Start', '17:01:00'),
       (36, 29, 'Success', '17:02:00'),
       (37, 30, 'Start', '23:01:00'),
       (38, 30, 'Success', '23:02:00');

CREATE TABLE IF NOT EXISTS TransferredPoints
(
    ID           bigint NOT NULL GENERATED ALWAYS AS IDENTITY
        (INCREMENT 1 START 1) PRIMARY KEY,
    CheckingPeer varchar NOT NULL,
    CheckedPeer  varchar NOT NULL,
    PointsAmount integer NOT NULL,
    FOREIGN KEY (CheckingPeer) REFERENCES Peers (Nickname),
    FOREIGN KEY (CheckedPeer) REFERENCES Peers (Nickname)
);

INSERT INTO TransferredPoints (CheckingPeer, CheckedPeer, PointsAmount)
SELECT checkingpeer, Peer, count(*) FROM P2P
JOIN Checks C ON C.ID = P2P."Check"
WHERE State != 'Start'
GROUP BY 1,2;

CREATE TABLE Friends (
    ID bigint PRIMARY KEY NOT NULL,
    Peer1 varchar NOT NULL,
    Peer2 varchar NOT NULL,
    FOREIGN KEY (Peer1) REFERENCES Peers(Nickname),
    FOREIGN KEY (Peer2) REFERENCES Peers(Nickname)
);

INSERT INTO Friends (id, Peer1, Peer2)
VALUES (1, 'maganand', 'fideliai'),
       (2, 'maganand', 'denyoror'),
       (3, 'fideliai', 'ccartman'),
       (4, 'denyoror', 'ccartman'),
       (5, 'merkerta', 'maganand'),
       (6, 'ccartman', 'sippydon'),
       (7, 'christim', 'merkerta'),
       (8, 'valeryje', 'ccartman'),
       (9, 'knapptan', 'maganand'),
       (10, 'irishamy', 'elviaatt'),
       (11, 'gilderoa', 'elviaatt'),
       (12, 'tarthnay', 'effrafax'),
       (13, 'tarthnay', 'mapescas'),
       (14, 'madeline', 'ccartman'),
       (15, 'voorjane', 'maganand'),
       (16, 'frenyaha', 'colemanm'),
       (17, 'mapescas', 'merkerta'),
       (18, 'willardc', 'ccartman'),
       (19, 'kossmali', 'maganand'),
       (20, 'bmaegan', 'fideliai'),
	   (21, 'oceanusp', 'knapptan'),
	   (22, 'oceanusp', 'emerosro');


CREATE TABLE IF NOT EXISTS Recommendations
(
    ID              bigint PRIMARY KEY NOT NULL,
    Peer            varchar NOT NULL,
    RecommendedPeer varchar NOT NULL,
    FOREIGN KEY (Peer) REFERENCES Peers (Nickname),
    FOREIGN KEY (RecommendedPeer) REFERENCES Peers (Nickname)
);

INSERT INTO Recommendations
VALUES (1, 'maganand', 'fideliai'),
       (2, 'maganand', 'denyoror'),
       (3, 'fideliai', 'ccartman'),
       (4, 'denyoror', 'ccartman'),
       (5, 'merkerta', 'maganand'),
       (6, 'ccartman', 'sippydon'),
       (7, 'christim', 'merkerta'),
       (8, 'valeryje', 'ccartman'),
       (9, 'knapptan', 'maganand'),
       (10, 'irishamy', 'elviaatt'),
       (11, 'gilderoa', 'elviaatt'),
       (12, 'tarthnay', 'effrafax'),
       (13, 'tarthnay', 'mapescas'),
       (14, 'madeline', 'ccartman'),
       (15, 'voorjane', 'maganand'),
       (16, 'frenyaha', 'colemanm'),
       (17, 'mapescas', 'merkerta'),
       (18, 'willardc', 'ccartman'),
       (19, 'kossmali', 'maganand'),
       (20, 'bmaegan', 'fideliai'),
       (21, 'steffani', 'denyoror'),
       (22, 'ocapers', 'ccartman'),
       (23, 'carsonza', 'ccartman'),
       (24, 'carsonza', 'maganand'),
       (25, 'leandroi', 'sippydon'),
       (26, 'eboniest', 'irishamy'),
       (27, 'brandado', 'gilderoa'),
       (28, 'gayespell', 'frenyaha'),
       (29, 'rhonakia', 'tarthnay'),
       (30, 'workerwa', 'gummypol');

CREATE TABLE IF NOT EXISTS XP
(
    ID       bigint PRIMARY KEY ,
    "Check"  bigint  NOT NULL ,
    XPAmount integer NOT NULL ,
    foreign key ("Check") references Checks (ID)
);

INSERT INTO XP
VALUES (1, 2, 240),
       (2, 3, 300),
       (3, 5, 200),
       (4, 6, 250),
       (5, 7, 250),
       (6, 8, 250),
       (7, 9, 350),
       (8, 11, 450),
       (9, 13, 500),
       (10, 14, 300),
       (11, 17, 250),
       (12, 18, 150),
       (13, 21, 250),
       (14, 22, 350),
       (15, 23, 350),
       (16, 24, 300),
       (17, 25, 300),
       (18, 26, 300),
       (19, 27, 350),
       (20, 28, 200),
       (21, 29, 500),
       (22, 30, 750);


CREATE TABLE IF NOT EXISTS TimeTracking
(
    ID     bigint PRIMARY KEY NOT NULL,
    Peer   varchar NOT NULL,
    Date   date NOT NULL,
    Time   time NOT NULL,
    State  bigint NOT NULL CHECK ( State IN (1, 2)),
    FOREIGN KEY (Peer) REFERENCES Peers (Nickname)
);

INSERT INTO TimeTracking
VALUES (1, 'shantaeb', '2023-11-28', '14:00:00', 1),
(2, 'shantaeb', '2023-11-28', '14:30:00', 2),
(3, 'gummypol', '2023-06-26', '11:00:00', 1),
(4, 'gummypol', '2023-06-26', '12:00:00', 2),
(5, 'kossmali', '2023-01-10', '15:00:00', 1),
(6, 'kossmali', '2023-01-10', '16:00:00', 2),
(7, 'artisank', '2023-03-08', '07:00:00', 1),
(8, 'artisank', '2023-03-08', '08:30:00', 2),
(9, 'steffani', '2023-08-24', '12:30:00', 1),
(10, 'steffani', '2023-08-24', '13:00:00', 2),
(11, 'brandado', '2023-01-07', '16:00:00', 1),
(12, 'brandado', '2023-01-07', '17:00:00', 2),
(13, 'sharnasv', '2023-05-12', '10:30:00', 1),
(14, 'sharnasv', '2023-05-12', '11:00:00', 2),
(15, 'bretgabr', '2023-04-10', '10:41:10', 1),
(16, 'bretgabr', '2023-04-10', '13:00:00', 2),
(17, 'willardc', '2023-03-03', '15:00:00', 1),
(18, 'willardc', '2023-03-03', '17:00:00', 2),
(19, 'madeline', '2023-08-26', '08:00:00', 1),
(20, 'madeline', '2023-08-26', '08:45:00', 2),
(21, 'heidedra', '2023-07-13', '12:30:00', 1),
(22, 'heidedra', '2023-07-13', '13:50:00', 2),
(23, 'arianepo', '2023-06-28', '18:00:00', 1),
(24, 'arianepo', '2023-06-28', '23:30:00', 2),
(25, 'eroehocl', '2023-05-02', '17:20:00', 1),
(26, 'eroehocl', '2023-05-02', '19:30:00', 2),
(27, 'rhonakia', '2023-10-04', '11:00:00', 1),
(28, 'rhonakia', '2023-10-04', '17:00:00', 2),
(29, 'artisank', '2023-12-15', '12:00:00', 1),
(30, 'artisank', '2023-12-15', '14:30:00', 2),
(31, 'bmaegan', '2023-03-15', '14:10:00', 1),
(32, 'bmaegan', '2023-03-15', '17:00:00', 2),
(33, 'gummypol', '2023-07-24', '14:30:00', 1),
(34, 'gummypol', '2023-07-24', '18:00:00', 2),
(35, 'brandado', '2023-08-21', '12:50:00', 1),
(36, 'brandado', '2023-08-21', '17:00:00', 2),
(37, 'valeryje', '2023-10-03', '08:20:00', 1),
(38, 'valeryje', '2023-10-03', '12:00:00', 2),
(39, 'elviaatt', '2023-05-02', '17:20:00', 1),
(40, 'elviaatt', '2023-05-02', '19:00:00', 2),
(41, 'christim', '2023-10-15', '10:20:00', 1),
(42, 'christim', '2023-10-15', '14:00:00', 2),
(43, 'gayespell', '2023-09-06', '11:20:00', 1),
(44, 'gayespell', '2023-09-06', '18:30:00', 2),
(45, 'maryamgr', '2023-10-14', '09:00:00', 1),
(46, 'maryamgr', '2023-10-14', '11:20:00', 2),
(47, 'knapptan', '2023-01-16', '07:00:00', 1),
(48, 'knapptan', '2023-01-16', '15:00:00', 2),
(49, 'willardc', '2023-10-15', '08:00:00', 1),
(50, 'willardc', '2023-10-15', '16:00:00', 2),
(51, 'voorjane', '2023-03-15', '07:20:00', 1),
(52, 'voorjane', '2023-03-15', '16:00:00', 2),
(53, 'eroehocl', '2023-03-08', '09:00:00', 1),
(54, 'eroehocl', '2023-03-08', '14:20:00', 2),
(55, 'arianepo', '2023-01-09', '10:00:00', 1),
(56, 'arianepo', '2023-01-09', '18:00:00', 2),
(57, 'leandroi', '2023-01-04', '06:00:00', 1),
(58, 'leandroi', '2023-01-04', '08:00:00', 2),
(59, 'fideliai', '2023-03-20', '08:00:00', 1),
(60, 'fideliai', '2023-03-20', '11:00:00', 2),
(61, 'willardc', '2023-01-27', '09:00:00', 1),
(62, 'willardc', '2023-01-27', '16:00:00', 2),
(63, 'bretgabr', '2023-08-23', '11:00:00', 1),
(64, 'bretgabr', '2023-08-23', '14:00:00', 2),
(65, 'brandado', '2023-07-25', '09:20:00', 1),
(66, 'brandado', '2023-07-25', '15:00:00', 2),
(67, 'pucklant', '2023-04-11', '08:00:00', 1),
(68, 'pucklant', '2023-04-11', '12:00:00', 2),
(69, 'staceymo', '2023-11-18', '07:00:00', 1),
(70, 'staceymo', '2023-11-18', '19:00:00', 2),
(71, 'fideliai', '2023-06-03', '13:00:00', 1),
(72, 'fideliai', '2023-06-03', '19:00:00', 2),
(73, 'voorjane', '2023-01-23', '16:00:00', 1),
(74, 'voorjane', '2023-01-23', '19:00:00', 2),
(75, 'valeryje', '2023-02-21', '10:00:00', 1),
(76, 'valeryje', '2023-02-21', '19:00:00', 2),
(77, 'kossmali', '2023-02-16', '10:00:00', 1),
(78, 'kossmali', '2023-02-16', '19:20:00', 2),
(79, 'pucklant', '2023-05-30', '10:00:00', 1),
(80, 'pucklant', '2023-05-30', '19:00:00', 2),
(81, 'steffani', '2023-10-22', '17:20:00', 1),
(82, 'steffani', '2023-10-22', '19:00:00', 2),
(83, 'voorjane', '2023-10-12', '11:00:00', 1),
(84, 'voorjane', '2023-10-12', '17:20:00', 2),
(85, 'mapescas', '2023-12-10', '09:00:00', 1),
(86, 'mapescas', '2023-12-10', '15:00:00', 2),
(87, 'gayespell', '2023-04-17', '09:20:00', 1),
(88, 'gayespell', '2023-04-17', '16:00:00', 2),
(89, 'oceanusp', '2023-10-07', '09:00:00', 1),
(90, 'oceanusp', '2023-10-07', '14:00:00', 2),
(91, 'gummypol', '2023-11-24', '09:00:00', 1),
(92, 'gummypol', '2023-11-24', '14:00:00', 2),
(93, 'ardellen', '2023-09-29', '09:00:00', 1),
(94, 'ardellen', '2023-09-29', '11:00:00', 2),
(95, 'artisank', '2023-09-30', '06:00:00', 1),
(96, 'artisank', '2023-09-30', '11:00:00', 2),
(97, 'merkerta', '2023-12-01', '06:00:00', 1),
(98, 'merkerta', '2023-12-01', '17:00:00', 2),
(99, 'bretgabr', '2023-05-06', '11:00:00', 1),
(100, 'bretgabr', '2023-05-06', '17:00:00', 2),
(101, 'steffani', '2023-10-07', '11:00:00', 1),
(102, 'steffani', '2023-10-07', '17:00:00', 2),
(103, 'madeline', '2023-03-26', '11:00:00', 1),
(104, 'madeline', '2023-03-26', '18:30:00', 2),
(105, 'maryamgr', '2023-04-02', '11:00:00', 1),
(106, 'maryamgr', '2023-04-02', '16:00:00', 2),
(107, 'christim', '2023-12-29', '10:00:00', 1),
(108, 'christim', '2023-12-29', '19:00:00', 2),
(109, 'tarthnay', '2023-09-02', '10:00:00', 1),
(110, 'tarthnay', '2023-09-02', '19:00:00', 2),
(111, 'maganand', '2023-02-11', '10:00:00', 1),
(112, 'maganand', '2023-02-11', '19:00:00', 2),
(113, 'staceymo', '2023-05-25', '10:30:00', 1),
(114, 'staceymo', '2023-05-25', '19:00:00', 2),
(115, 'tarthnay', '2023-12-27', '12:00:00', 1),
(116, 'tarthnay', '2023-12-27', '16:00:00', 2),
(117, 'eroehocl', '2023-04-18', '11:00:00', 1),
(118, 'eroehocl', '2023-04-18', '18:00:00', 2),
(119, 'gummypol', '2023-04-17', '09:00:00', 1),
(120, 'gummypol', '2023-04-17', '17:00:00', 2),
(121, 'willardc', '2023-12-18', '10:00:00', 1),
(122, 'willardc', '2023-12-18', '18:00:00', 2),
(123, 'arnellma', '2023-12-18', '12:00:00', 1),
(124, 'arnellma', '2023-12-18', '19:30:00', 2),
(125, 'joshuaco', '2023-02-09', '10:00:00', 1),
(126, 'joshuaco', '2023-02-09', '16:20:00', 2),
(127, 'workerwa', '2023-06-08', '09:00:00', 1),
(128, 'workerwa', '2023-06-08', '15:00:00', 2),
(129, 'jacquelc', '2023-02-09', '08:00:00', 1),
(130, 'jacquelc', '2023-02-09', '11:30:00', 2),
(131, 'arnellma', '2023-04-22', '10:20:00', 1),
(132, 'arnellma', '2023-04-22', '12:00:00', 2),
(133, 'arnellma', '2023-10-27', '10:00:00', 1),
(134, 'arnellma', '2023-10-27', '12:00:00', 2),
(135, 'ccartman', '2023-08-14', '10:00:00', 1),
(136, 'ccartman', '2023-08-14', '16:00:00', 2),
(137, 'frenyaha', '2023-03-27', '17:00:00', 1),
(138, 'frenyaha', '2023-03-27', '19:00:00', 2),
(139, 'steffani', '2023-05-29', '14:00:00', 1),
(140, 'steffani', '2023-05-29', '19:00:00', 2),
(141, 'arnellma', '2023-01-10', '14:30:00', 1),
(142, 'arnellma', '2023-01-10', '19:00:00', 2),
(143, 'voorjane', '2023-06-07', '14:00:00', 1),
(144, 'voorjane', '2023-06-07', '19:20:00', 2),
(145, 'joshuaco', '2023-04-01', '12:00:00', 1),
(146, 'joshuaco', '2023-04-01', '16:30:00', 2),
(147, 'shantaeb', '2023-03-30', '13:20:00', 1),
(148, 'shantaeb', '2023-03-30', '19:00:00', 2),
(149, 'sharnasv', '2023-06-05', '11:00:00', 1),
(150, 'sharnasv', '2023-06-05', '19:00:00', 2),
(151, 'steffani', '2023-06-30', '12:00:00', 1),
(152, 'steffani', '2023-06-30', '18:00:00', 2),
(153, 'ccartman', '2023-11-10', '07:00:00', 1),
(154, 'ccartman', '2023-11-10', '15:00:00', 2),
(155, 'willardc', '2023-07-15', '09:00:00', 1),
(156, 'willardc', '2023-07-15', '16:00:00', 2),
(157, 'oceanusp', '2023-04-16', '08:20:00', 1),
(158, 'oceanusp', '2023-04-16', '14:00:00', 2),
(159, 'ccartman', '2023-09-12', '08:00:00', 1),
(160, 'ccartman', '2023-09-12', '14:00:00', 2),
(161, 'sharnasv', '2023-01-30', '10:00:00', 1),
(162, 'sharnasv', '2023-01-30', '19:20:00', 2),
(163, 'eroehocl', '2023-11-09', '10:00:00', 1),
(164, 'eroehocl', '2023-11-09', '18:00:00', 2),
(165, 'steffani', '2023-11-12', '08:30:00', 1),
(166, 'steffani', '2023-11-12', '19:00:00', 2),
(167, 'irishamy', '2023-10-02', '10:00:00', 1),
(168, 'irishamy', '2023-10-02', '19:00:00', 2),
(169, 'gilderoa', '2023-07-29', '11:00:00', 1),
(170, 'gilderoa', '2023-07-29', '15:00:00', 2),
(171, 'christim', '2023-01-27', '08:00:00', 1),
(172, 'christim', '2023-01-27', '16:00:00', 2),
(173, 'carsonza', '2023-07-13', '04:00:00', 1),
(174, 'carsonza', '2023-07-13', '10:00:00', 2),
(175, 'gummypol', '2023-09-17', '06:00:00', 1),
(176, 'gummypol', '2023-09-17', '11:00:00', 2),
(177, 'willardc', '2023-03-15', '10:00:00', 1),
(178, 'willardc', '2023-03-15', '19:00:00', 2),
(179, 'bmaegan', '2023-07-15', '11:30:00', 1),
(180, 'bmaegan', '2023-07-15', '19:00:00', 2),
(181, 'maganand', '2023-01-03', '11:00:00', 1),
(182, 'maganand', '2023-01-03', '19:00:00', 2),
(183, 'lalex', '2023-04-11', '11:00:00', 1),
(184, 'lalex', '2023-04-11', '18:00:00', 2),
(185, 'bretgabr', '2023-12-04', '11:00:00', 1),
(186, 'bretgabr', '2023-12-04', '17:00:00', 2),
(187, 'mapescas', '2023-10-11', '16:00:00', 1),
(188, 'mapescas', '2023-10-11', '19:00:00', 2),
(189, 'shantaeb', '2023-03-11', '10:00:00', 1),
(190, 'shantaeb', '2023-03-11', '18:00:00', 2),
(191, 'frenyaha', '2023-08-12', '13:00:00', 1),
(192, 'frenyaha', '2023-08-12', '19:00:00', 2),
(193, 'lalex', '2023-05-10', '10:00:00', 1),
(194, 'lalex', '2023-05-10', '19:00:00', 2),
(195, 'madeline', '2023-02-19', '08:30:00', 1),
(196, 'madeline', '2023-02-19', '14:00:00', 2),
(197, 'steffani', '2023-08-27', '08:00:00', 1),
(198, 'steffani', '2023-08-27', '17:00:00', 2),
(199, 'colemanm', '2023-09-01', '10:00:00', 1),
(200, 'colemanm', '2023-09-01', '19:00:00', 2),
(201, 'steffani', '2023-09-07', '07:00:00', 1),
(202, 'steffani', '2023-09-07', '12:00:00', 2),
(203, 'rhonakia', '2023-01-08', '11:00:00', 1),
(204, 'rhonakia', '2023-01-08', '18:00:00', 2),
(205, 'workerwa', '2023-01-20', '11:00:00', 1),
(206, 'workerwa', '2023-01-20', '18:30:00', 2),
(207, 'bretgabr', '2023-12-03', '11:00:00', 1),
(208, 'bretgabr', '2023-12-03', '18:00:00', 2),
(209, 'emerosro', '2023-05-10', '11:00:00', 1),
(210, 'emerosro', '2023-05-10', '18:30:00', 2),
(211, 'sippydon', '2023-09-21', '09:00:00', 1),
(212, 'sippydon', '2023-09-21', '15:00:00', 2),
(213, 'rhonakia', '2023-12-07', '16:00:00', 1),
(214, 'rhonakia', '2023-12-07', '22:00:00', 2),
(215, 'fideliai', '2023-02-13', '11:00:00', 1),
(216, 'fideliai', '2023-02-13', '21:00:00', 2),
(217, 'artisank', '2023-08-30', '08:00:00', 1),
(218, 'artisank', '2023-08-30', '23:00:00', 2),
(219, 'lalex', '2023-10-15', '21:00:00', 1),
(220, 'lalex', '2023-10-15', '22:00:00', 2),
(221, 'pucklant', '2023-08-21', '09:00:00', 1),
(222, 'pucklant', '2023-08-21', '14:00:00', 2),
(223, 'voorjane', '2023-06-19', '11:00:00', 1),
(224, 'voorjane', '2023-06-19', '18:00:00', 2),
(225, 'gayespell', '2023-03-25', '10:00:00', 1),
(226, 'gayespell', '2023-03-25', '19:00:00', 2),
(227, 'arianepo', '2023-01-05', '10:00:00', 1),
(228, 'arianepo', '2023-01-05', '13:00:00', 2),
(229, 'sharnasv', '2023-06-27', '09:00:00', 1),
(230, 'sharnasv', '2023-06-27', '18:00:00', 2),
(231, 'mapescas', '2023-07-15', '08:00:00', 1),
(232, 'mapescas', '2023-07-15', '18:30:00', 2),
(233, 'rhonakia', '2023-01-03', '10:00:00', 1),
(234, 'rhonakia', '2023-01-03', '19:00:00', 2),
(235, 'maganand', '2023-02-16', '11:00:00', 1),
(236, 'maganand', '2023-02-16', '19:00:00', 2),
(237, 'sharnasv', '2023-08-11', '13:00:00', 1),
(238, 'sharnasv', '2023-08-11', '19:00:00', 2),
(239, 'rhonakia', '2023-03-24', '12:00:00', 1),
(240, 'rhonakia', '2023-03-24', '18:30:00', 2),
(241, 'emerosro', '2023-03-25', '11:00:00', 1),
(242, 'emerosro', '2023-03-25', '19:00:00', 2),
(243, 'steffani', '2023-06-22', '10:00:00', 1),
(244, 'steffani', '2023-06-22', '18:30:00', 2),
(245, 'ardellen', '2023-05-13', '08:00:00', 1),
(246, 'ardellen', '2023-05-13', '11:00:00', 2),
(247, 'christim', '2023-03-05', '09:00:00', 1),
(248, 'christim', '2023-03-05', '15:30:00', 2),
(249, 'heidedra', '2023-06-04', '11:00:00', 1),
(250, 'heidedra', '2023-06-04', '18:00:00', 2),
(251, 'brandado', '2023-07-26', '11:00:00', 1),
(252, 'brandado', '2023-07-26', '16:00:00', 2),
(253, 'irishamy', '2023-11-30', '13:00:00', 1),
(254, 'irishamy', '2023-11-30', '19:00:00', 2),
(255, 'staceymo', '2023-02-26', '10:00:00', 1),
(256, 'staceymo', '2023-02-26', '18:00:00', 2),
(257, 'artisank', '2023-08-15', '09:00:00', 1),
(258, 'artisank', '2023-08-15', '15:00:00', 2),
(259, 'frenyaha', '2023-02-15', '08:00:00', 1),
(260, 'frenyaha', '2023-02-15', '18:30:00', 2),
(261, 'brandado', '2023-04-05', '09:00:00', 1),
(262, 'brandado', '2023-04-05', '17:00:00', 2),
(263, 'denyoror', '2023-11-27', '09:00:00', 1),
(264, 'denyoror', '2023-11-27', '15:00:00', 2),
(265, 'staceymo', '2023-02-13', '12:00:00', 1),
(266, 'staceymo', '2023-02-13', '16:00:00', 2),
(267, 'bretgabr', '2023-01-20', '11:00:00', 1),
(268, 'bretgabr', '2023-01-20', '19:00:00', 2),
(269, 'sharnasv', '2023-01-19', '10:00:00', 1),
(270, 'sharnasv', '2023-01-19', '18:00:00', 2),
(271, 'emerosro', '2023-01-19', '10:00:00', 1),
(272, 'emerosro', '2023-01-19', '16:00:00', 2),
(273, 'merkerta', '2023-09-04', '10:00:00', 1),
(274, 'merkerta', '2023-09-04', '19:00:00', 2),
(275, 'shantaeb', '2023-02-09', '10:30:00', 1),
(276, 'shantaeb', '2023-02-09', '17:00:00', 2),
(277, 'steffani', '2023-07-08', '10:00:00', 1),
(278, 'steffani', '2023-07-08', '18:00:00', 2),
(279, 'maryamgr', '2023-09-10', '08:00:00', 1),
(280, 'maryamgr', '2023-09-10', '16:30:00', 2),
(281, 'maganand', '2023-07-19', '09:00:00', 1),
(282, 'maganand', '2023-07-19', '18:00:00', 2),
(283, 'oceanusp', '2023-06-11', '07:00:00', 1),
(284, 'oceanusp', '2023-06-11', '18:00:00', 2),
(285, 'merkerta', '2023-02-04', '07:00:00', 1),
(286, 'merkerta', '2023-02-04', '18:00:00', 2),
(287, 'oceanusp', '2023-06-23', '09:00:00', 1),
(288, 'oceanusp', '2023-06-23', '15:00:00', 2),
(289, 'kossmali', '2023-10-03', '08:00:00', 1),
(290, 'kossmali', '2023-10-03', '18:30:00', 2),
(291, 'maryamgr', '2023-08-09', '07:30:00', 1),
(292, 'maryamgr', '2023-08-09', '11:00:00', 2),
(293, 'knapptan', '2023-10-17', '14:00:00', 1),
(294, 'knapptan', '2023-10-17', '19:00:00', 2),
(295, 'irishamy', '2023-03-22', '12:00:00', 1),
(296, 'irishamy', '2023-03-22', '19:00:00', 2),
(297, 'irishamy', '2023-09-09', '11:00:00', 1),
(298, 'irishamy', '2023-09-09', '13:00:00', 2);


CREATE OR REPLACE PROCEDURE export(IN tablename varchar, IN path text, IN separator char) AS $$
    BEGIN
        EXECUTE format('COPY %s TO ''%s'' DELIMITER ''%s'' CSV HEADER;',
            tablename, path, separator);
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE import(IN tablename varchar, IN path text, IN separator char) AS $$
    BEGIN
        EXECUTE format('COPY %s FROM ''%s'' DELIMITER ''%s'' CSV HEADER;',
            tablename, path, separator);
    END;
$$ LANGUAGE plpgsql;

-- ************CHECK PROCEDURES************
-- -- *****************EXPORT*****************
-- CALL export('Peers', '/Users/knapptan/Desktop/peers.csv', ',');
-- CALL export('Tasks', '/Users/knapptan/Desktop/Tasks.csv', ',');
-- CALL export('Checks', '/Users/knapptan/Desktop/checks.csv', ',');
-- CALL export('P2P', '/Users/knapptan/Desktop/p2p.csv', ',');
-- CALL export('verter', '/Users/knapptan/Desktop/verter.csv', ',');
-- CALL export('transferredpoints', '/Users/knapptan/Desktop/transferredpoints.csv', ',');
-- CALL export('friends', '/Users/knapptan/Desktop/friends.csv', ',');
-- CALL export('recommendations', '/Users/knapptan/Desktop/recommendations.csv', ',');
-- CALL export('xp', '/Users/knapptan/Desktop/xp.csv', ',');
-- CALL export('timetracking', '/Users/knapptan/Desktop/timetracking.csv', ',');

-- TRUNCATE TABLE Peers CASCADE;
-- TRUNCATE TABLE Tasks CASCADE;
-- TRUNCATE TABLE Checks CASCADE;
-- TRUNCATE TABLE P2P CASCADE;
-- TRUNCATE TABLE Verter CASCADE;
-- TRUNCATE TABLE Transferredpoints CASCADE;
-- TRUNCATE TABLE Friends CASCADE;
-- TRUNCATE TABLE Recommendations CASCADE;
-- TRUNCATE TABLE XP CASCADE;
-- TRUNCATE TABLE TimeTracking CASCADE;
-- SELECT * FROM Peers

-- *****************IMPORT*****************

-- /Users/knapptan/Desktop/
-- CALL import('Peers', '/Users/knapptan/Desktop/peers.csv', ',');
-- CALL import('Tasks', '/Users/knapptan/Desktop/Tasks.csv', ',');
-- CALL import('Checks', '/Users/knapptan/Desktop/checks.csv', ',');
-- CALL import('P2P', '/Users/knapptan/Desktop/p2p.csv', ',');
-- CALL import('verter', '/Users/knapptan/Desktop/verter.csv', ',');
-- CALL import('transferredpoints', '/Users/knapptan/Desktop/transferredpoints.csv', ',');
-- CALL import('friends', '/Users/knapptan/Desktop/friends.csv', ',');
-- CALL import('recommendations', '/Users/knapptan/Desktop/recommendations.csv', ',');
-- CALL import('xp', '/Users/knapptan/Desktop/xp.csv', ',');
-- CALL import('timetracking', '/Users/knapptan/Desktop/timetracking.csv', ',');


-- DROP TABLE checks CASCADE ;
-- DROP TABLE friends CASCADE ;
-- DROP TABLE p2p CASCADE ;
-- DROP TABLE peers CASCADE ;
-- DROP TABLE recommendations CASCADE ;
-- DROP TABLE tasks CASCADE ;
-- DROP TABLE timetracking CASCADE ;
-- DROP TABLE transferredpoints CASCADE ;
-- DROP TABLE verter CASCADE ;
-- DROP TABLE xp CASCADE ;
-- DROP TYPE check_status;

-- DROP PROCEDURE export CASCADE ;
-- DROP PROCEDURE import CASCADE ;