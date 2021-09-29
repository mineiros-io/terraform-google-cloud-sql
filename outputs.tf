# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "instance" {
  description = "SQL Database Instance"
  value       = try(google_sql_database_instance.instance[0], null)
}

output "databases" {
  description = "All SQL Databases"
  value       = try(google_sql_database.database, null)
}

output "certs" {
  description = "All SQL Certs"
  value       = try(google_sql_ssl_cert.client_cert, null)
}

output "users" {
  description = "All SQL Users"
  value       = try(google_sql_user.users, null)
}

# ------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}
