# API contract for the UI

The UI (frontend/src/api.js) calls these URLs. Anything not built yet is served from
`frontend/src/mock.js` and a yellow banner lists which endpoints are still mocked.
Build an endpoint with the same JSON shape and the page switches to real data, no UI change.
Unknown ids should return HTTP 404 with a JSON body (e.g. `{"error":"not found"}`).

| URL | Returns | Status |
|---|---|---|
| `GET /api/team/` | `{teams:[{team_id,team_name,region_name}]}` | exists |
| `GET /api/teams/region/<r>/` | same shape, filtered | exists |
| `GET /api/regions/` | `{regions:["NA","EU","MENA"]}` | mocked |
| `GET /api/tournaments/` | `{tournaments:[{tournament_id,type,season_id,split_num,region_name,name,location,start_date,end_date}]}` newest first; type is Worlds/Major/Open | mocked |
| `GET /api/tournaments/<id>/` | `{tournament:{...as above}, standings:[{team_id,team_name,region_name,seed,placement,points}], matches:[match]}` | mocked |
| `GET /api/matches/recent/` | `{matches:[match]}` (about 5) | mocked |
| `GET /api/matches/<tid>/<mid>/` | `{match, games:[{game_id,date,team1_score,team2_score}], player_stats:[{player_id,username,team_id,team_name,games,goals,assists,saves,shots,demos,score,ot_goals}]}` | mocked |
| `GET /api/teams/<id>/` | `{team:{team_id,team_name,region_name}, record:{match_wins,match_losses}, roster:[{player_id,username,name,origin_country,role,start_date,end_date}], matches:[match]}` | mocked |
| `GET /api/players/<id>/` | `{player:{player_id,username,name,origin_country,date_of_birth}, totals:{games,goals,assists,ot_goals,demos,shooting_pct,wins,losses,score,saves,shots}, teams:[{team_id,team_name,role,start_date,end_date}]}` | mocked |
| `GET /api/leaderboard/<stat>/<region>/` | `{rows:[{player_id,username,team_name,games,value}]}`; stat = goals/assists/saves/score/demos, region = `ALL` or a region | mocked |
| `GET /api/head-to-head/<a>/<b>/` | `{team_a,team_b,a_wins,b_wins,matches:[match]}` | mocked |
| `GET /api/search/?q=` | `{results:[{kind:"Team"\|"Player",id,name,detail}]}` | mocked |

`match` = `{tournament_id,tournament_name,match_id,team1_id,team1_name,team2_id,team2_name,team1_score,team2_score,best_of,date}`
(date = date of the first game).

Dates as `YYYY-MM-DD`. Decimals as numbers. Keys are snake_case like the existing endpoints.
