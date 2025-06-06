
#считываем данные об образе ОС
data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "bastion" {
  name        = "bastion" #Имя ВМ в облачной консоли
  hostname    = "bastion" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.bastion.id]
  }
}


resource "yandex_compute_instance" "web_a" {
  name        = "web-a" #Имя ВМ в облачной консоли
  hostname    = "web-a" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!


  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]
  }
}

resource "yandex_compute_instance" "web_b" {
  name        = "web-b" #Имя ВМ в облачной консоли
  hostname    = "web-b" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = var.test.cores
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_b.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]

  }
}


resource "local_file" "inventory" {
  content  = <<-XYZ
  [bastion]
  ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} ansible_user=user ansible_ssh_private_key_file=~/.ssh/woland2

  [webservers]
  ${yandex_compute_instance.web_a.network_interface.0.ip_address} ansible_host=${yandex_compute_instance.web_a.network_interface.0.ip_address}
  ${yandex_compute_instance.web_b.network_interface.0.ip_address} ansible_host=${yandex_compute_instance.web_b.network_interface.0.ip_address}

  [prometheus]
  ${yandex_compute_instance.prometheus.network_interface.0.ip_address} ansible_host=${yandex_compute_instance.prometheus.network_interface.0.ip_address}

  [grafana]
  ${yandex_compute_instance.grafana.network_interface.0.ip_address} ansible_host=${yandex_compute_instance.grafana.network_interface.0.ip_address}

  [elastic]
  ${yandex_compute_instance.elastic.network_interface.0.ip_address} ansible_host=${yandex_compute_instance.elastic.network_interface.0.ip_address}

  [kibana]
  ${yandex_compute_instance.kibana.network_interface.0.ip_address} ansible_host=${yandex_compute_instance.kibana.network_interface.0.ip_address}

  [webservers:vars]
  ansible_user=user
  ansible_ssh_private_key_file=~/.ssh/woland2
  ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} -i ~/.ssh/woland2"'

  [docker_hosts:children]
  prometheus
  grafana
  elastic
  kibana

  [docker_hosts:vars]
  ansible_user=user
  ansible_ssh_private_key_file=~/.ssh/woland2
  ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} -i ~/.ssh/woland2"'

  [monitoring:children]
  prometheus
  grafana

  [logging:children]
  elastic
  kibana
  XYZ
  filename = "./ansible/inventory.ini"
}



