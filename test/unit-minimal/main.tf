module "test" {
  source = "../.."

  # add only required arguments and no optional arguments
  database_version = "MYSQL_5_6"
  tier             = "db-n1-standard-1"
  project          = local.project_id
}
