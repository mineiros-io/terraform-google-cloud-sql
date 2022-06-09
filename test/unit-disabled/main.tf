module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments
  database_version = "MYSQL_5_6"
  tier             = "db-n1-standard-1"

  # add all optional arguments that create additional/extended resources
}
