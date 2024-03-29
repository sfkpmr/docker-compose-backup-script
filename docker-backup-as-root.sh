#!/bin/bash
#Docker bind backup script - root used to make tar.gz, user used to copy tar.gz to backup directory.

#Exit immediately if a pipeline returns a non-zero status - https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -e

DATE=$(date '+%Y-%m-%d')

DOCKERCOMPOSEFILE=
BACKUPPATH=
BACKUPNAME=
BACKUPUSER=

cd /tmp

#Pause containers, backup and unpause containers
#The -f option should directly precede the filename. So, use tar -vczf filename.tar.gz instead of -vcfz
docker-compose -f "${DOCKERCOMPOSEFILE}" pause && tar -zvcpf "$BACKUPNAME" /docker && chown "$BACKUPUSER":"$BACKUPUSER" "$BACKUPNAME" && su - "$BACKUPUSER" -c "cp /tmp/$BACKUPNAME $BACKUPPATH" && rm -f "$BACKUPNAME"
docker-compose -f "${DOCKERCOMPOSEFILE}" unpause
