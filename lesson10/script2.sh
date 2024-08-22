#!/bin/bash

# Переменная для пути к папке myfolder в домашней директории
DIR="$HOME/myfolder"

# Проверка, существует ли папка myfolder
if [ -d "$DIR" ]; then
  # Подсчет количества файлов в папке
  file_count=$(ls -1 "$DIR" | wc -l)
  echo "Количество файлов в папке $DIR: $file_count"
  
  # Изменение прав второго файла на 664
  if [ -f "$DIR/file2.txt" ]; then
    chmod 664 "$DIR/file2.txt"
  fi
  
  # Удаление пустых файлов
  find "$DIR" -type f -empty -delete
  
  # Удаление всех строк кроме первой в остальных файлах
  for file in "$DIR"/*; do
    if [ -f "$file" ]; then
      sed -i '2,$d' "$file"
    fi
  done
else
  echo "Папка $DIR не существует."
fi