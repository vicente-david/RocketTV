"""
DRAFT models mapped from the EERD diagram we have right now

This is just a starting point so the stack has real tables to work with. Update to match our relational model once we finish. 
Once the table is updated we run:
docker compose exec backend python manage.py makemigrations

Derived attributes from the EERD (PlayerTotalStats, PlayerMatchStats,
TeamMatchStats, TeamGameStats) are NOT stored. They are computed from
PlayerGameStats (see api/sql/ for the stored procedures that do this).
"""
from django.contrib.auth.models import AbstractUser
from django.db import models


# Users (EERD: User d -> Admin | Viewer | Guest)
# Guests are not stored.
class User(AbstractUser):
    class Role(models.TextChoices):
        ADMIN = "admin", "Admin"
        VIEWER = "viewer", "Viewer"

    role = models.CharField(max_length=10, choices=Role.choices, default=Role.VIEWER)
    # Viewer - Follows - Team (M:N), plus the Viewer's FavouriteTeam attribute
    followed_teams = models.ManyToManyField("Team", blank=True, related_name="followers")
    favourite_team = models.ForeignKey(
        "Team", null=True, blank=True, on_delete=models.SET_NULL, related_name="favourited_by"
    )


# Regions, teams, players
class Region(models.Model):
    region_name = models.CharField(max_length=20, primary_key=True)  # NA, EU, APAC

    def __str__(self):
        return self.region_name


class Team(models.Model):
    team_id = models.AutoField(primary_key=True)
    team_name = models.CharField(max_length=100, unique=True)
    # Team - Originates from - Region (N:1, total on Team)
    region = models.ForeignKey(Region, on_delete=models.PROTECT, related_name="teams")

    def __str__(self):
        return self.team_name


class Player(models.Model):
    player_id = models.AutoField(primary_key=True)
    username = models.CharField(max_length=50, unique=True)
    name = models.CharField(max_length=100, blank=True)
    country_of_origin = models.CharField(max_length=60, blank=True)
    age = models.PositiveSmallIntegerField(null=True, blank=True)

    def __str__(self):
        return self.username


class PlaysFor(models.Model):
    """
    Player - Plays For - Team, with Role / StartDate / EndDate

    row with end_date NULL is the player's current team
    """

    player = models.ForeignKey(Player, on_delete=models.CASCADE, related_name="stints")
    team = models.ForeignKey(Team, on_delete=models.CASCADE, related_name="stints")
    role = models.CharField(max_length=30, blank=True)  # Player, Substitute, Coach
    start_date = models.DateField()
    end_date = models.DateField(null=True, blank=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=["player", "team", "start_date"], name="uniq_plays_for"),
        ]


# Seasons, splits, tournaments
class Season(models.Model):
    season_id = models.AutoField(primary_key=True)
    year = models.PositiveSmallIntegerField(unique=True)  # 2024, 2025, 2026

    def __str__(self):
        return str(self.year)


class Split(models.Model):
    """Weak entity: identified by (season, split_num)."""

    season = models.ForeignKey(Season, on_delete=models.CASCADE, related_name="splits")
    split_num = models.PositiveSmallIntegerField()

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=["season", "split_num"], name="uniq_split"),
        ]

    def __str__(self):
        return f"{self.season} Split {self.split_num}"


class Tournament(models.Model):
    """Superclass: Tournament d-> Worlds | SplitTournament (d-> Open | Major)."""

    tournament_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=150)
    start_date = models.DateField(null=True, blank=True)
    end_date = models.DateField(null=True, blank=True)
    teams = models.ManyToManyField(Team, through="ParticipatesIn", related_name="tournaments")

    def __str__(self):
        return self.name


class Worlds(Tournament):
    # Season - has final - Worlds (1:1), with Winning Team Name
    season = models.OneToOneField(Season, on_delete=models.CASCADE, related_name="worlds")
    winning_team = models.ForeignKey(
        Team, null=True, blank=True, on_delete=models.SET_NULL, related_name="worlds_wins"
    )


