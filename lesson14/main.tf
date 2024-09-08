# Определяем версию Terraform и необходимые провайдеры
terraform {
  required_providers {
    # Используем провайдер Yandex Cloud для управления ресурсами в облаке Yandex
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  # Указываем минимально необходимую версию Terraform
  required_version = ">= 0.13"
}

# Настраиваем провайдер Yandex Cloud с необходимыми параметрами аутентификации
provider "yandex" {
  # Токен доступа для аутентификации в Yandex Cloud
  token = "..."

  # Идентификатор облака
  cloud_id = "..."

  # Идентификатор каталога (папки), в котором будут создаваться ресурсы
  folder_id = "b1gh02vl4lcsdc52krnt"

  # Зона размещения ресурсов (например, дата-центр)
  zone = "ru-central1-a"
}

# Создаем виртуальную сеть (VPC)
resource "yandex_vpc_network" "default" {
  # Имя виртуальной сети
  name = "my-network"
}

# Создаем подсеть в VPC для публичных ресурсов
resource "yandex_vpc_subnet" "public" {
  # Имя подсети
  name = "public-subnet"

  # Зона размещения подсети
  zone = "ru-central1-a"

  # Идентификатор виртуальной сети, к которой относится подсеть
  network_id = yandex_vpc_network.default.id

  # Диапазон IP-адресов для подсети
  v4_cidr_blocks = ["10.0.1.0/24"]
}

# Создаем подсеть в VPC для приватных ресурсов
resource "yandex_vpc_subnet" "private" {
  # Имя подсети
  name = "private-subnet"

  # Зона размещения подсети
  zone = "ru-central1-a"

  # Идентификатор виртуальной сети, к которой относится подсеть
  network_id = yandex_vpc_network.default.id

  # Диапазон IP-адресов для подсети
  v4_cidr_blocks = ["10.0.2.0/24"]
}

# Создаем виртуальную машину в публичной подсети
resource "yandex_compute_instance" "public_vm" {
  # Имя виртуальной машины
  name = "public-vm"

  # Тип платформы (характеристики процессора)
  platform_id = "standard-v1"

  # Зона размещения виртуальной машины
  zone = "ru-central1-a"

  # Ресурсы виртуальной машины: количество ядер и объем памяти
  resources {
    cores  = 2 # Количество ядер процессора
    memory = 2 # Объем памяти в ГБ (2 ГБ)
  }

  # Параметры загрузочного диска, включая идентификатор образа ОС
  boot_disk {
    initialize_params {
      # Используем образ Ubuntu 20.04 LTS
      image_id = "fd86t95gnivk955ulbq8"
    }
  }

  # Сетевой интерфейс виртуальной машины
  network_interface {
    # Подключение к публичной подсети
    subnet_id = yandex_vpc_subnet.public.id
    # Включаем NAT для доступа в интернет
    nat = true
  }

  # Добавляем публичный SSH-ключ для доступа к виртуальной машине
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  # Используем provisioner для выполнения команд на удаленной машине
  provisioner "remote-exec" {
    inline = [
      # Обновляем источник пакетов, чтобы использовать основной архив Ubuntu
      "sudo sed -i 's|http://mirror.yandex.ru/ubuntu/|http://archive.ubuntu.com/ubuntu/|' /etc/apt/sources.list",
      # Обновляем список пакетов и исправляем недостающие зависимости
      "sudo apt-get update --fix-missing",
      # Устанавливаем Nginx - веб-сервер
      "sudo apt-get install -y nginx",
    ]

    # Параметры подключения к виртуальной машине через SSH
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      # Используем публичный IP-адрес машины для подключения
      host = self.network_interface.0.nat_ip_address
    }
  }
}

# Создаем виртуальную машину в приватной подсети
resource "yandex_compute_instance" "private_vm" {
  # Имя виртуальной машины
  name = "private-vm"

  # Тип платформы (характеристики процессора)
  platform_id = "standard-v1"

  # Зона размещения виртуальной машины
  zone = "ru-central1-a"

  # Ресурсы виртуальной машины: количество ядер и объем памяти
  resources {
    cores  = 2 # Количество ядер процессора
    memory = 2 # Объем памяти в ГБ (2 ГБ)
  }

  # Параметры загрузочного диска, включая идентификатор образа ОС
  boot_disk {
    initialize_params {
      # Используем образ Ubuntu 20.04 LTS
      image_id = "fd86t95gnivk955ulbq8"
    }
  }

  # Сетевой интерфейс виртуальной машины
  network_interface {
    # Подключение к приватной подсети
    subnet_id = yandex_vpc_subnet.private.id
  }

  # Добавляем публичный SSH-ключ для доступа к виртуальной машине
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  # Используем provisioner для выполнения команд на удаленной машине
  provisioner "remote-exec" {
    inline = [
      # Выполняем простую команду на приватной машине
      "echo 'Hello, private VM!'"
    ]

    # Параметры подключения к виртуальной машине через SSH
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      # Подключаемся через bastion-хост (публичная VM), т.к. машина в приватной подсети
      host                = self.network_interface.0.ip_address
      bastion_host        = yandex_compute_instance.public_vm.network_interface.0.nat_ip_address
      bastion_user        = "ubuntu"
      bastion_private_key = file("~/.ssh/id_rsa")
    }
  }
}

# Создаем импортированную виртуальную машину (уже существующую)
resource "yandex_compute_instance" "imported_vm" {
  # Имя виртуальной машины
  name = "imported-vm"
  # Разрешаем остановку машины для обновления ресурсов
  allow_stopping_for_update = true
  # Идентификатор каталога (папки), в котором находится ресурс
  folder_id = "b1gh02vl4lcsdc52krnt"
  # Тип платформы (характеристики процессора)
  platform_id = "standard-v3"

  # Ресурсы виртуальной машины: количество ядер и объем памяти
  resources {
    cores         = 2   # Количество ядер процессора
    memory        = 2   # Объем памяти в ГБ (2 ГБ)
    core_fraction = 100 # Доля ядра в процентах
  }

  # Параметры загрузочного диска
  boot_disk {
    mode        = "READ_WRITE" # Режим диска
    device_name = "fhmjjncidr3qcd4earss"
    auto_delete = true                   # Автоматическое удаление диска при удалении машины
    disk_id     = "fhmjjncidr3qcd4earss" # Идентификатор диска
  }

  # Сетевой интерфейс виртуальной машины
  network_interface {
    index     = 0
    subnet_id = "e9b72uvnks76jsr92hcb"
    nat       = true # Включаем NAT для доступа в интернет
    # Удалите mac_address, если он больше не требуется
  }

  # Идентификатор сервисного аккаунта, используемого для доступа
  service_account_id = "..."
}
