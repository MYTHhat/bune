#!/bin/bash

# Dizini izlemek için inotifywait komutunu kullanın
inotifywait -r -m -e create,delete,move /home/ahmet/Desktop |
  while read path action file; do
    # Dosya adını ayrıştırın
    filename=$(basename "$file")
  
    # Eğer dosya oluşturulduysa veya taşındıysa
    if [[ $action == "CREATE" ]] || [[ $action == "MOVE" ]]; then
      # Dosya oluşturulma tarihini alın
      date=$(date +%Y-%m-%dT%T)
      # Dosya adını ve oluşturulma tarihini veritabanına ekleyin
      psql -h localhost -U postgres -d postgres -c "INSERT INTO changes (date, file_name) VALUES ('$date', '$filename');"
    # Eğer dosya silindiyse
    elif [[ $action == "DELETE" ]]; then
      # Dosya silinme tarihini alın
      delete_date=$(date +%Y-%m-%dT%T)
      # Dosya adını ve silinme tarihini veritabanına ekleyin
      psql -h localhost -U postgres -d postgres -c "UPDATE changes SET delete_date=NOW() WHERE file_name='$filename';"
    fi
  done

