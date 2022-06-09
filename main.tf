

resource "random_password" "default" {
  length = 16
}

data "alicloud_vswitches" "default" {
  ids = [var.vswitch_id]
}


resource "alicloud_security_group" "default" {
  vpc_id = data.alicloud_vswitches.default.vswitches.0.vpc_id
}


resource "alicloud_security_group_rule" "allow_all_tcp" {
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.default.id
  cidr_ip           = "0.0.0.0/0"
}

/*
* 创建容器服务
*/

resource "alicloud_eci_container_group" "docker-register" {
  container_group_name   = var.name
  cpu                    = 0.5
  memory                 = 1
  restart_policy         = "Always"
  security_group_id      = alicloud_security_group.default.id
  vswitch_id             = var.vswitch_id
  auto_match_image_cache = true
  auto_create_eip        = true
  eip_bandwidth          = 100
  containers {
    image             = "htid/registry:latest"
    name              = "registry-${var.name}"
    image_pull_policy = "IfNotPresent"
    # ports {
    #   port     = 5000
    #   protocol = "TCP"
    # }
    ports {
      port     = 80
      protocol = "TCP"
    }
    volume_mounts {
      mount_path = "/etc/docker/registry/"
      name       = "config"
    }
  }

  volumes {
    name = "data"
    type = "EmptyDirVolume"
  }
  volumes {
    name = "config"
    type = "ConfigFileVolume"
    config_file_volume_config_file_to_paths {
      content = base64encode(local.caddy_config)
      path    = "Caddyfile"
    }
    config_file_volume_config_file_to_paths {
      content = base64encode(local.registry_config)
      path    = "config.yml"
    }
    config_file_volume_config_file_to_paths {
      content = base64encode(local.htpasswd_config)
      path    = "htpasswd"
    }
  }
}