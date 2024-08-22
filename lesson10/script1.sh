#!/bin/bash

# Переменная для пути к папке myfolder в домашней директории
DIR="$HOME/myfolder"

# Создание папки, если она не существует
mkdir -p "$DIR"

# Создание первого файла с приветствием и текущей датой/временем
echo "Привет!" > "$DIR/file1.txt"
date >> "$DIR/file1.txt"

# Создание второго пустого файла с правами 777
touch "$DIR/file2.txt"
chmod 777 "$DIR/file2.txt"

# Создание третьего файла со случайной строкой длиной 20 символов
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 > "$DIR/file3.txt"

# Создание четвертого и пятого пустых файлов
touch "$DIR/file4.txt"
touch "$DIR/file5.txt"