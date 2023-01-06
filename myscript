#!/bin/bash

inotifywait -r -m -e create,delete,move /home/ahmet/Desktop |
while read path action file; do
filename=$(basename "$file")

if [[ $action == "CREATE" ]] || [[ $action == "MOVE" ]]; then
  date=$(date +%Y-%m-%dT%T)
  psql -h localhost -U postgres -d postgres -c "INSERT INTO changes (date, file_name) VALUES ('$date', '$filename');"

elif [[ $action == "DELETE" ]]; then
  delete_date=$(date +%Y-%m-%dT%T)
  psql -h localhost -U postgres -d postgres -c "UPDATE changes SET delete_date=NOW() WHERE file_name='$filename' AND delete_date IS NULL;"
fi
done
