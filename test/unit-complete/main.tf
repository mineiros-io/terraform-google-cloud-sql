module "test" {
  source = "../.."

  # add all required arguments
  database_version = "POSTGRES_13"
  tier             = "db-n1-standard-1"

  # add all optional arguments that create additional/extended resources
  name                        = "unit-complete-main-${local.random_suffix}"
  region                      = var.gcp_region
  master_instance_name        = "unit-complete-main-master-${local.random_suffix}"
  project                     = local.project_id
  deletion_protection         = true
  deletion_protection_enabled = true
  activation_policy           = "ALWAYS"
  availability_type           = "REGIONAL"
  disk_autoresize             = true
  disk_autoresize_limit       = 100
  disk_size                   = 10
  disk_type                   = "PD_SSD"
  pricing_plan                = "PER_USE"
  # encryption_key_name = "encryption_key_path"

  user_labels = {
    "key1" = "value1"
    "key2" = "value2"
  }

  database_flags = [{
    name  = "long_query_time"
    value = "1"
  }]

  data_cache_config = {
    data_cache_enabled = true
  }

  password_validation_policy = {
    min_length                  = 15
    complexity                  = "COMPLEXITY_DEFAULT"
    reuse_interval              = 10
    disallow_username_substring = true
    password_change_interval    = "10d"
    enable_password_policy      = true
  }

  backup_configuration = {
    binary_log_enabled     = true
    enabled                = true
    start_time             = "00:00"
    location               = "EU"
    binary_log_file_name   = "db-bin.000001"
    backup_window          = "00:00-00:30"
    point_in_time_recovery = true
    backup_retention_settings = [{
      retained_backups = 3
      retention_unit   = "COUNT"
    }]
  }

  ip_configuration = {
    ipv4_enabled = true
    authorized_networks = [{
      name            = "test"
      value           = "10.10.10.10/32"
      expiration_time = "2099-01-01_11:11:11.111Z"
    }]
    private_network    = "projects/${local.project_id}/global/networks/default"
    require_ssl        = true
    ssl_mode           = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
    allocated_ip_range = "google-managed-services-default"
  }

  location_preference = {
    follow_gae_application = "app-name"
    zone                   = "europe-west1-c"
  }

  maintenance_window = {
    day          = 1
    hour         = 0
    update_track = "stable"
  }

  deny_maintenance_period = {
    start_date = "2020-11-01",
    end_date   = "2020-11-01",
    time       = "00:00:00",
  }

  insights_config = {
    query_insights_enabled  = true
    query_string_length     = 256
    record_application_tags = true
    record_client_address   = true
  }

  replica_configuration = {
    failover_target           = true
    ca_certificate            = "ca-certificate"
    client_certificate        = "client-certificate"
    client_key                = "client-key"
    connect_retry_interval    = 30
    dump_file_path            = "dump-file-path"
    master_heartbeat_period   = 30
    password                  = "password"
    ssl_cipher                = "ssl-cipher"
    username                  = "username"
    verify_server_certificate = true
  }

  sql_databases = [{
    name      = "db"
    charset   = "UTF8"
    collation = "en_US.UTF8"
    project   = local.project_id
  }]

  sql_ssl_certs = [{
    common_name = "ssl-name"
    project     = local.project_id
  }]

  sql_users = [{
    name            = "user"
    password        = "changeme"
    type            = "BUILT_IN"
    deletion_policy = "ABANDON"
    //host =
    project = local.project_id
  }]

  # add most/all other optional arguments
}
