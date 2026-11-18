-- SQLBook: Code

-- Miscellaneous functionalities


-- calculate player total stats
-- let playerID = 0
-- Games, Goals, Assists, OTGoals, Demos, Shooting% (goals/totalshots), W/L (wins/total games), Score, Saves, Shots
-- considering layerPlaysGame already have the stats 
SELECT COUNT(*) AS Games,
    SUM(Goals), SUM(Assists), SUM(OTGoals), SUM(Demos),
    SUM(Goals)/NULLIF(SUM(Shots),0),
    SUM(Score), SUM(Saves),
    SUM(Shots)
FROM PlayerPlaysGame
WHERE PlayerID = 4;

-- calculate number of wins
-- for a player with id = 0
-- to uniquely identify a game, we need tournament id, game id, match id
-- we need to join with match to determine if player's team is team1 or team2
-- to uniquely identify a match we need match id and tournament id
-- then just case analysis, we need if team1 was player and their score was > team 2
-- or if team2 was player and their score was > team 1
SELECT COUNT(*)
FROM PlayerPlaysGame PPG JOIN Game G ON
    PPG.TournamentID = G.TournamentID AND
    PPG.GameID = G.GameID AND
    PPG.MatchID = G.MatchID
JOIN SeriesMatch SM ON
    G.TournamentID = SM.TournamentID AND
    G.MatchID = SM.MatchID
WHERE PPG.PlayerID = 4
AND (
    (PPG.TeamID = SM.Team1ID AND G.Team1Score > G.Team2Score)
    OR
    (PPG.TeamID = SM.Team2ID AND G.Team2Score > G.Team1Score)
    );

-- calculate number of losses (flip the signs on the above query)
SELECT COUNT(*)
FROM PlayerPlaysGame PPG JOIN Game G ON
    PPG.TournamentID = G.TournamentID AND
    PPG.GameID = G.GameID AND
    PPG.MatchID = G.MatchID
JOIN SeriesMatch SM ON
    G.TournamentID = SM.TournamentID AND
    G.MatchID = SM.MatchID
WHERE PPG.PlayerID = 4
AND (
    (PPG.TeamID = SM.Team1ID AND G.Team1Score < G.Team2Score)
    OR
    (PPG.TeamID = SM.Team2ID AND G.Team2Score < G.Team1Score)
    );
-- win/loss is just win/ totalGames easy to calculate in application



-- Functional requirements 

-- Register account
-- Creates new entry
INSERT INTO Viewer (Username, Password, Email)
VALUES ('username', 'password', 'example@email.com');

-- Login
-- Checks against existing entry
SELECT EXISTS(
    SELECT UserID
    FROM Admin
    WHERE Username = 'TheBestPLAYER267' AND Password = 'rocketleague420'

    UNION

    SELECT UserID
    FROM Viewer
    WHERE Username = 'TheBestPLAYER267' AND Password = 'rocketleague420'
);



-- Update account info
-- Updates existing entry and queries against existing entry
UPDATE Viewer
SET Email = 'new@email.com', Password = 'newpassword'
WHERE UserID = 1;

SELECT UserID, Username, Email, FavouriteTeamID
FROM Viewer
WHERE UserID = 1;

-- Browse tournament and brackets (similar to the screenshot)
-- Query all tournaments, sort in order by year descending

-- query all tournaments
SELECT TournamentID
FROM Tournament 
ORDER BY StartDate DESC;
-- additionally if we want worlds, splits, majors and opens
-- depending on what the user clicks, we just query that
-- Suppose year is 2026
SELECT *
FROM Worlds W JOIN Tournament T ON (W.TournamentID = T.TournamentID)
WHERE T.StartDate >= '2026-01-01' AND T.StartDate < '2027-01-01';

-- Splits
-- say split 2 majors in 2026  
SELECT *
FROM Split S JOIN Major M ON 
    (S.SeasonID = M.SeasonID) AND
    (S.SplitNum = M.SplitNum)
JOIN Tournament T ON
    (T.TournamentID = M.TournamentID)
WHERE (T.StartDate >= '2026-01-01' AND T.StartDate < '2027-01-01' AND S.SplitNum = 2);

-- say split 2 opens in 2026
SELECT *
FROM Split S JOIN Open O ON 
    (S.SeasonID = O.SeasonID) AND
    (S.SplitNum = O.SplitNum)
JOIN Tournament T ON
    (T.TournamentID = O.TournamentID)
WHERE (T.StartDate >= '2026-01-01' AND T.StartDate < '2027-01-01' AND S.SplitNum = 2);

-- if we want all tournaments, worlds + majors + opens
-- don't restrict to the split num for majors and opens, 
-- and we can join directly
-- ex: all opens played in 2026
SELECT * 
FROM Tournament T JOIN Open O ON
    (T.TournamentID = O.TournamentID)
WHERE (T.StartDate >= '2026-01-01' AND T.StartDate < '2027-01-01')
ORDER BY SplitNum, OpenNum, RegionName;

