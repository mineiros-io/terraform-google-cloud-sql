terraform {
  required_version = ">= 0.14.7, < 2.0"

  required_providers {
    # v3.82: sql: fixed bug in google_sql_user with CLOUD_IAM_USERs on POSTGRES
    google = {
      source  = "hashicorp/google"
      version = ">= 3.82, < 5.0"
    }
  }
}
