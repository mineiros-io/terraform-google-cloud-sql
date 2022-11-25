header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-cloud-sql"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-cloud-sql/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-cloud-sql/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-cloud-sql.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-cloud-sql/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-cloud-sql"
  toc     = true
  content = <<-END
    A [Terraform] module for [Google Cloud Platform (GCP)][gcp].

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._**

    **NOTE: This module doesn't support SQL Server**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following terraform resources:

      - `google_sql_database_instance`
      - `google_sql_database`
      - `google_sql_ssl_cert`
      - `google_sql_user`
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage just setting required arguments:

      ```hcl
      module "terraform-google-cloud-sql" {
        source = "github.com/mineiros-io/terraform-google-cloud-sql.git?ref=v0.1.0"

        tier             = "db-f1-micro"
        database_version = "MYSQL_5_6"
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_depends_on" {
        type           = list(dependency)
        description    = <<-END
          A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.
        END
        readme_example = <<-END
          module_depends_on = [
            google_network.network
          ]
        END
      }
    }

    section {
      title = "Main Resource Configuration"

      variable "database_version" {
        required    = true
        type        = string
        description = <<-END
          The MySQL or PostgreSQL version to use.
        END
      }

      variable "tier" {
        required    = true
        type        = string
        description = <<-END
          The machine type to use.
        END
      }

      variable "name" {
        type        = string
        description = <<-END
          The name of the instance. If the name is left blank, Terraform will randomly generate one when the instance is first created. This is done because after a name is used, it cannot be reused for up to one week.
        END
      }

      variable "region" {
        type        = string
        description = <<-END
          The region the instance will sit in.  If a region is not provided in the resource definition, the provider region will be used instead.
        END
      }

      variable "master_instance_name" {
        type        = string
        description = <<-END
          The name of the existing instance that will act as the master in the replication setup. Note, this requires the master to have `binary_log_enabled` set, as well as existing backups.
        END
      }

      variable "project" {
        type        = string
        description = <<-END
          The ID of the project in which the resource belongs. If it is not provided, the provider project is used.
        END
      }

      variable "deletion_protection" {
        type        = bool
        default     = true
        description = <<-END
          Whether or not to allow Terraform to destroy the instance.
        END
      }

      variable "activation_policy" {
        type        = string
        description = <<-END
          This specifies when the instance should be active. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.
        END
      }

      variable "availability_type" {
        type        = string
        description = <<-END
          The availability type of the Cloud SQL instance, high availability `REGIONAL` or single zone `ZONAL`. For MySQL instances, ensure that `settings.backup_configuration.enabled` and `settings.backup_configuration.binary_log_enabled` are both set to `true`.
        END
      }

      variable "disk_autoresize" {
        type        = bool
        default     = true
        description = <<-END
          Configuration to increase storage size automatically.
        END
      }

      variable "disk_autoresize_limit" {
        type        = number
        default     = 0
        description = <<-END
         The maximum size in GB to which storage capacity can be automatically increased. The default value is 0, which specifies that there is no limit.
        END
      }

      variable "disk_size" {
        type        = number
        default     = 10
        description = <<-END
          The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased.
        END
      }

      variable "disk_type" {
        type        = string
        default     = "PD_SSD"
        description = <<-END
          The type of data disk: `PD_SSD` or `PD_HDD`.
        END
      }

      variable "pricing_plan" {
        type        = string
        description = <<-END
          Pricing plan for this instance, can only be `PER_USE`.
        END
      }

      variable "user_labels" {
        type        = map(string)
        description = <<-END
          A set of key/value user label pairs to assign to the instance.
        END
      }

      variable "database_flags" {
        type        = list(database_flag)
        description = <<-END
          A list of database flags.
        END

        attribute "name" {
          required    = true
          type        = string
          description = <<-END
            Name of the flag.
          END
        }

        attribute "value" {
          required       = true
          type           = string
          description    = <<-END
            Value of the flag.
          END
          readme_example = <<-END
            database_flags = [{
              name  = "long_query_time"
              value = "1"
            }]
          END
        }
      }

      variable "backup_configuration" {
        type           = object(backup_configuration)
        description    = <<-END
          An object of backup configuration.
        END
        readme_example = <<-END
          backup_configuration = {
            enabled    = true
            start_time = "17:00"
          }
        END

        attribute "binary_log_enabled" {
          type        = bool
          description = <<-END
            True if binary logging is enabled. If `settings.backup_configuration.enabled` is `false`, this must be as well. Cannot be used with Postgres.
          END
        }

        attribute "enabled" {
          type        = bool
          description = <<-END
            True if backup configuration is enabled.
          END
        }

        attribute "start_time" {
          type        = string
          description = <<-END
            `HH:MM` format time indicating when backup configuration starts.
          END
        }

        attribute "point_in_time_recovery_enabled" {
          type        = bool
          description = <<-END
            True if Point-in-time recovery is enabled. Will restart database if enabled after instance creation. Valid only for PostgreSQL instances.
          END
        }

        attribute "location" {
          type        = string
          description = <<-END
            The region where the backup will be stored.
          END
        }

        attribute "transaction_log_retention_days" {
          type        = number
          description = <<-END
            The number of days of transaction logs we retain for point in time restore, from 1-7.
          END
        }

        attribute "backup_retention_settings" {
          type           = list(backup_retention_setting)
          description    = <<-END
            A List of backup retention settings.
          END
          readme_example = <<-END
            backup_retention_settings = [{
              retained_backups = 3
              retention_unit   = "COUNT"
            }]
          END

          attribute "retained_backups" {
            type        = number
            description = <<-END
              Depending on the value of `retention_unit`, this is used to determine if a backup needs to be deleted. If `retention_unit` is `COUNT`, we will retain this many backups.
            END
          }

          attribute "retention_unit" {
            type        = string
            default     = "COUNT"
            description = <<-END
              The unit that `retained_backups` represents.
            END
          }
        }
      }

      variable "ip_configuration" {
        type           = object(ip_configuration)
        description    = <<-END
          An object of ip configuration.
        END
        readme_example = <<-END
          ip_configuration = {
            ipv4_enabled = true
          }
        END

        attribute "ipv4_enabled" {
          type        = bool
          description = <<-END
            Whether this Cloud SQL instance should be assigned a public IPV4 address. At least `ipv4_enabled` must be enabled or a `private_network` must be configured.
          END
        }

        attribute "private_network" {
          type        = string
          description = <<-END
            The VPC network from which the Cloud SQL instance is accessible for private IP. For example, `projects/myProject/global/networks/default`. Specifying a network enables private IP. At least `ipv4_enabled` must be enabled or a `private_network` must be configured. This setting can be updated, but it cannot be removed after it is set. This setting only works if the VPC network has a peering connection configured with `servicenetworking.googleapis.com`.
          END
        }

        attribute "require_ssl" {
          type        = bool
          description = <<-END
            Whether SSL connections over IP are enforced or not.
          END
        }

        attribute "allocated_ip_range " {
          type        = string
          description = <<-END
            The name of the allocated ip range for the private ip CloudSQL instance.
            For example: `google-managed-services-default`. If set, the instance
            ip will be created in the allocated range. The range name must
            comply with [RFC 1035](https://tools.ietf.org/html/rfc1035).
            Specifically, the name must be 1-63 characters long and match
            the regular expression `a-z?`.
          END
        }

        attribute "authorized_networks" {
          type           = list(authorized_network)
          description    = <<-END
            A List of public IPs/networks authorized to access the CloudSQL instance.
          END
          readme_example = <<-END
            authorized_networks = [{
              value = "35.35.35.35/32"
            }]
          END

          attribute "expiration_time" {
            type        = string
            description = <<-END
              The RFC 3339 formatted date time string indicating when this whitelist expires.
            END
          }

          attribute "name" {
            type        = string
            description = <<-END
              A name for this whitelist entry.
            END
          }

          attribute "value" {
            required    = true
            type        = string
            description = <<-END
              A CIDR notation **public** IPv4 or IPv6 address that is allowed to access this instance. Must be set even if other two attributes are not for the whitelist to become active.
            END
          }
        }
      }

      variable "location_preference" {
        type           = object(location_preference)
        description    = <<-END
          An object of location preferences.
        END
        readme_example = <<-END
          location_preference = {
            zone = "us-central1-a"
          }
        END

        attribute "follow_gae_application" {
          type        = string
          description = <<-END
            A GAE application whose zone to remain in. Must be in the same region as this instance.
          END
        }

        attribute "zone" {
          type        = string
          description = <<-END
            The preferred compute engine zone.
          END
        }
      }

      variable "maintenance_window" {
        type           = object(maintenance_window)
        description    = <<-END
          An object of maintenance window.
        END
        readme_example = <<-END
          maintenance_window = {
            day          = 1
            hour         = 0
            update_track = "stable"
          }
        END

        attribute "day" {
          type        = number
          description = <<-END
            Day of week (1-7), starting on Monday.
          END
        }

        attribute "hour" {
          type        = number
          description = <<-END
            Hour of day (0-23), ignored if day not set.
          END
        }

        attribute "update_track" {
          type        = string
          description = <<-END
            Receive updates earlier `canary` or later `stable`.
          END
        }
      }

      variable "insights_config" {
        type           = object(insights_config)
        description    = <<-END
          An object of insight config.
        END
        readme_example = <<-END
          insights_config = {
            query_insights_enabled = true
          }
        END

        attribute "query_insights_enabled" {
          type        = bool
          description = <<-END
            True if Query Insights feature is enabled.
          END
        }

        attribute "query_string_length" {
          type        = number
          default     = 1024
          description = <<-END
            Maximum query length stored in bytes. Between 256 and 4500. Default to 1024.
          END
        }

        attribute "record_application_tags" {
          type        = bool
          description = <<-END
            True if Query Insights will record application tags from query when enabled.
          END
        }

        attribute "record_client_address" {
          type        = bool
          description = <<-END
            True if Query Insights will record client address when enabled.
          END
        }
      }

      variable "replica_configuration" {
        type           = object(replica_configuration)
        description    = <<-END
          An object of replica configuration.
        END
        readme_example = <<-END
          replica_configuration = {
            failover_target = true
          }
        END

        attribute "ca_certificate" {
          type        = string
          description = <<-END
            PEM representation of the trusted CA's x509 certificate.
          END
        }

        attribute "client_certificate" {
          type        = string
          description = <<-END
            PEM representation of the replica's x509 certificate.
          END
        }

        attribute "client_key" {
          type        = string
          description = <<-END
            PEM representation of the replica's private key. The corresponding public key in encoded in the `client_certificate`.
          END
        }

        attribute "connect_retry_interval" {
          type        = number
          default     = 60
          description = <<-END
            The number of seconds between connect retries.
          END
        }

        attribute "dump_file_path" {
          type        = string
          description = <<-END
            Path to a SQL file in GCS from which replica instances are created. Format is `gs://bucket/filename`.
          END
        }

        attribute "failover_target" {
          type        = bool
          description = <<-END
            Specifies if the replica is the failover target. If the field is set to true the replica will be designated as a failover replica. If the master instance fails, the replica instance will be promoted as the new master instance.
          END
        }

        attribute "master_heartbeat_period" {
          type        = number
          description = <<-END
            Time in ms between replication heartbeats.
          END
        }

        attribute "password" {
          type        = string
          description = <<-END
            Password for the replication connection.
          END
        }

        attribute "ssl_cipher" {
          type        = string
          description = <<-END
            Permissible ciphers for use in SSL encryption.
          END
        }

        attribute "username" {
          type        = string
          description = <<-END
            Username for replication connection.
          END
        }

        attribute "verify_server_certificate" {
          type        = bool
          description = <<-END
            True if the master's common name value is checked during the SSL handshake.
          END
        }
      }

      variable "module_timeouts" {
        type           = map(module_timeout)
        description    = <<-END
          `resource_timeouts` are keyed by resource type and define default timeouts for various terraform operations (see [Operation Timeouts](https://www.terraform.io/docs/language/resources/syntax.html#operation-timeouts))
        END
        readme_example = <<-END
          module_timeouts = {
            google_sql_database_instance = {
              create = "30m"
              update = "30m"
              delete = "30m"
            }
          }
        END

        attribute "google_sql_database_instance" {
          type        = map(string)
          default     = "30m"
          description = <<-END
            - **`create`**: _(Optional)_

              Used for sql database instance creation.

              Default is `"30m"`.

            - **`update`**: _(Optional)_

              Used for sql database instance manipulation.

              Default is `"30m"`.

            - **`delete`**: _(Optional)_

              Used for sql database instance deletion.

              Default is `"30m"`.
          END
        }

        attribute "google_sql_database" {
          type        = map(string)
          default     = "15m"
          description = <<-END
            - **`create`**: _(Optional)_

              Used for sql database creation.

              Default is `"15m"`.

            - **`update`**: _(Optional)_

              Used for sql database manipulation.

              Default is `"10m"`.

            - **`delete`**: _(Optional)_

              Used for sql database deletion.

              Default is `"10m"`.
          END
        }

        attribute "google_sql_ssl_cert" {
          type        = map(string)
          default     = "10m"
          description = <<-END
            - **`create`**: _(Optional)_

              Used for sql user creation.

              Default is `"10m"`.

            - **`delete`**: _(Optional)_

              Used for sql user deletion.

              Default is `"10m"`.
          END
        }

        attribute "google_sql_user" {
          type        = map(string)
          default     = "10m"
          description = <<-END
            - **`create`**: _(Optional)_

              Used for sql user creation.

              Default is `"10m"`.

            - **`update`**: _(Optional)_

              Used for sql user manipulation.

              Default is `"10m"`.

            - **`delete`**: _(Optional)_

              Used for sql user deletion.

              Default is `"10m"`.
          END
        }
      }
    }

    section {
      title = "Extended Resource Configuration"

      variable "sql_databases" {
        type           = list(sql_database)
        description    = <<-END
          A list of SQL databases.
        END
        readme_example = <<-END
          sql_databases = [{
            name = "db"
          }]
        END

        attribute "name" {
          required    = true
          type        = string
          description = <<-END
            The Name of the database.
          END
        }

        attribute "charset" {
          type        = string
          description = <<-END
            The charset value. Postgres databases only support a value of `UTF8` at creation time.
          END
        }

        attribute "collation" {
          type        = string
          description = <<-END
            The collation value. Postgres databases only support a value of `en_US.UTF8` at creation time.
          END
        }
      }

      variable "sql_ssl_certs" {
        type           = list(sql_ssl_cert)
        description    = <<-END
          List of SQL SSL certs. You can create up to 10 client certificates for each instance.
        END
        readme_example = <<-END
          sql_ssl_certs = [{
            common_name = "ssl-name"
          }]
        END

        attribute "common_name" {
          required    = true
          type        = string
          description = <<-END
            The common name to be used in the certificate to identify the client. Constrained to [a-zA-Z.-_ ]+. Changing this forces a new resource to be created.
          END
        }
      }

      variable "sql_users" {
        type           = list(sql_user)
        description    = <<-END
          List of SQL users.
        END
        readme_example = <<-END
          sql_users = [{
            name     = "user"
            password = "changeme"
          }]
        END

        attribute "name" {
          required    = true
          type        = string
          description = <<-END
            The Name of the user.
          END
        }

        attribute "password" {
          type        = string
          description = <<-END
            The password for the user. Can be updated. For Postgres instances this is a Required field.
          END
        }

        attribute "type" {
          type        = string
          description = <<-END
            The user type. It determines the method to authenticate the user during login. The default is the database's built-in user type. Flags include `BUILT_IN`, `CLOUD_IAM_USER`, or `CLOUD_IAM_SERVICE_ACCOUNT`.
          END
        }

        attribute "deletion_policy" {
          type        = string
          description = <<-END
            The deletion policy for the user. Setting `ABANDON` allows the resource to be abandoned rather than deleted. This is useful for Postgres, where users cannot be deleted from the API if they have been granted SQL roles. Possible values are: `ABANDON`.
          END
        }

        attribute "host" {
          type        = string
          description = <<-END
            The host the user can connect from. This is only supported for MySQL instances. Don't set this field for PostgreSQL instances. Can be an IP address. Changing this forces a new resource to be created.
          END
        }
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "module_enabled" {
      type        = object(instance)
      description = <<-END
        Whether this module is enabled.
      END
    }

    output "instance" {
      type        = object(instance)
      description = <<-END
        SQL Database Instance.
      END
    }

    output "databases" {
      type        = map(database)
      description = <<-END
        All SQL Databases.
      END
    }

    output "certs" {
      type        = map(cert)
      description = <<-END
        All SQL Certs.
      END
    }

    output "users" {
      type        = map(user)
      description = <<-END
        All SQL Users.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - Available database version on GCP (SQL Server is not supported by this module): https://cloud.google.com/sql/docs/db-versions
        - Configuring SSL/TLS certificates: https://cloud.google.com/sql/docs/mysql/configure-ssl-instance
      END
    }

    section {
      title   = "Terraform Google Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_ssl_cert
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]
      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-cloud-sql"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-sql/workflows/Tests/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-cloud-sql.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-sql/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-sql/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "badge-tf-gcp" {
    value = "https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform"
  }
  ref "releases-google-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-google/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "gcp" {
    value = "https://cloud.google.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-sql/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-sql/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/CONTRIBUTING.md"
  }
}
