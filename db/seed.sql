USE rockettv;

INSERT INTO Region(RegionName) VALUES
    ('NA'),
    ('EU'),
    ('MENA'); -- pivot from APAC. MENA is a stronger and more competitive region than APAC.

INSERT INTO Team(TeamName, RegionName) VALUES
    ('Gentle Mates', 'EU'), -- TeamID = 1
    ('Karmine Corp', 'EU'), -- TeamID = 2
    ('NRG', 'NA'), -- TeamID = 3
    ('Shopify Rebellion', 'NA'), -- TeamID = 4
    ('Team Falcons', 'MENA'), -- TeamID = 5
    ('Twisted Minds', 'MENA'), -- TeamID = 6

    ('Vitality', 'EU'), -- TeamID = 7
    ('Team BDS', 'EU'); -- TeamID = 8

INSERT INTO Player(Username, Name, OriginCountry, DateOfBirth) VALUES
    -- EU
    -- -- Gentle Mates
    ('zen', 'Alex Bernier', 'France', '2004-03-11'), -- PlayerID = 1
    ('Atow', 'Tristan Soyez', 'Belgium', '2003-07-29'), -- PlayerID = 2
    ('Vatira', 'Axel Touret', 'France', '2002-12-02'), -- PlayerID = 3
    -- -- KC
    ('MOnkey MOOn', 'Evan Rogez', 'France', '2000-06-18'), -- PlayerID = 4
    ('bibbaba', 'Attila Eötvös', 'Hungary', '2005-01-24'), -- PlayerID = 5
    ('reyyn', NULL, 'France', NULL), -- PlayerID = 6

    -- NA
    -- -- NRG
    ('frosty', 'Kenneth Walz', 'United States', '2004-09-30'), -- PlayerID = 7
    ('2Piece', 'Jayden Horton', 'United States', '2002-08-14'), -- PlayerID = 8
    ('Wahvey', 'Dylan Thanus', 'United States', '2003-11-07'), -- PlayerID = 9
    -- -- SR
    ('Atomic', 'Massimo Franceschi', 'United States', '2001-02-16'), -- PlayerID = 10
    ('Daniel', 'Daniel Piecenski', 'United States', '2003-04-03'), -- PlayerID = 11
    ('Firstkiller', 'Jason Corral', 'United States', '2001-10-21'), -- PlayerID = 12

    -- MENA
    -- -- Team Falcons
    ('dralii', 'Samy Hajji', 'Morocco', '2004-05-27'), -- PlayerID = 13
    ('Kiileerrz', 'Yazid Abdullah Bakhashwin', 'Saudi Arabia', '2003-01-09'), -- PlayerID = 14
    ('Rw9', 'Saleh Abdullah Bakhashwin', 'Saudi Arabia', '2003-01-09'), -- PlayerID = 15
    -- -- Twisted Minds
    ('Nwpo', 'Hisham Alqadi', 'Saudi Arabia', '2004-08-12'), -- PlayerID = 16
    ('Ghaazi', 'Ghaazi Al-Otaibi', 'Saudi Arabia', '2002-03-25'), -- PlayerID = 17
    ('trk511', 'Mohammed Alotaibi', 'Saudi Arabia', '2001-07-05'); -- PlayerID = 18

INSERT INTO PlayerPlaysForTeam(PlayerID, TeamID, StartDate, EndDate, Role) VALUES
    -- GM8
    (1, 1, '2024-10-27', NULL, 'starter'),
    (1, 7, '2022-10-01', '2024-10-27', 'starter'), -- zen previous stint
    (2, 1, '2024-10-27', NULL, 'starter'),
    (3, 1, '2024-10-27', NULL, 'starter'),
    -- KC
    (4, 2, '2023-10-27', NULL, 'starter'),
    (5, 2, '2023-10-27', NULL, 'starter'),
    (6, 2, '2023-10-27', NULL, 'starter'),
    -- NRG
    (7, 3, '2024-10-27', NULL, 'starter'),
    (8, 3, '2024-10-27', NULL, 'starter'),
    (9, 3, '2024-10-27', NULL, 'starter'),
    -- SR
    (10, 4, '2022-10-27', NULL, 'starter'),
    (11, 4, '2022-10-27', NULL, 'starter'),
    (12, 4, '2023-09-26', NULL, 'starter'),
    -- Team Falcons
    (13, 5, '2024-09-18', NULL, 'starter'),
    (14, 5, '2023-12-08', NULL, 'starter'),
    (15, 5, '2023-12-08', NULL, 'starter'),
    -- Twisted Minds
    (16, 6, '2024-07-14', NULL, 'starter'),
    (17, 6, '2021-10-28', NULL, 'starter'),
    (18, 6, '2025-10-02', NULL, 'starter');

INSERT INTO Season(SeasonID, WinningTeamID) VALUES
    (2024, 8),
    (2025, 3),
    (2026, 5),
    (2027, NULL);

INSERT INTO Split(SeasonID, SplitNum) VALUES
    (2025, 1),
    (2025, 2);

INSERT INTO Tournament(TournamentID, StartDate, EndDate) VALUES
    (1, '2025-09-10', '2025-09-14'), -- 2025 Worlds

    (2, '2025-01-03', '2025-01-12'), -- EU Open 1, Split 1
    (3, '2025-01-05', '2025-01-14'), -- NA Open 2, Split 1
    (4, '2025-01-07', '2025-01-16'), -- MENA Open 3, Split 1

    (5, '2025-03-27', '2025-03-30'); -- 2025 Split 1 Major 1

