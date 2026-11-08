-- Election database: sample data
-- ALL DATA BELOW IS FICTIONAL: made-up people, parties and IDs for demonstration only.

USE election_db;
GO

INSERT INTO Election (election_date) VALUES ('2024-03-31');

INSERT INTO Voter (voter_name, voter_surname, sign_picture, citizenship_id, voter_address, election_id)
VALUES
    ('Ada',   'Example',  'voter01.png', 10000000001, 'Sample Street 1, District A', 1),
    ('Bora',  'Sample',   'voter02.png', 10000000002, 'Sample Street 2, District B', 1),
    ('Ceren', 'Demo',     'voter03.png', 10000000003, 'Sample Street 3, District C', 1),
    ('Deniz', 'Testoglu', 'voter04.png', 10000000004, 'Sample Street 4, District D', 1),
    ('Elif',  'Mock',     'voter05.png', 10000000005, 'Sample Street 5, District E', 1),
    ('Fatih', 'Placeholder', 'voter06.png', 10000000006, 'Sample Street 6, District F', 1),
    ('Gül',   'Fiction',  'voter07.png', 10000000007, 'Sample Street 7, District G', 1),
    ('Hakan', 'Imaginary', 'voter08.png', 10000000008, 'Sample Street 8, District H', 1),
    ('Irmak', 'Dummy',    'voter09.png', 10000000009, 'Sample Street 9, District I', 1);

INSERT INTO Party (P_Name)
VALUES ('Party A'), ('Party B'), ('Party C'), ('Party D'), ('Party E');

-- Independent candidates run without a party
INSERT INTO Party (P_Name) VALUES ('Independent Candidate');

INSERT INTO Candidate (party_id, election_id, voter_id)
VALUES (1, 1, 6), (2, 1, 7), (3, 1, 8), (4, 1, 9);

INSERT INTO Area (area_name)
VALUES ('Adalar'), ('Arnavutköy'), ('Ataşehir'), ('Avcılar'), ('Bağcılar'),
       ('Bahçelievler'), ('Bakırköy'), ('Başakşehir'), ('Bayrampaşa'), ('Beşiktaş'),
       ('Beykoz'), ('Beylikdüzü'), ('Beyoğlu'), ('Büyükçekmece'), ('Çatalca'),
       ('Çekmeköy'), ('Esenler'), ('Esenyurt'), ('Eyüpsultan'), ('Fatih'),
       ('Gaziosmanpaşa'), ('Güngören'), ('Kadıköy'), ('Kağıthane'), ('Kartal'),
       ('Küçükçekmece'), ('Maltepe'), ('Pendik'), ('Sancaktepe'), ('Sarıyer'),
       ('Silivri'), ('Sultanbeyli'), ('Sultangazi'), ('Şile'), ('Şişli'),
       ('Tuzla'), ('Ümraniye'), ('Üsküdar'), ('Zeytinburnu');

-- One or more ballot boxes per area (area_id repeats where an area has several boxes)
INSERT INTO Ballotbox (area_id, election_id)
VALUES (1,1),(2,1),(2,1),(2,1),(3,1),(3,1),(4,1),(4,1),(5,1),(5,1),(6,1),(6,1),(6,1),(6,1),
       (7,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(17,1),
       (18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(26,1),(27,1),(28,1),(29,1),
       (30,1),(31,1),(32,1),(33,1),(34,1),(35,1),(36,1),(37,1),(38,1),(38,1),(38,1),(38,1);

INSERT INTO Vote (candidate_id, ballotbox_id)
VALUES (1,10), (1,11), (2,30), (3,2), (3,29), (4,3), (1,23), (2,17);
GO
