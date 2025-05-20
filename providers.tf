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

resource "yandex_compute_snapshot_schedule" "daily_backups" {
  name           = "daily-snapshots"
  schedule_policy {
    expression = "0 1 * * *" # Ежедневно в 1:00
  }

  snapshot_count = 7 # Хранить 7 последних снапшотов
  
  snapshot_spec {
    description = "daily-snapshot"
  }

  disk_ids = [
    yandex_compute_instance.bastion.boot_disk.0.disk_id,
    yandex_compute_instance.web_a.boot_disk.0.disk_id,
    yandex_compute_instance.web_b.boot_disk.0.disk_id,
    yandex_compute_instance.prometheus.boot_disk.0.disk_id,
    yandex_compute_instance.grafana.boot_disk.0.disk_id,
    yandex_compute_instance.elastic.boot_disk.0.disk_id,
    yandex_compute_instance.kibana.boot_disk.0.disk_id
  ]
}