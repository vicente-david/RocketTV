-- SQLBook: Code

-- Miscellaneous functionalities


-- calculate player total stats
-- let playerID = 0
-- Games, Goals, Assists, OTGoals, Demos, Shooting% (goals/totalshots), W/L (wins/total games), Score, Saves, Shots
SELECT COUNT(*) AS Games, 
    SUM(Goals), SUM(Assists), SUM(OTGoals), SUM(Demos),
    SUM(Goals)/SUM(Shots), 
    SUM(Score), SUM(Saves),
    SUM(Shots)
FROM PlayerPlaysGame PPG JOIN Game 
ON PPG.GameID = Game.GameID
WHERE PPG.PlayerID = 0;

-- calculate number of wins
-- for a player with id = 0
-- to uniquely identify a game, we need tournament id, game id, match id
-- we need to join with match to determine if player's team is team1 or team2
-- to uniquely identify a match we need match id and tournament id
-- then just case analysis, we need if team1 was player and their score was > team 2
-- or if team2 was player and their score was > team 1
SELECT COUNT(*)
FROM PlayerPlaysGame PPG JOIN GAME G ON
    PPG.TournamentID = G.TournamentID AND
    PPG.GameID = G.GameID
    PPG.MatchID = G.MatchID
JOIN SeriesMatch SM ON Game G
    G.TournamentID = SM.TournamentID AND
    G.MatchID = SM.MatchID
WHERE PPG.PlayerID = 0
AND (
    (PPG.TeamID = SM.Team1ID AND G.Team1Score > G.Team2Score) 
    OR
    (PPG.TeamID = SM.Team2ID AND G.Team2Score > G.Team1Score)
    );

-- calculate number of losses (flip the signs on the above query)
SELECT COUNT(*)
FROM PlayerPlaysGame PPG JOIN GAME G ON
    PPG.TournamentID = G.TournamentID AND
    PPG.GameID = G.GameID
    PPG.MatchID = G.MatchID
JOIN SeriesMatch SM ON Game G
    G.TournamentID = SM.TournamentID AND
    G.MatchID = SM.MatchID
WHERE PPG.PlayerID = 0
AND (
    (PPG.TeamID = SM.Team1ID AND G.Team1Score < G.Team2Score) 
    OR
    (PPG.TeamID = SM.Team2ID AND G.Team2Score < G.Team1Score)
    );

-- win/loss is just win/ totalGames easy to calculate in application



-- Functional requirements 

-- Register account
-- Creates new entry


-- Login
-- Checks against existing entry
-- let username = '0'  and password = '123'
SELECT EXISTS(
    SELECT UserID
    FROM Admin
    WHERE Username = '0' AND Password = '123'

    UNION

    SELECT UserID
    FROM Viewer
    WHERE Username = '0' AND Password = '123'
);



-- Update account info
-- Updates existing entry and queries against existing entry

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
WHERE (T.StartDate >= '2026-01-01' AND T.StartDate < '2027-01-01' AND S.splitNum = 2)

-- say split 2 opens in 2026
SELECT *
FROM Split S JOIN Open O ON 
    (S.SeasonID = O.SeasonID) AND
    (S.SplitNum = O.SplitNum)
JOIN Tournament T ON
    (T.TournamentID = O.TournamentID)
WHERE (T.StartDate >= '2026-01-01' AND T.StartDate < '2027-01-01' AND S.splitNum = 2);

-- if we want all tournaments, worlds + majors + opens
-- don't restrict to the split num for majors and opens, 
-- and we can join directly
SELECT * 
FROM Tournament T JOIN Open O ON
    (T.Tournament ID = O.TournamentID)
WHERE (T.StartDate >= '2026-01-01' AND T.StartDate < '2027-01-01');




-- Tournament standings
-- Query a specific tournament id/year and then calculate points for each team for that tournament (ex: worlds 2026, query 2026 worlds, and then determine points)

-- View Team page
-- Query all players for a specific team and list their stats

-- View player page & player career stats
-- Inspect a specific player, and their stats, find the tournaments they played in

-- View player leaderboards
-- List all players with and order by a stat (function to be determined just denote f for now which takes all playerstats as input)

-- View match and game results
-- See all matches played
-- We can group by team or tournament


-- Search team/players
-- Self explanatory, query players and teams with substring method or what not

-- follow/unfollow team
-- Updates the table (viewerfollowsteam)
INSERT INTO ViewerFollowsTeam (UserID, TeamID) VALUES (1, 2);
DELETE FROM ViewerFollowsTeam WHERE UserID = 1 AND TeamID = 2;

-- Set favourite team
-- Updates favourite team entry
UPDATE Viewer SET FavouriteTeamID = 2 WHERE UserID = 1;

-- View followed team(s)
-- See View team page, but restrict it to followed teams
SELECT Tm.TeamName, P.Username, SUM(PPG.Goals) AS Goals, SUM(PPG.Assists) AS Assists
FROM ViewerFollowsTeam F
JOIN Team Tm ON Tm.TeamID = F.TeamID
JOIN PlayerPlaysForTeam PPT ON PPT.TeamID = F.TeamID AND PPT.EndDate IS NULL
JOIN Player P ON P.PlayerID = PPT.PlayerID
LEFT JOIN PlayerPlaysGame PPG ON PPG.PlayerID = P.PlayerID AND PPG.TeamID = F.TeamID
WHERE F.UserID = 1
GROUP BY Tm.TeamName, P.Username;
