resource "yandex_vpc_network" "network" {
  name = "Network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "my-subnet" 
  zone           = var.YaCloud.default_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.YaCloud.default_cidr
}

resource "yandex_iam_service_account" "sa-test" {
  folder_id = var.YaCloud.folder_id
  name      = "sa-test"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-perm" {
  folder_id = var.YaCloud.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-test.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-test.id
  description        = "static access key for object storage"
}
