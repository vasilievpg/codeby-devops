module "data_subnets" {
  source = "./data_subnets"
  zone = var.zone  # Передача переменной zone в модуль data_subnets
}

module "create_vm" {
  source = "./create_vm"
  zone   = var.zone
}
