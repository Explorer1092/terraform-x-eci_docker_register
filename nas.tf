module "nas" {
    source  = "Explorer1092/nas/xalicloud"
    version = "1.4.0"
    create_file_system       = true
    # file_system_type         = "standard"
    # file_system_protocol_type            = "Performance"
    # file_system_storage_type             = "NFS"
    file_system_description  = "${var.name}-docker-registry"

    create_access_group      = true
    access_group_name        = "${var.name}-docker-registry"
    # access_group_type                     = "VPC"
    # access_group_description = var.access_group_description

    create_access_rule       = true
    source_cidr_ip           = "0.0.0.0/0"                  # 全网访问
    # rw_access_type           = "RDWR"
    # user_access_type         = "no_squash"
    # access_rule_priority                 = 1

    create_mount_target      = true
    vswitch_id               = var.vswitch_id
}
