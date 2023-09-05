#! /bin/bash

#: Title		: Backup all MySQL Databases
#: Date			: 2014
#: Author		: github.com/vujke
#: Version		: 1.0
#: Description	: 

DATE=$(date +"%d%m%Y%H%M")

MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
MYSQL_HOST="localhost"
MYSQL_USERNAME=""
MYSQL_PASSWORD=""
BACKUP_DIR="$HOME/Downloads/mysqldump"
DATABASE_DIR="$BACKUP_DIR/$DATABASE_NAME"
SQL_FILE="$DATABASE_NAME"
EMAIL="@gmail.com"
TIME=$(date)

# Check if database directory exist
[ ! -d "$BACKUP_DIR" ]  && mkdir -p $BACKUP_DIR

# Delete databases older than 15 days
find $BACKUP_DIR/$DATABASE_NAME* -mtime +15 -exec rm {} \;

# List all databases
# SHOW DATABASES is regular MySQL command that shows all databases
# Command grep -Ev will NOT show defined database(s)
LIST_OF_DATABASES=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|sys)"`

for DATABASE_NAME in $LIST_OF_DATABASES; do
  $MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $DATABASE_NAME --skip-lock-tables > ${BACKUP_DIR}/${DATABASE_NAME}_${DATE}.sql
  # Compress every database
  gzip -q $BACKUP_DIR/*
done

#printf "Total number of backed up database(s): %s\n" "$(wc -l <<< "$LIST_OF_DATABASES")"

for file in $BACKUP_DIR/*$DATE* ; do
  [[ -f "${file}" ]] || continue
  ATTACHMENT+=( "-a" "${file}" )
done

echo -e "User: ${USER}\n\nHost: ${HOSTNAME}" "\n\nTotal number of backed up database(s):" $(wc -l <<< "$LIST_OF_DATABASES") \\n"${LIST_OF_DATABASES}" "\n\nTime: $TIME" "\n\nSee attachment:" | mailx ${ATTACHMENT[@]} -s "MySQL back up at ${USER}@${HOSTNAME}" $EMAIL 
