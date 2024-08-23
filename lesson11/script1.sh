#!/bin/bash

# Константы
DIR="$HOME/myfolder"
FILE1="$DIR/file1.txt"
FILE2="$DIR/file2.txt"
FILE3="$DIR/file3.txt"
FILE4="$DIR/file4.txt"
FILE5="$DIR/file5.txt"

# Функция создания папки, если она не существует
create_directory() {
    mkdir -p "$DIR"
    return 0
}

# Функция создания первого файла с приветствием и текущей датой/временем
create_file1() {
    echo "Привет!" > "$FILE1"
    date >> "$FILE1"
    return 0
}

# Функция создания пустого файла с правами 777
create_file2() {
    touch "$FILE2"
    chmod 777 "$FILE2"
    return 0
}

# Функция создания файла со случайной строкой длиной 20 символов
create_file3() {
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 > "$FILE3"
    return 0
}

# Функция создания пустых файлов
create_empty_files() {
    touch "$FILE4"
    touch "$FILE5"
    return 0
}

# Основная часть скрипта
create_directory
create_file1
create_file2
create_file3
create_empty_files