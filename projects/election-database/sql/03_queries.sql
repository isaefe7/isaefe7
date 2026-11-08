-- Election database: example queries (T-SQL)
-- Covers aggregates, filtering, grouping, joins and views.

USE election_db;
GO

-- Latest election date
SELECT MAX(election_date) AS LatestElectionDate FROM Election;

-- Smallest ballot box id that received a vote
SELECT MIN(ballotbox_id) AS MinBallotBoxId FROM Vote;

-- IN
SELECT * FROM Party WHERE id IN (3);

-- BETWEEN
SELECT * FROM Area WHERE id BETWEEN 1 AND 20;

-- DISTINCT + COUNT: how many different voters are candidates?
SELECT COUNT(DISTINCT voter_id) AS DistinctCandidateVoters FROM Candidate;

-- ORDER BY
SELECT * FROM Area ORDER BY area_name;

-- GROUP BY + HAVING
SELECT Candidate.id, COUNT(Candidate.id) AS CandidateCount
FROM Candidate
GROUP BY Candidate.id
HAVING COUNT(Candidate.id) = 1;

-- TOP
SELECT TOP 5 * FROM Candidate;

-- JOIN: voters and their election date
SELECT Election.election_date, Voter.voter_name
FROM Election
JOIN Voter ON Election.id = Voter.election_id;

-- JOIN across three tables: candidate name, party and candidate id
SELECT Voter.voter_name, Party.P_Name, Candidate.id AS CandidateId
FROM Voter
JOIN Candidate ON Voter.id = Candidate.voter_id
JOIN Party     ON Candidate.party_id = Party.id;
GO

-- VIEW
CREATE VIEW ElectionVoter AS
SELECT Election.id AS ElectionID, Voter.voter_name
FROM Election
JOIN Voter ON Election.id = Voter.election_id;
GO

-- ALTER VIEW: expose the surname as well
ALTER VIEW ElectionVoter AS
SELECT Election.id AS ElectionID, Voter.voter_name, Voter.voter_surname
FROM Election
JOIN Voter ON Election.id = Voter.election_id;
GO

SELECT * FROM ElectionVoter;
GO