-- all tournaments played in 2026 , worlds + majors + opens
SELECT T.TournamentID, T.StartDate, 'Worlds' AS Type
FROM Tournament T JOIN Worlds W ON T.TournamentID = W.TournamentID
WHERE T.StartDate >= '2026-01-01' AND T.StartDate < '2027-01-01'
UNION
SELECT T.TournamentID, T.StartDate, 'Major'
FROM Tournament T JOIN Major M ON T.TournamentID = M.TournamentID
WHERE T.StartDate >= '2026-01-01' AND T.StartDate < '2027-01-01'
UNION
SELECT T.TournamentID, T.StartDate, 'Open'
FROM Tournament T JOIN `Open` O ON T.TournamentID = O.TournamentID
WHERE T.StartDate >= '2026-01-01' AND T.StartDate < '2027-01-01'
ORDER BY StartDate DESC;


-- Tournament standings
-- Query a specific tournament id/year and then calculate points for each team for that tournament (ex: worlds 2026, query 2026 worlds, and then determine points)
SELECT Tm.TeamName, TPT.Seed, TPT.Placement, TPT.Points
FROM TeamParticipatesInTournament TPT JOIN Team Tm ON Tm.TeamID = TPT.TeamID
WHERE TPT.TournamentID = 1
ORDER BY TPT.Points DESC;


-- View Team page
-- Query all players for a specific team and list their stats
SELECT P.PlayerID, P.Username, PPT.Role,
    SUM(PPG.Goals), SUM(PPG.Assists), SUM(PPG.Saves), SUM(PPG.Shots)
FROM PlayerPlaysForTeam PPT
JOIN Player P ON P.PlayerID = PPT.PlayerID
LEFT JOIN PlayerPlaysGame PPG ON PPG.PlayerID = P.PlayerID AND PPG.TeamID = PPT.TeamID
WHERE PPT.TeamID = 1 AND PPT.EndDate IS NULL
GROUP BY P.PlayerID, P.Username, PPT.Role;

-- View player page & player career stats
-- Inspect a specific player, and their stats, find the tournaments they played in
SELECT * FROM Player WHERE PlayerID = 1;
-- stats: use the player total stats query above
SELECT DISTINCT T.TournamentID, T.StartDate, T.EndDate
FROM PlayerPlaysGame PPG JOIN Tournament T ON T.TournamentID = PPG.TournamentID
WHERE PPG.PlayerID = 1
ORDER BY T.StartDate DESC;

-- View player leaderboards
-- List all players with and order by a stat (function to be determined just denote f for now which takes all playerstats as input)
-- function f to be determined, it will be a combination of goals, score, demos, saves, etc.
-- like for example f(player0) := 2*goals + 3*demos
-- then the 1st player would have the highest f value 
-- for right now we'll just order by f(playerID) = 2*goals + 3*demos
SELECT P.PlayerID, P.Username, 2*SUM(PPG.Goals) + 3*SUM(PPG.Demos) AS f   -- when we picks a formula, replace the SUM(PPG.Goals) with f(stats)
FROM Player P JOIN PlayerPlaysGame PPG ON PPG.PlayerID = P.PlayerID
GROUP BY P.PlayerID, P.Username
ORDER BY f DESC;

-- View match and game results
-- See all matches played
-- We can group by team or tournament
SELECT SM.TournamentID, SM.MatchID, T1.TeamName AS Team1, T2.TeamName AS Team2,
    SM.Team1Score, SM.Team2Score, SM.BestOf
FROM SeriesMatch SM
JOIN Team T1 ON T1.TeamID = SM.Team1ID
JOIN Team T2 ON T2.TeamID = SM.Team2ID
ORDER BY SM.TournamentID, SM.MatchID;
-- by team (team 1): add WHERE SM.Team1ID = 1 OR SM.Team2ID = 1
-- by tournament (tournament 1): add WHERE SM.TournamentID = 1
-- games of one match
SELECT GameID, Team1Score, Team2Score, Date
FROM Game WHERE TournamentID = 1 AND MatchID = 1;


-- Search team/players
-- Self explanatory, query players and teams with substring method or what not
SELECT 'Team' AS Kind, TeamID AS ID, TeamName AS Name FROM Team
WHERE TeamName LIKE '%ne%'
UNION
SELECT 'Player', PlayerID, Username FROM Player
WHERE Username LIKE '%ne%' OR Name LIKE '%ne%';

-- follow/unfollow team
-- Updates the table (viewerfollowsteam)
INSERT INTO ViewerFollowsTeam (UserID, TeamID) VALUES (1, 2);
DELETE FROM ViewerFollowsTeam WHERE UserID = 1 AND TeamID = 2;

-- Set favourite team
-- Updates favourite team entry
UPDATE Viewer SET FavouriteTeamID = 2 WHERE UserID = 1;

-- View followed team(s)
-- See View team page, but restrict it to followed teams
SELECT Tm.TeamName, P.Username, SUM(PPG.Goals), SUM(PPG.Assists)
FROM ViewerFollowsTeam F
JOIN Team Tm ON Tm.TeamID = F.TeamID
JOIN PlayerPlaysForTeam PPT ON PPT.TeamID = F.TeamID AND PPT.EndDate IS NULL
JOIN Player P ON P.PlayerID = PPT.PlayerID
LEFT JOIN PlayerPlaysGame PPG ON PPG.PlayerID = P.PlayerID AND PPG.TeamID = F.TeamID
WHERE F.UserID = 1
GROUP BY Tm.TeamName, P.Username;
