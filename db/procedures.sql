USE rockettv;

DROP PROCEDURE IF EXISTS GetAllTeams;
DROP PROCEDURE IF EXISTS GetTeamsByRegion;
DROP PROCEDURE IF EXISTS GetPlayerCareerStats;
DROP PROCEDURE IF EXISTS GetPlayer;
DROP PROCEDURE IF EXISTS GetPlayerTeamHistory;

DELIMITER //
CREATE PROCEDURE GetAllTeams()
BEGIN
    SELECT 
        TeamID AS team_id,
        TeamName AS team_name,
        RegionName AS region_name
    FROM Team
    ORDER BY TeamID;
END //

CREATE PROCEDURE GetTeamsByRegion(IN p_region VARCHAR(100))
BEGIN
    SELECT
        TeamID AS team_id,
        TeamName AS team_name,
        RegionName AS region_name
    FROM Team
    WHERE Team.RegionName = p_region
    ORDER BY TeamID;
END //

CREATE PROCEDURE GetPlayerCareerStats(IN p_player_id INT)
BEGIN
    SELECT
        COUNT(*)                       AS games,
        COALESCE(SUM(PPG.Goals), 0)    AS goals,
        COALESCE(SUM(PPG.Assists), 0)  AS assists,
        COALESCE(SUM(PPG.Saves), 0)    AS saves,
        COALESCE(SUM(PPG.Shots), 0)    AS shots,
        COALESCE(SUM(PPG.Demos), 0)    AS demos,
        COALESCE(SUM(PPG.OTGoals), 0)  AS ot_goals,
        COALESCE(SUM(PPG.Score), 0)    AS score,
        ROUND( 100 * SUM(PPG.Goals) / NULLIF(SUM(PPG.Shots), 0), 1) AS shooting_pct,
        COALESCE(SUM(CASE
            WHEN PPG.TeamID = SM.Team1ID AND G.Team1Score > G.Team2Score THEN 1
            WHEN PPG.TeamID = SM.Team2ID AND G.Team2Score > G.Team1Score THEN 1
            ELSE 0
        END), 0)                       AS wins,
        COALESCE(SUM(CASE
            WHEN PPG.TeamID = SM.Team1ID AND G.Team1Score < G.Team2Score THEN 1
            WHEN PPG.TeamID = SM.Team2ID AND G.Team2Score < G.Team1Score THEN 1
            ELSE 0
        END), 0)                       AS losses
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
        P.PlayerID AS player_id,
        P.Username AS username,
        P.Name AS name,
        P.OriginCountry AS origin_country,
        TIMESTAMPDIFF(YEAR, P.DateOfBirth, CURDATE()) AS age,
        P.DateOfBirth AS date_of_birth,
        T.TeamID   AS current_team_id,
        T.TeamName AS current_team_name
    FROM Player P
    LEFT JOIN PlayerPlaysForTeam PPT
        ON PPT.PlayerID = P.PlayerID AND PPT.EndDate IS NULL
    LEFT JOIN Team T
        ON T.TeamID = PPT.TeamID
    WHERE P.PlayerID = p_player_id;
END //

CREATE PROCEDURE GetPlayerTeamHistory(IN p_player_id INT)
BEGIN
    SELECT 
        T.TeamID AS team_id,
        T.TeamName AS team_name,
        PPT.Role AS role,
        PPT.StartDate AS start_date,
        PPT.EndDate AS end_date
    FROM PlayerPlaysForTeam PPT
    JOIN Team T
        ON T.TeamID = PPT.TeamID
    WHERE PPT.PlayerID = p_player_id
    ORDER BY start_date DESC;
END // 
DELIMITER ;
