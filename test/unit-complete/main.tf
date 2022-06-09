module "test" {
  source = "../.."

  # add all required arguments
  database_version = "POSTGRES_13"
  tier             = "db-n1-standard-1"

  # add all optional arguments that create additional/extended resources
  name                 = "unit-complete-main-${local.random_suffix}"
  region               = var.gcp_region
  master_instance_name = "unit-complete-main-master-${local.random_suffix}"
  project              = local.project_id
  deletion_protection  = true
  activation_policy    = "ALWAYS"
  availability_type    = "REGIONAL"
  disk_autoresize      = true
  disk_size            = 10
  disk_type            = "PD_SSD"
  pricing_plan         = "PER_USE"

  # user_labels = {
  #   "key1" = "value1"
  #   "key2" = "value2"
  # }
  # database_flags = {
  #   "key1" = "value1"
  #   "key2" = "value2"
  # }

  # backup_configuration = {
  #   binary_log_enabled     = true
  #   enabled                = true
  #   start_time             = "00:00"
  #   location               = "EU"
  #   binary_log_file_name   = "mysql-bin.000001"
  #   backup_window          = "00:00-00:30"
  #   point_in_time_recovery = true
  # }

  # ip_configuration = {
  #   ipv4_enabled = true
  #   authorized_networks = [
  #   ""]
  # }
  # location_preference = {
  #   follow_gae_application = "app-name"
  #   zone                   = "europe-west1-c"
  # }

  # maintenance_window = {
  #   day          = "MONDAY"
  #   hour         = "12"
  #   update_track = "canary"
  # }

  # insights_config = {
  #   enabled = true
  # }

  # replica_configuration = {
  #   failover_target = true
  #   mysql_replica_configuration = {
  #     ca_certificate            = "ca-certificate"
  #     client_certificate        = "client-certificate"
  #     client_key                = "client-key"
  #     connect_retry_interval    = 30
  #     dump_file_path            = "dump-file-path"
  #     master_heartbeat_period   = 30
  #     password                  = "password"
  #     ssl_cipher                = "ssl-cipher"
  #     username                  = "username"
  #     verify_server_certificate = true
  #   }
  # }

  # sql_databases = [
  #   "database-name"
  # ]
  # sql_ssl_certs = [
  #   "cert-name"
  # ]
  # sql_users = [
  #   "user-name"
  # ]

  # add most/all other optional arguments
}