class SplitTournament(Tournament):
    # Split - Consists of - SplitTournament (1:N)
    split = models.ForeignKey(Split, on_delete=models.CASCADE, related_name="tournaments")


class Open(SplitTournament):
    open_number = models.PositiveSmallIntegerField()
    # Open - has associated - Region
    region = models.ForeignKey(Region, on_delete=models.PROTECT, related_name="opens")


class Major(SplitTournament):
    pass


class ParticipatesIn(models.Model):
    """Team -- Participates in -- Tournament (M:N), with Seed / Placement / Points."""

    tournament = models.ForeignKey(Tournament, on_delete=models.CASCADE)
    team = models.ForeignKey(Team, on_delete=models.CASCADE)
    seed = models.PositiveSmallIntegerField(null=True, blank=True)
    placement = models.PositiveSmallIntegerField(null=True, blank=True)
    points = models.PositiveIntegerField(default=0)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=["tournament", "team"], name="uniq_participation"),
        ]


# Matches (best of series) and games
class Match(models.Model):
    """Weak entity of Tournament: identified by (tournament, match_num)."""

    tournament = models.ForeignKey(Tournament, on_delete=models.CASCADE, related_name="matches")
    match_num = models.PositiveSmallIntegerField()  # EERD partial key "MatchID"
    teams = models.ManyToManyField(Team, through="CompetesIn", related_name="matches")

    class Meta:
        verbose_name_plural = "matches"
        constraints = [
            models.UniqueConstraint(fields=["tournament", "match_num"], name="uniq_match"),
        ]

    def __str__(self):
        return f"{self.tournament} #{self.match_num}"


class CompetesIn(models.Model):
    """Team -- Competes In -- Match. `score` = games won in the series."""

    match = models.ForeignKey(Match, on_delete=models.CASCADE)
    team = models.ForeignKey(Team, on_delete=models.CASCADE)
    score = models.PositiveSmallIntegerField(default=0)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=["match", "team"], name="uniq_competes_in"),
        ]


class Game(models.Model):
    """Weak entity of Match: identified by (match, game_num)."""

    match = models.ForeignKey(Match, on_delete=models.CASCADE, related_name="games")
    game_num = models.PositiveSmallIntegerField()  # EERD partial key "GameID"
    date = models.DateField(null=True, blank=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=["match", "game_num"], name="uniq_game"),
        ]

    def __str__(self):
        return f"{self.match} G{self.game_num}"


class TeamPlaysGame(models.Model):
    """Team -- Plays -- Game. `score` = goals scored in that game."""

    game = models.ForeignKey(Game, on_delete=models.CASCADE)
    team = models.ForeignKey(Team, on_delete=models.CASCADE)
    score = models.PositiveSmallIntegerField(default=0)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=["game", "team"], name="uniq_team_game"),
        ]


class PlayerGameStats(models.Model):
    """Player -- Plays -- Game, with the PlayerGameStats composite attribute."""

    game = models.ForeignKey(Game, on_delete=models.CASCADE, related_name="player_stats")
    player = models.ForeignKey(Player, on_delete=models.CASCADE, related_name="game_stats")
    team = models.ForeignKey(Team, on_delete=models.CASCADE)  # who they played for in this game
    score = models.PositiveIntegerField(default=0)
    goals = models.PositiveSmallIntegerField(default=0)
    assists = models.PositiveSmallIntegerField(default=0)
    saves = models.PositiveSmallIntegerField(default=0)
    shots = models.PositiveSmallIntegerField(default=0)
    demos = models.PositiveSmallIntegerField(default=0)
    ot_goals = models.PositiveSmallIntegerField(default=0)

    class Meta:
        verbose_name_plural = "player game stats"
        constraints = [
            models.UniqueConstraint(fields=["game", "player"], name="uniq_player_game"),
        ]
