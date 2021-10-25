locals {
  backup_configuration  = length(var.backup_configuration) > 0 ? [var.backup_configuration] : []
  ip_configuration      = length(var.ip_configuration) > 0 ? [var.ip_configuration] : []
  location_preference   = length(var.location_preference) > 0 ? [var.location_preference] : []
  maintenance_window    = length(var.maintenance_window) > 0 ? [var.maintenance_window] : []
  insights_config       = length(var.insights_config) > 0 ? [var.insights_config] : []
  replica_configuration = var.master_instance_name != null && length(var.replica_configuration) > 0 ? [var.replica_configuration] : []
}

resource "google_sql_database_instance" "instance" {
  count = var.module_enabled ? 1 : 0

  depends_on = [var.module_depends_on]

  name                 = var.name
  database_version     = var.database_version
  region               = var.region
  master_instance_name = var.master_instance_name
  project              = var.project
  deletion_protection  = var.deletion_protection

  settings {
    tier              = var.tier
    activation_policy = var.activation_policy
    availability_type = var.availability_type

    # disable disk_autoresize if the user requested a specific disk_size
    disk_autoresize  = var.disk_size != null ? false : var.disk_autoresize
    disk_size        = var.disk_size
    disk_type        = var.disk_type
    pricing_plan     = var.pricing_plan
    replication_type = var.replication_type
    user_labels      = var.user_labels

    dynamic "database_flags" {
      for_each = var.database_flags

      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }

    dynamic "backup_configuration" {
      for_each = local.backup_configuration

      content {
        binary_log_enabled             = try(backup_configuration.value.binary_log_enabled, null)
        enabled                        = try(backup_configuration.value.enabled, null)
        start_time                     = try(backup_configuration.value.start_time, null)
        point_in_time_recovery_enabled = try(backup_configuration.value.point_in_time_recovery_enabled, null)
        location                       = try(backup_configuration.value.location, null)
        transaction_log_retention_days = try(backup_configuration.value.transaction_log_retention_days, null)

        dynamic "backup_retention_settings" {
          for_each = try(backup_configuration.value.backup_retention_settings, [])

          content {
            retained_backups = try(backup_retention_settings.value.retained_backups, null)
            retention_unit   = try(backup_retention_settings.value.retention_unit, "COUNT")
          }
        }
      }
    }

    dynamic "ip_configuration" {
      for_each = local.ip_configuration

      content {
        ipv4_enabled    = try(ip_configuration.value.ipv4_enabled, null)
        private_network = try(ip_configuration.value.private_network, null)
        require_ssl     = try(ip_configuration.value.require_ssl, null)

        dynamic "authorized_networks" {
          for_each = try(ip_configuration.value.authorized_networks, [])

          content {
            expiration_time = try(authorized_networks.value.expiration_time, null)
            name            = try(authorized_networks.value.name, null)
            value           = try(authorized_networks.value.value, null)
          }
        }
      }
    }

    dynamic "location_preference" {
      for_each = local.location_preference

      content {
        zone = try(location_preference.value.zone, null)
      }
    }

    dynamic "maintenance_window" {
      for_each = local.maintenance_window

      content {
        day          = try(maintenance_window.value.day, null)
        hour         = try(maintenance_window.value.hour, null)
        update_track = try(maintenance_window.value.update_track, null)
      }
    }

    dynamic "insights_config" {
      for_each = local.insights_config

      content {
        query_insights_enabled  = try(insights_config.value.query_insights_enabled, null)
        query_string_length     = try(insights_config.value.query_string_length, null)
        record_application_tags = try(insights_config.value.record_application_tags, null)
        record_client_address   = try(insights_config.value.record_client_address, null)
      }
    }
  }

  dynamic "replica_configuration" {
    for_each = local.replica_configuration

    content {
      ca_certificate            = try(replica_configuration.value.ca_certificate, null)
      client_certificate        = try(replica_configuration.value.client_certificate, null)
      client_key                = try(replica_configuration.value.client_key, null)
      connect_retry_interval    = try(replica_configuration.value.connect_retry_interval, null)
      dump_file_path            = try(replica_configuration.value.dump_file_path, null)
      failover_target           = try(replica_configuration.value.failover_target, null)
      master_heartbeat_period   = try(replica_configuration.value.master_heartbeat_period, null)
      password                  = try(replica_configuration.value.password, null)
      ssl_cipher                = try(replica_configuration.value.ssl_cipher, null)
      username                  = try(replica_configuration.value.username, null)
      verify_server_certificate = try(replica_configuration.value.verify_server_certificate, null)
    }
  }

  timeouts {
    create = try(var.module_timeouts.google_sql_database_instance.create, "30m")
    update = try(var.module_timeouts.google_sql_database_instance.update, "30m")
    delete = try(var.module_timeouts.google_sql_database_instance.delete, "30m")
  }
}

locals {
  sql_databases = { for b in var.sql_databases : try(b.id, b.name) => b }
}

resource "google_sql_database" "database" {
  for_each = var.module_enabled ? local.sql_databases : {}

  project = var.project

  instance  = google_sql_database_instance.instance[0].name
  name      = each.value.name
  charset   = try(each.value.charset, null)
  collation = try(each.value.collation, null)

  timeouts {
    create = try(var.module_timeouts.google_sql_database.create, "15m")
    update = try(var.module_timeouts.google_sql_database.update, "10m")
    delete = try(var.module_timeouts.google_sql_database.delete, "10m")
  }
}

locals {
  sql_ssl_certs = { for b in var.sql_ssl_certs : try(b.id, b.common_name) => b }
}

resource "google_sql_ssl_cert" "client_cert" {
  for_each = var.module_enabled ? local.sql_ssl_certs : {}

  project = var.project

  instance    = google_sql_database_instance.instance[0].name
  common_name = each.value.common_name

  timeouts {
    create = try(var.module_timeouts.google_sql_ssl_cert.create, "10m")
    delete = try(var.module_timeouts.google_sql_ssl_cert.delete, "10m")
  }
}

locals {
  sql_users = { for b in var.sql_users : b.name => b }
}

resource "google_sql_user" "users" {
  for_each = var.module_enabled ? local.sql_users : {}

  project = var.project

  instance        = google_sql_database_instance.instance[0].name
  name            = each.value.name
  password        = try(each.value.password, null)
  type            = try(each.value.type, null)
  deletion_policy = try(each.value.deletion_policy, null)
  host            = try(each.value.host, null)

  timeouts {
    create = try(var.module_timeouts.google_sql_user.create, "10m")
    update = try(var.module_timeouts.google_sql_user.update, "10m")
    delete = try(var.module_timeouts.google_sql_user.delete, "10m")
  }
}