INSERT INTO Worlds(TournamentID, SeasonID, Location) VALUES
    (1, 2025, 'Lyon, France'); -- 2025 worlds

INSERT INTO Major(TournamentID, SeasonID, SplitNum, Location) VALUES
    (5, 2025, 1, 'Birmingham, UK');

INSERT INTO Open(TournamentID, SeasonID, SplitNum, OpenNum, RegionName) VALUES
    (2, 2025, 1, 1, 'EU'),
    (3, 2025, 1, 2, 'NA'),
    (4, 2025, 1, 3, 'MENA');

INSERT INTO TeamParticipatesInTournament(TournamentID, TeamID, Seed, Placement, Points) VALUES
    (1, 1, 10, 8, 5), -- GM8s in worlds 2025
    (1, 2, 1, 2, 20), -- KC in worlds 2025
    (1, 3, 2, 1, 40), -- NRG in worlds 2025

    (2, 1, 3, 4, 10), -- gm8s in eu open 1 split 1
    (2, 2, 1, 1, 40), -- kc in eu open 1 split 1

    (3, 3, 1, 1, 40), -- nrg in na open 2 split 1
    (3, 4, 3, 7, 8), -- sr in na open 2 split 1

    (4, 5, 1, 1, 40), -- falcons in mena open 3 split 1
    (4, 6, 2, 2, 20), -- tm in mena open 3 split 1

    (5, 5, 1, 2, 20), -- falcons in birmingnham major 2025
    (5, 3, 3, 1, 40), -- nrg in birmingnham major 2025
    (5, 2, 2, 3, 15); -- kc in birmingnham major 2025

INSERT INTO SeriesMatch(TournamentID, MatchID, Team1ID, Team2ID, Team1Score, Team2Score, BestOf) VALUES
    (1, 1, 3, 2, 4, 2, 7), -- worlds final between NRG and KC
    (2, 1, 1, 2, 0, 3, 5); -- eu open 1 match between kc and gm8s

INSERT INTO Game(TournamentID, MatchID, GameID, Team1Score, Team2Score, Date) VALUES
    -- worlds matches
    (1, 1, 1, 3, 2, '2025-09-14'), -- nrg win
    (1, 1, 2, 7, 5, '2025-09-14'), -- nrg win
    (1, 1, 3, 2, 4, '2025-09-14'), -- kc win
    (1, 1, 4, 1, 0, '2025-09-14'), -- nrg win
    (1, 1, 5, 3, 4, '2025-09-14'), -- kc win
    (1, 1, 6, 6, 5, '2025-09-14'), -- nrg win and win series 4-2
    
    -- eu open 1 match
    (2, 1, 1, 1, 3, '2025-01-10'), -- kc win
    (2, 1, 2, 0, 3, '2025-01-10'), -- kc win
    (2, 1, 3, 2, 3, '2025-01-10'); -- kc win

INSERT INTO PlayerPlaysGame(TournamentID, MatchID, GameID, PlayerID, TeamID, Demos, Score, Goals, Assists, Saves, Shots, OTGoals) VALUES
    (2, 1, 1, 4, 2, 0, 520, 1, 1, 1, 2, 0),
    (2, 1, 2, 4, 2, 1, 722, 2, 0, 3, 4, 0),
    (2, 1, 3, 4, 2, 0, 212, 0, 0, 1, 0, 0),

    (2, 1, 1, 5, 2, 0, 150, 0, 0, 2, 1, 0),
    (2, 1, 2, 5, 2, 0, 219, 0, 0, 1, 3, 0),
    (2, 1, 3, 5, 2, 0, 305, 1, 0, 3, 1, 0),

    (2, 1, 1, 6, 2, 1, 515, 2, 0, 3, 3, 0),
    (2, 1, 2, 6, 2, 2, 620, 1, 1, 3, 4, 0),
    (2, 1, 3, 6, 2, 1, 700, 2, 1, 3, 2, 0),


    (2, 1, 1, 1, 1, 1, 105, 0, 1, 3, 0, 0),
    (2, 1, 2, 1, 1, 0, 305, 0, 0, 6, 1, 0),
    (2, 1, 3, 1, 1, 0, 500, 2, 0, 4, 5, 0),

    (2, 1, 1, 2, 1, 1, 305, 1, 0, 3, 3, 0),
    (2, 1, 2, 2, 1, 0, 305, 0, 0, 6, 1, 0),
    (2, 1, 3, 2, 1, 0, 400, 0, 0, 4, 5, 0),

    (2, 1, 1, 3, 1, 0, 50, 0, 0, 0, 0, 0),
    (2, 1, 2, 3, 1, 0, 115, 0, 0, 2, 0, 0),
    (2, 1, 3, 3, 1, 0, 210, 0, 0, 4, 1, 0);

INSERT INTO Admin(UserID, Password, Username, Email) VALUES
    (1, 'abcdefghi', 'FirstADMIN229', 'iloverl2@gmail.com'),
    (2, 'jklmnopqrst', 'Second_adminXD', 'admin4life@hotmail.com');

INSERT INTO Viewer(UserID, Password, Username, Email, FavouriteTeamID) VALUES
    (1, 'rocketleague420', 'TheBestPLAYER267', 'bestplayer@yahoo.ca', 1),
    (2, 'PASSWORD123', 'OvrB4ItStrtd', 'alrightalright@gmail.com', NULL);

INSERT INTO ViewerFollowsTeam(UserID, TeamID) VALUES
    (1, 1),
    (1, 4),
    (1, 3),
    (2, 6);