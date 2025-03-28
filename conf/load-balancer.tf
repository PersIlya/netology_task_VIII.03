resource "yandex_lb_network_load_balancer" "load-balancer" {

  attached_target_group {
    target_group_id = yandex_compute_instance_group.group1.load_balancer.0.target_group_id

    healthcheck {
      name                = "nginx"
      interval            = 10
      timeout             = 5
      unhealthy_threshold = 3
      tcp_options {
        port = 80
      }
    }
  }

  listener {
    name = "http"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
}


resource "yandex_compute_instance_group" "group1" {
  name                = "lamp"
  folder_id           = var.YaCloud.folder_id
  service_account_id  = yandex_iam_service_account.sa-test.id
  deletion_protection = false
  instance_template {
    platform_id = local.vm_common.platform
    resources {
      core_fraction = local.vm_common.fract
      memory        = local.vm_common.ram
      cores         = local.vm_common.cpu
    }
    boot_disk {
      initialize_params {
        image_id = local.vm_common.image_id
        size     = local.vm_common.disk_size
      }
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      network_id = yandex_vpc_network.network.id
      subnet_ids = ["${yandex_vpc_subnet.subnet.id}"]
      nat        = true
    }
    metadata = {
      serial-port-enable = 1
      ssh-keys = "${local.ssh_opt.user_name}:${local.ssh_opt.pubkey}" 
      user-data          = "#!/bin/bash\n echo \"<html><body><h1>Porsev Web</h1><img src='https://${yandex_storage_bucket.porsev-24-03-2025.bucket_domain_name}/${yandex_storage_object.object.key}'></body></html>\" > /var/www/html/index.html"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.YaCloud.default_zone]
  }

  deploy_policy {
    max_unavailable = 3
    max_creating    = 3
    max_expansion   = 3
    max_deleting    = 3
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Load Balancer group"
  }
}

