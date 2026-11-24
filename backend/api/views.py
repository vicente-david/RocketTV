from django.db import connection          # Django's link to MySQL (settings.py configures it)
from django.http import JsonResponse      # turns Python data into a JSON response

def health(request):                      # a "view": takes the request, returns a response
    with connection.cursor() as cursor:   # open a cursor = a handle for running SQL
        cursor.execute("SELECT VERSION()")      # send SQL to MySQL
        version = cursor.fetchone()[0]          # get one row; [0] = its first column
    return JsonResponse({"status": "ok", "mysql_version": version})

def team(request):
    with connection.cursor() as cursor:
        cursor.callproc("GetAllTeams")
        rows = cursor.fetchall()
    results = [] # the empty list
    for row in rows:
        results.append({"team_id": row[0], "team_name": row[1], "region_name": row[2]})
    return JsonResponse({"teams": results})

def teams_by_region(request, region):
    with connection.cursor() as cursor:
        cursor.callproc("GetTeamsByRegion", [region])
        rows = cursor.fetchall()
    results = []
    for row in rows:
        results.append({"team_id": row[0], "team_name": row[1], "region_name": row[2]})
    return JsonResponse({"teams": results})