#!/bin/bash

# Константы
DIR="$HOME/myfolder"
FILE2="$DIR/file2.txt"

# Функция подсчета количества файлов в папке
count_files() {
    local count=$(ls -1 "$DIR" | wc -l)
    echo "Количество файлов в папке $DIR: $count"
    return 0
}

# Функция изменения прав второго файла на 664
change_permissions() {
    if [ -f "$FILE2" ]; then
        chmod 664 "$FILE2"
    fi
    return 0
}

# Функция удаления пустых файлов
delete_empty_files() {
    find "$DIR" -type f -empty -delete
    return 0
}

# Функция удаления всех строк, кроме первой
truncate_files() {
    for file in "$DIR"/*; do
        if [ -f "$file" ]; then
            sed -i '2,$d' "$file"
        fi
    done
    return 0
}

# Основная часть скрипта
if [ -d "$DIR" ]; then
    count_files
    change_permissions
    delete_empty_files
    truncate_files
else
    echo "Папка $DIR не существует."
    exit 1
fi