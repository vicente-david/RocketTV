from django.urls import path

from . import views

urlpatterns = [
    path("health/", views.health),
    path("team/", views.team),
    path("teams/region/<str:region>/", views.teams_by_region),
    path("players/<int:player_id>/stats/", views.player_stats),
    path("players/<int:player_id>/", views.player),
]
