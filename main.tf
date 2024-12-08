terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.70"
    }
  }
}

provider "yandex" {
  token     = "t1.9euelZqVyMyQzZiLyo6Uz5HPjZ3Pye3rnpWax8qcm46aipGJnY7Nk8rGkZ3l8_cRRx1J-e9AK3pX_t3z91F1Gkn570Arelf-zef1656VmomZi5iKi87MisaNnpnIm5XJ7_zF656VmomZi5iKi87MisaNnpnIm5XJ.E8AyqRju5pYv_TbwtG5cOdVbotaQ-FgebuTOANdcpiasySANfAav1MsruJ7pMBFIANfigUEB9m0KfguUy1YPAQ"
  cloud_id  = "b1g8u94qmpdgthju20p5"
  folder_id = "b1gr0pd67fh99ur189va"
  zone      = "ru-central1-a"
}

# Далее идет конфиг ресурсов Target Group и Load Balancer.

resource "yandex_lb_target_group" "web_target_group" {
  name = "web-target-group"

  target {
    subnet_id = "e9belmu9jv1m293m92k6"  # для ru-central1-a
    address   = "10.128.0.18"
  }

  target {
    subnet_id = "e2lvktp54ubc73h73a8b"  # для ru-central1-b
    address   = "10.129.0.28"
  }
}


resource "yandex_lb_network_load_balancer" "my_lb" {
  name = "my-load-balancer"

  listener {
    name = "http"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.web_target_group.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}




#_________________________________________________________________________________________________

