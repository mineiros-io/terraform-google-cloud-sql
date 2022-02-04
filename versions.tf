terraform {
  required_version = "~> 1.0"

  required_providers {
    # v3.82: sql: fixed bug in google_sql_user with CLOUD_IAM_USERs on POSTGRES
    google = "~> 3.82"
  }
}
