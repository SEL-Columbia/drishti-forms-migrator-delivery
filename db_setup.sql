CREATE DATABASE forms_migration;

CREATE ROLE forms_migration_role;

GRANT ALL PRIVILEGES ON DATABASE forms_migration TO forms_migration_role;

CREATE USER forms_migration_user WITH NOSUPERUSER LOGIN ROLE forms_migration_role PASSWORD 'bottlebuttermilk';