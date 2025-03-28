resource "yandex_storage_object" "object1" {
  depends_on = [yandex_storage_bucket.pormar]
  bucket = "pormar.ru"
  key    = "bucket.jpg"
  source = "../bucket.jpg"
}

resource "yandex_storage_object" "object2" {
  depends_on = [yandex_storage_bucket.pormar]
  bucket = "pormar.ru"
  key    = "bucket.jpg"
  source = "../index.html"
}

resource "yandex_storage_bucket" "pormar" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "pormar.ru"
  acl    = "public-read"
  website {
    index_document = "index.html"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.porsev-key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
