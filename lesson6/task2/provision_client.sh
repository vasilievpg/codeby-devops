#!/bin/bash

# Создаем ключи в общей папке
sudo -u vagrant ssh-keygen -t rsa -b 2048 -f /vagrant/id_rsa -N ""

# Устанавливаем правильные разрешения на файлы ключей
sudo chmod 600 /vagrant/id_rsa
sudo chmod 644 /vagrant/id_rsa.pub

# Устанавливаем правильные разрешения на файлы и папки .ssh
sudo mkdir -p /home/vagrant/.ssh
sudo cp /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
sudo cp /vagrant/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
sudo chmod 700 /home/vagrant/.ssh
sudo chmod 600 /home/vagrant/.ssh/id_rsa
sudo chmod 644 /home/vagrant/.ssh/id_rsa.pub

# Выводим содержимое папки .ssh и проверяем ключи
ls -l /home/vagrant/.ssh
cat /home/vagrant/.ssh/id_rsa.pub
