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

Admin accounts come from ``db/seed.sql``. So no ``createsuperuser`` step is needed.

*NOTE:* Our sample data is shared through ``db/seed.sql``. Go to **Step 4** to see the required steps for how to edit our tables or data.

After all the steps above, when we want to run the app, all we need to do is run `docker compose up`.
We stop with `Ctrl+C`.

## 3. Project layout

```
docker-compose.yml     db + backend + frontend services
db/
  schema.sql           Contains the tables for our database
  seed.sql             Contains the data for our tables.
  queries.sql          Contains all of our queries needed for our app features. NOT loaded automaticcaly and running it WILL change data.
backend/
  config/              Django settings and root URLs
  api/
    views.py, urls.py  API endpoints under /api/
frontend/
  src/App.jsx          React entry page
  vite.config.js       sends /api requests to Django
```

## 4. Changing the database

We can update/modify our tables, and their data by modifying ``db/schema.sql``, which contains our tables, or ``db/seed.sql``, which contains our sample data. 

1. Edit ``schema.sql`` or ``seed.sql`` as needed.
2. ``docker compose down -v`` which stops and removes the containers. -v also deletes the volumes. This is necessary because MySQL only runs the initialization files on empty volumes. If a volume is non-empty, it won't "update" it. 
3. ``docker compose up --build`` to restart the initialization.
4. Commit the SQL files. When any member pulls a change to them, they must also repeat **step 2**. 

*NOTE:* ``schema.sql``and ``seed.sql`` load automatically on a fresh database because of the following lines 12-13 in ``docker-compose.yml``: 
```
- ./db/schema.sql:/docker-entrypoint-initdb.d/01_schema.sql
- ./db/seed.sql:/docker-entrypoint-initdb.d/02_seed.sql 
```