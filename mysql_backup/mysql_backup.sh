#! /bin/bash

DATE=$(date +"%d%m%Y%H%M")

MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
MYSQL_HOST="localhost"
MYSQL_USERNAME="vujke"
MYSQL_PASSWORD=""
# DATABASE_NAME=""

BACKUP_DIR="$HOME/backup/mysql"
DATABASE_DIR="$BACKUP_DIR/$DATABASE_NAME"

# Check if database directory exist
[ ! -d "$BACKUP_DIR" ]  && mkdir -p $BACKUP_DIR

DATABASES=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema)"`

for DATABASE_NAME in $DATABASES; do
  $MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $DATABASE_NAME --skip-lock-tables | gzip > "$BACKUP_DIR/$([ ! -d "$BACKUP_DIR/$DATABASE_NAME" ]  && mkdir -p $BACKUP_DIR/$DATABASE_NAME)/$DATABASE_NAME"_"$DATE.gz"
done
