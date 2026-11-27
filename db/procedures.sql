USE rockettv;

DROP PROCEDURE IF EXISTS GetAllTeams;
DROP PROCEDURE IF EXISTS GetTeamsByRegion;
DROP PROCEDURE IF EXISTS GetPlayerCareerStats;
DROP PROCEDURE IF EXISTS GetPlayer;

DELIMITER //
CREATE PROCEDURE GetAllTeams()
BEGIN
    SELECT TeamID, TeamName, RegionName FROM Team
    ORDER BY TeamID;
END //

CREATE PROCEDURE GetTeamsByRegion(IN p_region VARCHAR(100))
BEGIN
    SELECT TeamID, TeamName, RegionName FROM Team
    WHERE Team.RegionName = p_region
    ORDER BY TeamID;
END //

CREATE PROCEDURE GetPlayerCareerStats(IN p_player_id INT)
BEGIN
    SELECT
        COUNT(*)                       AS Games,
        COALESCE(SUM(PPG.Goals), 0)    AS Goals,
        COALESCE(SUM(PPG.Assists), 0)  AS Assists,
        COALESCE(SUM(PPG.Saves), 0)    AS Saves,
        COALESCE(SUM(PPG.Shots), 0)    AS Shots,
        COALESCE(SUM(PPG.Demos), 0)    AS Demos,
        COALESCE(SUM(PPG.OTGoals), 0)  AS OTGoals,
        COALESCE(SUM(PPG.Score), 0)    AS Score,
        SUM(PPG.Goals) / NULLIF(SUM(PPG.Shots), 0) AS ShootingPct,
        COALESCE(SUM(CASE
            WHEN PPG.TeamID = SM.Team1ID AND G.Team1Score > G.Team2Score THEN 1
            WHEN PPG.TeamID = SM.Team2ID AND G.Team2Score > G.Team1Score THEN 1
            ELSE 0
        END), 0)                       AS Wins,
        COALESCE(SUM(CASE
            WHEN PPG.TeamID = SM.Team1ID AND G.Team1Score < G.Team2Score THEN 1
            WHEN PPG.TeamID = SM.Team2ID AND G.Team2Score < G.Team1Score THEN 1
            ELSE 0
        END), 0)                       AS Losses
    FROM PlayerPlaysGame PPG
    JOIN Game G
        ON  G.TournamentID = PPG.TournamentID
        AND G.MatchID      = PPG.MatchID
        AND G.GameID       = PPG.GameID
    JOIN SeriesMatch SM
        ON  SM.TournamentID = G.TournamentID
        AND SM.MatchID      = G.MatchID
    WHERE PPG.PlayerID = p_player_id;
END //

CREATE PROCEDURE GetPlayer(IN p_player_id INT)
BEGIN
    SELECT 
    Username,
    Name,
    OriginCountry,
    TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) AS Age
    FROM Player 
    WHERE PlayerID = p_player_id;
END //
DELIMITER ;
