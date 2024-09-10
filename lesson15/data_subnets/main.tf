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

data "yandex_vpc_subnet" "all" {
  for_each = toset(["b0c73ppt5pag98tobnoe", "e2lubj9pnfn3odbv9ps1", "e9b72uvnks76jsr92hcb", "fl8khuo0racajpk1tuvq"])

  subnet_id = each.value
}

output "subnet_ids_by_zone" {
  value = {
    for s in data.yandex_vpc_subnet.all : s.id => s.zone if s.zone == var.zone
  }
}
