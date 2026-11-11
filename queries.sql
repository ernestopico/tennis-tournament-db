-- Tennis Tournament Database - queries
-- Run schema.sql first. EXCEPT/INTERSECT need MySQL 8.0.31+.

USE TennisDB;

-- 1. INNER JOIN: full match results with tournament and player names
SELECT t.name AS tournament, m.round,
       CONCAT(w.firstName, ' ', w.lastName) AS winner,
       CONCAT(l.firstName, ' ', l.lastName) AS loser,
       m.score
FROM Matches m
INNER JOIN Tournaments t ON m.tournamentID = t.tournamentID
INNER JOIN Players w     ON m.winnerID = w.playerID
INNER JOIN Players l     ON m.loserID  = l.playerID
ORDER BY t.startDate, m.round DESC;

-- 2. Set operators: players who both won and lost vs. players who never lost
(SELECT winnerID AS playerID, 'Won and lost' AS category FROM Matches
 INTERSECT
 SELECT loserID, 'Won and lost' FROM Matches)
UNION
(SELECT winnerID, 'Never lost' FROM Matches
 EXCEPT
 SELECT loserID, 'Never lost' FROM Matches)
ORDER BY category, playerID;

-- 3. GROUP BY: matches played per surface
SELECT t.surface, COUNT(*) AS matchesPlayed
FROM Matches m, Tournaments t
WHERE m.tournamentID = t.tournamentID
GROUP BY t.surface;

-- 4. HAVING: players with 2 or more wins
SELECT p.firstName, p.lastName, COUNT(*) AS wins
FROM Matches m, Players p
WHERE m.winnerID = p.playerID
GROUP BY p.playerID, p.firstName, p.lastName
HAVING COUNT(*) >= 2
ORDER BY wins DESC;

-- 5. Subquery in WHERE: players coached by the most experienced coach
SELECT firstName, lastName, country
FROM Players
WHERE coachID = (SELECT coachID FROM Coaches
                 ORDER BY yearsExperience DESC LIMIT 1);

-- 6. Subquery in FROM: tournaments with above-average match counts
SELECT t.name, mc.matchCount
FROM Tournaments t,
     (SELECT tournamentID, COUNT(*) AS matchCount
      FROM Matches GROUP BY tournamentID) mc
WHERE t.tournamentID = mc.tournamentID
  AND mc.matchCount > (SELECT COUNT(*) / COUNT(DISTINCT tournamentID) FROM Matches);

-- 7. Correlated subquery: players ranked better than their country's average
SELECT p.firstName, p.lastName, p.country, p.ranking
FROM Players p
WHERE p.ranking < (SELECT AVG(p2.ranking) FROM Players p2
                   WHERE p2.country = p.country);

-- 8. Derived table: win/loss record per player
SELECT p.firstName, p.lastName,
       COALESCE(w.wins, 0)   AS wins,
       COALESCE(l.losses, 0) AS losses
FROM Players p
LEFT JOIN (SELECT winnerID, COUNT(*) AS wins   FROM Matches GROUP BY winnerID) w
       ON p.playerID = w.winnerID
LEFT JOIN (SELECT loserID,  COUNT(*) AS losses FROM Matches GROUP BY loserID)  l
       ON p.playerID = l.loserID
ORDER BY wins DESC, losses ASC;
