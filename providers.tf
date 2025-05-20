terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.129.0"
    }
  }

  required_version = ">=1.8.4"
}

provider "yandex" {
  # token                    = "do not use!!!"
  token     = "y0__wgBEMKDlXgYwd0TIOaC6oMSTNHZDECRh1o3jBW1sV5ZS1it72w"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  #service_account_key_file = file("~/.authorized_key.json")
}
