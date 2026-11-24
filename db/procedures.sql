USE rockettv;

DROP PROCEDURE IF EXISTS GetAllTeams;
DROP PROCEDURE IF EXISTS GetTeamsByRegion;

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
DELIMITER ;
