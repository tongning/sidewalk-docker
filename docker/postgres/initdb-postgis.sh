#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Create the 'template_postgis' template db
"${psql[@]}" <<- 'EOSQL'
CREATE DATABASE template_postgis;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';
EOSQL

# Load PostGIS into both template_database and $POSTGRES_DB
for DB in template_postgis "$POSTGRES_DB"; do
	echo "Loading PostGIS extensions into $DB"
	"${psql[@]}" --dbname="$DB" <<-'EOSQL'
		CREATE EXTENSION IF NOT EXISTS postgis;
		CREATE EXTENSION IF NOT EXISTS postgis_topology;
		CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
		CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;
EOSQL
done

# Sidewalk-specific
# Edit the following to change the name of the database user that will be created:
APP_DB_USER=vagrant
APP_DB_PASS=sidewalk

# Edit the following to change the name of the database that is created (defaults to the user name)
APP_DB_NAME=sidewalk

cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';

-- Create the database:
CREATE DATABASE $APP_DB_NAME WITH OWNER=$APP_DB_USER
                                  LC_COLLATE='en_US.utf8'
                                  LC_CTYPE='en_US.utf8'
                                  ENCODING='UTF8'
                                  TEMPLATE=template0;

-- Give permisssions of the database to the new user:
GRANT ALL PRIVILEGES ON DATABASE $APP_DB_NAME to $APP_DB_USER; 

-- Create the user 'sidewalk'
CREATE ROLE sidewalk LOGIN;
ALTER USER sidewalk WITH PASSWORD 'sidewalk';
ALTER USER sidewalk SUPERUSER;
GRANT ALL PRIVILEGES ON DATABASE sidewalk TO sidewalk;

-- Create the schema 'sidewalk'
CREATE SCHEMA sidewalk;
GRANT ALL ON ALL TABLES IN SCHEMA sidewalk TO sidewalk;
ALTER DEFAULT PRIVILEGES IN SCHEMA sidewalk GRANT ALL ON TABLES TO sidewalk;
ALTER DEFAULT PRIVILEGES IN SCHEMA sidewalk GRANT ALL ON SEQUENCES TO sidewalk;

\c sidewalk;
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;

EOF

psql -d sidewalk -a -f /tmp/sidewalk.sql

echo "Successfully created PostgreSQL dev virtual machine."
echo ""

