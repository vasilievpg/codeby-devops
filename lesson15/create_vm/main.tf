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

provider "yandex" {
  # Токен доступа для аутентификации в Yandex Cloud
  token = ""

  # Идентификатор облака
  cloud_id = "b1g7mar4k2bn8e1jds6d"

  # Идентификатор каталога (папки), в котором будут создаваться ресурсы
  folder_id = "b1gh02vl4lcsdc52krnt"
}

module "data_subnets" {
  source = "../data_subnets"
  zone   = var.zone
}

locals {
  subnet_id = keys(module.data_subnets.subnet_ids_by_zone)[0]  # Берем первый subnet ID в нужной зоне
}

resource "yandex_compute_instance" "vm" {
  name = "my-vm"
  zone = var.zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      # Используем образ Ubuntu 20.04 LTS
      image_id = "fd86t95gnivk955ulbq8"
    }
  }
  network_interface {
    subnet_id = local.subnet_id
    nat       = true
  }
}
