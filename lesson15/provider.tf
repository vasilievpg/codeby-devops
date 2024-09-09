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
  token = ""

  # Идентификатор облака
  cloud_id = "b1g7mar4k2bn8e1jds6d"

  # Идентификатор каталога (папки), в котором будут создаваться ресурсы
  folder_id = "b1gh02vl4lcsdc52krnt"
}
