#!/bin/bash

# Обновим пакеты и установим ssh-server
sudo apt-get update
sudo apt-get install -y openssh-server

# Запуск sshd службы
sudo systemctl enable ssh
sudo systemctl start ssh

# Создадим пользователя vagrant (если его нет) и установим пароль
id -u vagrant &>/dev/null || sudo useradd -m vagrant
echo "vagrant:vagrant" | sudo chpasswd

# Настроим SSH-доступ для пользователя vagrant
sudo mkdir -p /home/vagrant/.ssh
sudo cp /vagrant/id_rsa.pub /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
sudo chmod 700 /home/vagrant/.ssh
sudo chmod 600 /home/vagrant/.ssh/authorized_keys

# Выводим состояние sshd и проверяем ключи
sudo systemctl status ssh
ls -l /home/vagrant/.ssh
cat /home/vagrant/.ssh/authorized_keys
