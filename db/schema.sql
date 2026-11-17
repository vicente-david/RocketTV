DROP DATABASE IF EXISTS rockettv_report;
CREATE DATABASE rockettv_report;
USE rockettv_report;

CREATE TABLE Region (
    RegionName  VARCHAR(100)    NOT NULL,
    PRIMARY KEY (RegionName)
);

CREATE TABLE Team (
    TeamID      INT             NOT NULL AUTO_INCREMENT,
    TeamName    VARCHAR(100)    NOT NULL UNIQUE,
    RegionName  VARCHAR(100)    NOT NULL,
    PRIMARY KEY (TeamID),
    FOREIGN KEY (RegionName) REFERENCES Region(RegionName)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE Player (
    PlayerID        INT             NOT NULL AUTO_INCREMENT,
    Username        VARCHAR(100)    NOT NULL UNIQUE,
    FName           VARCHAR(50)     NOT NULL,
    LName           VARCHAR(50)     NOT NULL,
    OriginCountry   VARCHAR(50),
    DateOfBirth     DATE,
    PRIMARY KEY (PlayerID)
);

CREATE TABLE Season (
    SeasonID        INT     NOT NULL AUTO_INCREMENT,
    WinningTeamID   INT,
    PRIMARY KEY (SeasonID),
    FOREIGN KEY (WinningTeamID) REFERENCES Team(TeamID)
        ON DELETE RESTRICT
);

CREATE TABLE Split (
    SeasonID    INT     NOT NULL,
    SplitNum    INT     NOT NULL CHECK (SplitNum BETWEEN 1 and 2),
    PRIMARY KEY (SeasonID, SplitNum),
    FOREIGN KEY (SeasonID) REFERENCES Season(SeasonID)
        ON DELETE CASCADE
);

CREATE TABLE Tournament (
    TournamentID    INT     NOT NULL AUTO_INCREMENT,
    StartDate       DATE,
    EndDate         DATE,
    PRIMARY KEY (TournamentID),
    CHECK (EndDate >= StartDate)
);

CREATE TABLE Worlds (
    TournamentID    INT             NOT NULL,
    SeasonID        INT             NOT NULL,
    Location        VARCHAR(200),
    PRIMARY KEY (TournamentID),
    FOREIGN KEY (TournamentID) REFERENCES Tournament(TournamentID)
        ON DELETE CASCADE,
    FOREIGN KEY (SeasonID) REFERENCES Season(SeasonID),
    UNIQUE (SeasonID)
);

CREATE TABLE Major (
    TournamentID    INT             NOT NULL,
    SeasonID        INT             NOT NULL,
    SplitNum        INT             NOT NULL,
    Location        VARCHAR(200),
    PRIMARY KEY (TournamentID), 
    FOREIGN KEY (TournamentID) REFERENCES Tournament(TournamentID)
        ON DELETE CASCADE,
    FOREIGN KEY (SeasonID, SplitNum) REFERENCES Split(SeasonID, SplitNum),
    UNIQUE (SeasonID, SplitNum)
);

CREATE TABLE Open (
    TournamentID    INT             NOT NULL,
    SeasonID        INT             NOT NULL,
    SplitNUm        INT             NOT NULL,
    OpenNum         INT             NOT NULL,
    RegionName      VARCHAR(100)    NOT NULL,
    PRIMARY KEY (TournamentID), 
    FOREIGN KEY (TournamentID) REFERENCES Tournament(TournamentID)
        ON DELETE CASCADE,
    FOREIGN KEY (SeasonID, SplitNum) REFERENCES Split(SeasonID, SplitNum),
    FOREIGN KEY (RegionName) REFERENCES Region(RegionName),
    UNIQUE (OpenNum, RegionName, SeasonID, SplitNum)
);

CREATE TABLE TeamParticipatesInTournament (
    TournamentID    INT             NOT NULL,
    TeamID          INT             NOT NULL,
    Seed            INT             NOT NULL CHECK (Seed > 0),
    Placement       INT             CHECK (Placement > 0),
    Points          INT             NOT NULL DEFAULT 0,
    PRIMARY KEY (TournamentID, TeamID),
    FOREIGN KEY (TournamentID) REFERENCES Tournament(TournamentID)
        ON DELETE CASCADE,
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

CREATE TABLE PlayerPlaysForTeam (
    PlayerID        INT             NOT NULL,
    TeamID          INT             NOT NULL,
    StartDate       DATE            NOT NULL,
    EndDate         DATE,
    Role            VARCHAR(50)     NOT NULL CHECK (Role IN ('starter', 'substitute', 'captain')),
    PRIMARY KEY (PlayerID, TeamID, StartDate),
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    CHECK (EndDate >= StartDate)
);

CREATE TABLE SeriesMatch (
    TournamentID        INT     NOT NULL,
    MatchID             INT     NOT NULL,
    Team1ID             INT     NOT NULL,
    Team2ID             INT     NOT NULL,
    Team1Score          INT     NOT NULL DEFAULT 0,
    Team2Score          INT     NOT NULL DEFAULT 0,
    BestOf              INT     NOT NULL CHECK (BestOf IN (5, 7)),
    PRIMARY KEY (TournamentID, MatchID),
    FOREIGN KEY (TournamentID) REFERENCES Tournament(TournamentID)
        ON DELETE CASCADE,
    FOREIGN KEY (Team1ID) REFERENCES Team(TeamID),
    FOREIGN KEY (Team2ID) REFERENCES Team(TeamID),
    CHECK (Team1ID != Team2ID)
);

CREATE TABLE Game (
    TournamentID        INT     NOT NULL,
    MatchID             INT     NOT NULL,
    GameID              INT     NOT NULL CHECK (GameID BETWEEN 1 and 7),
    Team1Score          INT     NOT NULL DEFAULT 0,
    Team2Score          INT     NOT NULL DEFAULT 0,
    Date                DATE    NOT NULL,
    PRIMARY KEY (TournamentID, MatchID, GameID),
    FOREIGN KEY (TournamentID, MatchID) REFERENCES SeriesMatch(TournamentID, MatchID)
        ON DELETE CASCADE
);

CREATE TABLE PlayerPlaysGame (
    TournamentID        INT     NOT NULL,
    MatchID             INT     NOT NULL,
    GameID              INT     NOT NULL,
    PlayerID            INT     NOT NULL,
    TeamID              INT     NOT NULL,
    Demos               INT     NOT NULL DEFAULT 0,
    Score               INT     NOT NULL DEFAULT 0,
    Goals               INT     NOT NULL DEFAULT 0,
    Assists             INT     NOT NULL DEFAULT 0,
    Saves               INT     NOT NULL DEFAULT 0,
    Shots               INT     NOT NULL DEFAULT 0,
    OTGoals             INT     NOT NULL DEFAULT 0,
    PRIMARY KEY (TournamentID, MatchID, GameID, PlayerID),
    FOREIGN KEY (TournamentID, MatchID, GameID) REFERENCES Game(TournamentID, MatchID, GameID)
        ON DELETE CASCADE,
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

CREATE TABLE Admin (
    UserID      INT             NOT NULL AUTO_INCREMENT,
    Password    VARCHAR(255)    NOT NULL,
    Username    VARCHAR(25)     NOT NULL UNIQUE,
    Email       VARCHAR(100)    NOT NULL UNIQUE,
    PRIMARY KEY (UserID)
);

CREATE TABLE Viewer (
    UserID              INT             NOT NULL AUTO_INCREMENT,
    Password            VARCHAR(255)    NOT NULL,
    Username            VARCHAR(25)     NOT NULL UNIQUE,
    Email               VARCHAR(100)    NOT NULL UNIQUE,
    FavouriteTeamID     INT,
    PRIMARY KEY (UserID),
    FOREIGN KEY (FavouriteTeamID) REFERENCES Team(TeamID)
        ON DELETE SET NULL
);

CREATE TABLE ViewerFollowsTeam (
    UserID      INT     NOT NULL,
    TeamID      INT     NOT NULL,
    PRIMARY KEY (UserID, TeamID),
    FOREIGN KEY (UserID) References Viewer(UserID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (TeamID) References Team(TeamID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);