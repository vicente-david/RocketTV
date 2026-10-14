# Setup and Info (not a README, we'll simplify that one)


| Part     | Tech                    | Where                          |
|----------|-------------------------|--------------------------------|
| Frontend | React (Vite)            | http://localhost:5173          |
| Backend  | Django                  | http://localhost:8000          |
| Database | MySQL 8.4               | `localhost:3307`               |

Everything runs in Docker. We don't need Python, Node or MySQL installed.

## 1. Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/), installed, open or running in background (wait for "Engine running")

## 2. Initial setup

```bash
git clone https://github.com/vicente-david/RocketTV.git
cd RocketTV
docker compose up --build
```

Create our own admin login (open a second terminal in the repo folder):

```bash
docker compose exec backend python manage.py createsuperuser
```

Note that each one of us has our own local database, so data we add on our own computer is
not shared unless we migrate and push through git.

After all the steps above, when we want to run the app, all we need to do is run `docker compose up`.
We stop with `Ctrl+C`.

## 3. Project layout

```
docker-compose.yml     db + backend + frontend services
backend/
  config/              Django settings and root URLs
  api/
    models.py          database tables (from our EERD)
    migrations/        schema history (database table changes, make sure to makemigrate then commit)
    views.py, urls.py  API endpoints under /api/
    admin.py           admin panel registration
frontend/
  src/App.jsx          React entry page
  vite.config.js       sends /api requests to Django
```

## 4. Changing the database

We use Django migrations, so the tables are defined in `backend/api/models.py`.

1. Edit `backend/api/models.py`.
2. Create the migration:
   ```bash
   docker compose exec backend python manage.py makemigrations
   ```
3. Apply it by restarting the backend (migrations run on start):
   ```bash
   docker compose restart backend
   ```
4. Commit changes to Git

When somebody else changes the database, we pull migration using `docker compose restart backend`.

If 2 of us create migrations at the same time Django reports conflicting
migrations (sort of like git merge conflict). After resolving, run the command `python manage.py makemigrations --merge`.

Note that `AUTH_USER_MODEL` is `api.User` (Admin / Viewer roles). Don't change it once migrations exist.
