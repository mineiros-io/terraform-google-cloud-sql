# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "database_version" {
  description = "(Required) The MySQL, PostgreSQL or SQL Server (beta) version to use."
  type        = string

  validation {
    condition     = contains(["MYSQL_5_6", "MYSQL_5_7", "MYSQL_8_0", "POSTGRES_9_6", "POSTGRES_10", "POSTGRES_11", "POSTGRES_12", "POSTGRES_13"], var.database_version)
    error_message = "The value must only be one of these valid values: MYSQL_5_6, MYSQL_5_7, MYSQL_8_0, POSTGRES_9_6, POSTGRES_10, POSTGRES_11, POSTGRES_12, POSTGRES_13."
  }
}

variable "tier" {
  description = "(Required) The machine type to use."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "(Optional, Computed) The name of the instance. If the name is left blank, Terraform will randomly generate one when the instance is first created. This is done because after a name is used, it cannot be reused for up to one week."
  type        = string
  default     = null
}

variable "region" {
  description = "(Optional) The region the instance will sit in.  If a region is not provided in the resource definition, the provider region will be used instead."
  type        = string
  default     = null
}

variable "master_instance_name" {
  description = "(Optional) The name of the existing instance that will act as the master in the replication setup. Note, this requires the master to have binary_log_enabled set, as well as existing backups."
  type        = string
  default     = null
}

variable "project" {
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "(Optional) Whether or not to allow Terraform to destroy the instance."
  type        = bool
  default     = true
}

variable "activation_policy" {
  description = "(Optional) This specifies when the instance should be active. Can be either ALWAYS, NEVER or ON_DEMAND."
  type        = string
  default     = null

  validation {
    condition     = var.activation_policy == null || (var.activation_policy == null ? true : contains(["ALWAYS", "NEVER", "ON_DEMAND"], var.activation_policy))
    error_message = "The value must only be one of these valid values: ALWAYS, NEVER, ON_DEMAND."
  }
}

variable "availability_type" {
  description = "(Optional) The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL).' For MySQL instances, ensure that settings.backup_configuration.enabled and settings.backup_configuration.binary_log_enabled are both set to true."
  type        = string
  default     = null

  validation {
    condition     = var.availability_type == null || (var.availability_type == null ? true : contains(["REGIONAL", "ZONAL"], var.availability_type))
    error_message = "The value must only be one of these valid values: REGIONAL, ZONAL."
  }
}

variable "disk_autoresize" {
  description = "(Optional) Configuration to increase storage size automatically."
  type        = bool
  default     = true
}

variable "disk_size" {
  description = "(Optional) The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "(Optional) The type of data disk: PD_SSD or PD_HDD."
  type        = string
  default     = "PD_SSD"

  validation {
    condition     = contains(["PD_SSD", "PD_HDD"], var.disk_type)
    error_message = "The value must only be one of these valid values: PD_SSD, PD_HDD."
  }
}

variable "pricing_plan" {
  description = "(Optional) Pricing plan for this instance, can only be PER_USE."
  type        = string
  default     = null

  validation {
    condition     = var.pricing_plan == null || var.pricing_plan == "PER_USE"
    error_message = "The value must only be PER_USE."
  }
}

variable "replication_type" {
  description = "(Optional) This property is only applicable to First Generation instances."
  type        = string
  default     = null

  validation {
    condition     = var.replication_type == null || (var.replication_type == null ? true : contains(["ASYNCHRONOUS", "SYNCHRONOUS"], var.replication_type))
    error_message = "The value must only be one of these valid values: ASYNCHRONOUS, SYNCHRONOUS."
  }
}

variable "user_labels" {
  description = "(Optional) A set of key/value user label pairs to assign to the instance."
  type        = map(string)
  default     = {}
}

variable "database_flags" {
  description = "(Optional) List of database flags."
  type        = any
  default     = []
}

variable "backup_configuration" {
  description = "(Optional) List of backup configurations."
  type        = any
  default     = {}
}

variable "ip_configuration" {
  description = "(Optional) List of ip configurations."
  type        = any
  default     = {}
}

variable "location_preference" {
  description = "(Optional) A Map of location preferences."
  type        = any
  default     = {}
}

variable "maintenance_window" {
  description = "(Optional) A Map of maintenance window."
  type        = any
  default     = {}
}

variable "insights_config" {
  description = "(Optional) A Map of insight config."
  type        = any
  default     = {}
}

variable "replica_configuration" {
  description = " (Optional) A Map of replica configuration."
  type        = any
  default     = {}
}

variable "module_timeouts" {
  description = "(Optional) How long certain operations (per resource type) are allowed to take before being considered to have failed."
  type        = any
  default     = {}
}

variable "sql_databases" {
  description = "(Optional) List of SQL Databases."
  type        = any
  default     = []
}

variable "sql_ssl_certs" {
  description = "(Optional) List of SQL SSL Certs. You can create up to 10 client certificates for each instance."
  type        = any
  default     = []

  validation {
    condition     = length(var.sql_ssl_certs) <= 10
    error_message = "You can only create up to 10 client certificates for each instance."
  }
}

variable "sql_users" {
  description = "(Optional) List of SQL users."
  type        = any
  default     = []

  validation {
    condition     = alltrue([for x in var.sql_users : can(x.name)])
    error_message = "All SQL users must have a defined name."
  }
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is 'true'."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."
  default     = []
}
