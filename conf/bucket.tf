resource "yandex_storage_bucket" "porsev-24-03-2025" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "porsev-24-03-2025"
  acl    = "public-read"
  website {
    index_document = "bucket.jpg"
  }
  # anonymous_access_flags {
  #   read        = true
  #   list        = true
  #   config_read = true
  # }
}

resource "yandex_storage_object" "object" {
  depends_on = [yandex_storage_bucket.porsev-24-03-2025]
  bucket = "porsev-24-03-2025"
  key    = "bucket.jpg"
  source = "../bucket.jpg"
  # tags = {
  #   test = "value"
  # }
}

