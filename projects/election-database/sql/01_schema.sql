-- Election database: schema (T-SQL / Microsoft SQL Server)
-- Consolidated final state of the incremental scripts written during the course
-- (the original ALTER TABLE steps are merged into the CREATE TABLE statements).

CREATE DATABASE election_db;
GO
USE election_db;
GO

CREATE TABLE Election (
    id            INT PRIMARY KEY IDENTITY(1,1),
    election_date DATE NOT NULL
);

CREATE TABLE Voter (
    id             INT PRIMARY KEY IDENTITY(1,1),
    voter_name     VARCHAR(50)  NOT NULL,
    voter_surname  VARCHAR(50)  NOT NULL,
    sign_picture   VARCHAR(50)  NOT NULL,
    citizenship_id BIGINT       NOT NULL,   -- was VARCHAR(50): a number needs far less space
    voter_address  VARCHAR(150) NOT NULL,
    election_id    INT FOREIGN KEY REFERENCES Election(id)
);

CREATE TABLE Party (
    id     INT PRIMARY KEY IDENTITY(1,1),
    P_Name VARCHAR(150) UNIQUE NOT NULL     -- widened from 50: some party names are long
);

CREATE TABLE Candidate (
    id          INT PRIMARY KEY IDENTITY(1,1),
    party_id    INT FOREIGN KEY REFERENCES Party(id),
    election_id INT FOREIGN KEY REFERENCES Election(id),
    voter_id    INT FOREIGN KEY REFERENCES Voter(id)   -- "Candidate is-a Voter"
);

CREATE TABLE Area (
    id        INT PRIMARY KEY IDENTITY(1,1),
    area_name VARCHAR(50) NOT NULL
);

-- ballotBox_no was dropped: the id is enough to identify a ballot box.
CREATE TABLE Ballotbox (
    id          INT PRIMARY KEY IDENTITY(1,1),
    area_id     INT FOREIGN KEY REFERENCES Area(id),
    election_id INT FOREIGN KEY REFERENCES Election(id)
);

CREATE TABLE Vote (
    id           INT PRIMARY KEY IDENTITY(1,1),
    candidate_id INT FOREIGN KEY REFERENCES Candidate(id),  -- who the vote was given to
    ballotbox_id INT FOREIGN KEY REFERENCES Ballotbox(id)   -- where it was cast
);
GO
