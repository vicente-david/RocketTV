from django.db import connection          # Django's link to MySQL (settings.py configures it)
from django.http import JsonResponse      # turns Python data into a JSON response

from decimal import Decimal

def rows_as_dicts(cursor):
    # cursor.description describes each column of the result
    # col[0] is its name, which is the AS name from the procedures
    columns = [col[0] for col in cursor.description]
    results = []
    for row in cursor.fetchall():
        # mysql returns SUM results as Decimal numbers, which would
        # appear in the JSON as text. convert them to numbers
        values = [float(v) if isinstance(v, Decimal) else v for v in row]
        # zip pairs each column name with its value: ("Goals", 3), ("Wins", 3), etc
        results.append(dict(zip(columns, values)))
    return results

def call(procedure, params=()):
    with connection.cursor() as cursor:
        cursor.callproc(procedure, params)
        return rows_as_dicts(cursor)

def health(request):                      # a "view": takes the request, returns a response
    with connection.cursor() as cursor:   # open a cursor = a handle for running SQL
        cursor.execute("SELECT VERSION()")      # send SQL to MySQL
        version = cursor.fetchone()[0]          # get one row; [0] = its first column
    return JsonResponse({"status": "ok", "mysql_version": version})

def team(request):
    return JsonResponse({"teams": call("GetAllTeams")})

def teams_by_region(request, region):
    return JsonResponse({"teams": call("GetTeamsByRegion", [region])})

def player(request, player_id):
    details = call("GetPlayer", [player_id])
    if not details:
        return JsonResponse({"error": "Player not found."}, status=404)
    return JsonResponse({
        "player": details[0],
        "totals": call("GetPlayerCareerStats", [player_id])[0],
        "teams":  call("GetPlayerTeamHistory", [player_id]),
    })