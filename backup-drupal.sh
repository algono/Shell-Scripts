#!/bin/sh

## Script made by: Alejandro Gomez - algono - 11/02/2020

# Get current date
current_date=$(date)

# Replace spaces with underscores
current_date=${current_date// /_}

# Replace colons with underscores
current_date=${current_date//:/_}

backup_folder="$HOME/backups/backup_$current_date"

# Creates the directory if it doesnt exist
mkdir -p -v "$backup_folder"

# Dump the sql database
# (change the user and database to yours)
user = "drupal1"
database = "drupal1"
mysqldump -u "$user" -p "$database" > "$backup_folder/database.sql"

# Change this to your drupal project's name
web_directory="my_site_name_dir"

# Do backup from web directory
tar zcvf "$backup_folder/drupal_directory.tgz" "/var/www/html/$web_directory"
