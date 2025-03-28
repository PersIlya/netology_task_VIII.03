resource "yandex_kms_symmetric_key" "porsev-key" {
  name                = "porsev.key"
  description         = "The test key."
  default_algorithm   = "AES_128"
  rotation_period     = "8760h"
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
