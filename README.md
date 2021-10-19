[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Terraform Version][badge-terraform]][releases-terraform]
[![Google Provider Version][badge-tf-gcp]][releases-google-provider]
[![Join Slack][badge-slack]][slack]

# terraform-google-cloud-sql

A [Terraform] module for [Google Cloud Platform (GCP)][gcp].

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 3._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource Configuration](#extended-resource-configuration)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following terraform resources:

- `google_sql_database_instance`
- `google_sql_database`
- `google_sql_ssl_cert`
- `google_sql_user`

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-google-cloud-sql" {
    source = "github.com/mineiros-io/terraform-google-cloud-sql.git?ref=v0.1.0"

    tier             = "db-f1-micro"
    database_version = "MYSQL_5_6"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: _(Optional `bool`)_

  Specifies whether resources in the module will be created.

  Default is `true`.

- **`module_depends_on`**: _(Optional `list(dependencies)`)_

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:
  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

#### Main Resource Configuration

- **`database_version`**: **_(Required `string`)_**

  The MySQL, PostgreSQL or SQL Server (beta) version to use.

- **`tier`**: **_(Required `string`)_**

  The machine type to use.

- **`name`**: _(Optional `number`)_

  The name of the instance. If the name is left blank, Terraform will randomly generate one when the instance is first created. This is done because after a name is used, it cannot be reused for up to one week.

- **`region`**: _(Optional `string`)_

  The region the instance will sit in.  If a region is not provided in the resource definition, the provider region will be used instead.

- **`master_instance_name`**: _(Optional `string`)_

  The name of the existing instance that will act as the master in the replication setup. Note, this requires the master to have `binary_log_enabled` set, as well as existing backups.

- **`project`**: _(Optional `string`)_

  The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- **`deletion_protection`**: _(Optional `bool`)_

  Whether or not to allow Terraform to destroy the instance.

  Default is `true`.

- **`activation_policy`**: _(Optional `string`)_

  This specifies when the instance should be active. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.

- **`availability_type`**: _(Optional `string`)_

  The availability type of the Cloud SQL instance, high availability `REGIONAL` or single zone `ZONAL`. For MySQL instances, ensure that `settings.backup_configuration.enabled` and `settings.backup_configuration.binary_log_enabled` are both set to `true`.

- **`disk_autoresize`**: _(Optional `bool`)_

  Configuration to increase storage size automatically.

  Default is `true`.

- **`disk_size`**: _(Optional `number`)_

  The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased.

  Default is `10`.

- **`disk_type`**: _(Optional `string`)_

  The type of data disk: `PD_SSD` or `PD_HDD`.

  Default is `PD_SSD`.

- **`pricing_plan`**: _(Optional `string`)_

  Pricing plan for this instance, can only be `PER_USE`.

- **`replication_type`**: _(Optional `string`)_

  This property is only applicable to First Generation instances. Replication type for this instance, can be one of `ASYNCHRONOUS` or `SYNCHRONOUS`.

- **`user_labels`**: _(Optional `map(string)`)_

  A set of key/value user label pairs to assign to the instance.

- **`database_flags`**: _(Optional `list(database_flags)`)_

  List of database flags.
  Each `database_flags` object accepts the following fields:

  - **`name`**: **_(Required `string`)_**

    Name of the flag.

  - **`value`**: **_(Required `string`)_**

    Value of the flag.

  Example
  ```hcl
  database_flags = [{
    name  = "long_query_time"
    value = "1"
  }]
  ```

- **`backup_configuration`**: _(Optional `object(backup_configuration)`)_

  An object of backup configuration.

  Example

  ```hcl
  backup_configuration = {
    enabled    = true
    start_time = "17:00"
  }
  ```
  
  A `backup_configuration` object accepts the following fields:

  - **`binary_log_enabled`**: _(Optional `bool`)_

    True if binary logging is enabled. If `settings.backup_configuration.enabled` is `false`, this must be as well. Cannot be used with Postgres.

  - **`enabled`**: _(Optional `bool`)_

    True if backup configuration is enabled.
  
  - **`start_time`**: _(Optional `string`)_

    `HH:MM` format time indicating when backup configuration starts.

  - **`point_in_time_recovery_enabled`**: _(Optional `bool`)_

    True if Point-in-time recovery is enabled. Will restart database if enabled after instance creation. Valid only for PostgreSQL instances.

  - **`location`**: _(Optional `string`)_

    The region where the backup will be stored.

  - **`transaction_log_retention_days`**: _(Optional `number`)_

    The number of days of transaction logs we retain for point in time restore, from 1-7.

  - **`backup_retention_settings`**: _(Optional `list(backup_retention_settings)`)_

    A List of backup retention settings.

    Example

    ```hcl
    backup_retention_settings = [{
      retained_backups = 3
      retention_unit   = "COUNT"
    }]
    ```

    Each `backup_retention_settings` object accepts the following fields:

    - **`retained_backups`**: _(Optional `number`)_

      Depending on the value of `retention_unit`, this is used to determine if a backup needs to be deleted. If `retention_unit` is `COUNT`, we will retain this many backups.

    - **`retention_unit`**: _(Optional `string`)_

      The unit that `retained_backups` represents. 

      Defaults to `COUNT`.

- **`ip_configuration`**: _(Optional `object(ip_configuration)`)_

  An object of ip configuration.

  Example

  ```hcl
  ip_configuration = {
    ipv4_enabled = true
  }
  ```

  A `ip_configuration` object accepts the following fields:

  - **`ipv4_enabled`**: _(Optional `bool`)_

    Whether this Cloud SQL instance should be assigned a public IPV4 address. At least `ipv4_enabled` must be enabled or a `private_network` must be configured.

  - **`private_network`**: _(Optional `string`)_

    The VPC network from which the Cloud SQL instance is accessible for private IP. For example, `projects/myProject/global/networks/default`. Specifying a network enables private IP. At least `ipv4_enabled` must be enabled or a `private_network` must be configured. This setting can be updated, but it cannot be removed after it is set.

  - **`require_ssl`**: _(Optional `bool`)_

    Whether SSL connections over IP are enforced or not.

  - **`authorized_networks`**: _(Optional `list(authorized_networks)`)_

    A List of backup retention settings.

    Example

    ```hcl
    authorized_networks = [{
      value = "10.10.10.10/32"
    }]
    ```

    Each `authorized_networks` object accepts the following fields:

    - **`expiration_time`**: _(Optional `string`)_

      The RFC 3339 formatted date time string indicating when this whitelist expires.

    - **`name`**: _(Optional `string`)_

      A name for this whitelist entry.
    
    - **`value`**: **_(Required `string`)_**

      A CIDR notation IPv4 or IPv6 address that is allowed to access this instance. Must be set even if other two attributes are not for the whitelist to become active.

- **`location_preference`**: _(Optional `object(location_preference)`)_

  An object of location preferences.

  Example

  ```hcl
  location_preference = {
    zone = "us-central1-a"
  }
  ```

  A `location_preference` object accepts the following fields:

  - **`zone`**: _(Optional `string`)_

    The preferred compute engine zone.

- **`maintenance_window`**: _(Optional `object(maintenance_window)`)_

  An object of maintenance window.

  Example

  ```hcl
  maintenance_window = {
    day          = 1
    hour         = 0
    update_track = "stable"
  }
  ```

  A `maintenance_window` object accepts the following fields:

  - **`day`**: _(Optional `number`)_

    Day of week (1-7), starting on Monday.

  - **`hour`**: _(Optional `number`)_

    Hour of day (0-23), ignored if day not set.

  - **`update_track`**: _(Optional `string`)_

    Receive updates earlier `canary` or later `stable`.

- **`insights_config`**: _(Optional `object(insights_config)`)_

  An object of insight config.

  Example

  ```hcl
  insights_config = {
    query_insights_enabled = true
  }
  ```

  A `insights_config` object accepts the following fields:

  - **`query_insights_enabled`**: _(Optional `bool`)_

    True if Query Insights feature is enabled.

  - **`query_string_length`**: _(Optional `number`)_

    Maximum query length stored in bytes. Between 256 and 4500. Default to 1024.

  - **`record_application_tags`**: _(Optional `bool`)_

    True if Query Insights will record application tags from query when enabled.

  - **`record_client_address`**: _(Optional `bool`)_

    True if Query Insights will record client address when enabled.

- **`replica_configuration`**: _(Optional `object(replica_configuration)`)_

  An object of replica configuration.

  Example

  ```hcl
  replica_configuration = {
    failover_target = true
  }
  ```

  A `replica_configuration` object accepts the following fields:

  - **`ca_certificate`**: _(Optional `string`)_

    PEM representation of the trusted CA's x509 certificate.

  - **`client_certificate`**: _(Optional `string`)_

    PEM representation of the replica's x509 certificate.

  - **`client_key`**: _(Optional `string`)_

    PEM representation of the replica's private key. The corresponding public key in encoded in the `client_certificate`.

  - **`connect_retry_interval`**: _(Optional `number`)_

    The number of seconds between connect retries. 
    
    Default is `60`.

  - **`dump_file_path`**: _(Optional `string`)_

    Path to a SQL file in GCS from which replica instances are created. Format is `gs://bucket/filename`.

  - **`failover_target`**: _(Optional `bool`)_

    Specifies if the replica is the failover target. If the field is set to true the replica will be designated as a failover replica. If the master instance fails, the replica instance will be promoted as the new master instance.

  - **`master_heartbeat_period`**: _(Optional `number`)_

    Time in ms between replication heartbeats.

  - **`password`**: _(Optional `string`)_

    Password for the replication connection.

  - **`ssl_cipher`**: _(Optional `string`)_

    Permissible ciphers for use in SSL encryption.

  - **`username`**: _(Optional `string`)_

    Username for replication connection.

  - **`verify_server_certificate`**: _(Optional `bool`)_

    True if the master's common name value is checked during the SSL handshake.

- **`module_timeouts`**: _(Optional `map(object)`)_

  `resource_timeouts` are keyed by resource type and define default timeouts for various terraform operations (see [Operation Timeouts](https://www.terraform.io/docs/language/resources/syntax.html#operation-timeouts))

  Example

  ```hcl
  module_timeouts = {
    google_sql_database_instance = {
      create = "30m"
      update = "30m"
      delete = "30m"
    }
  }
  ```

  A `module_timeouts` object accepts the following fields:

  - **`google_sql_database_instance`**: _(Optional `map(string)`)_

    - **`create`**: _(Optional)_ 
      
      Used for sql database instance creation. 
      
      Default is `"30m"`.

    - **`update`**: _(Optional)_ 
      
      Used for sql database instance manipulation. 
      
      Default is `"30m"`.

    - **`delete`**: _(Optional)_ 
      
      Used for sql database instance deletion.  
      
      Default is `"30m"`.

  - **`google_sql_database`**: _(Optional `map(string)`)_

    - **`create`**: _(Optional)_ 
      
      Used for sql database creation. 
      
      Default is `"15m"`.

    - **`update`**: _(Optional)_ 
      
      Used for sql database manipulation. 
      
      Default is `"10m"`.

    - **`delete`**: _(Optional)_ 
      
      Used for sql database deletion.  
      
      Default is `"10m"`.

  - **`google_sql_ssl_cert`**: _(Optional `map(string)`)_

    - **`create`**: _(Optional)_ 
      
      Used for sql user creation. 
      
      Default is `"10m"`.

    - **`delete`**: _(Optional)_ 
      
      Used for sql user deletion.  
      
      Default is `"10m"`.

  - **`google_sql_user`**: _(Optional `map(string)`)_

    - **`create`**: _(Optional)_ 
      
      Used for sql user creation. 
      
      Default is `"10m"`.

    - **`update`**: _(Optional)_ 
      
      Used for sql user manipulation. 
      
      Default is `"10m"`.

    - **`delete`**: _(Optional)_ 
      
      Used for sql user deletion.  
      
      Default is `"10m"`.

#### Extended Resource Configuration

- **`sql_databases`**: _(Optional `list(sql_databases)`)_

  List of sql databases.

  Example

  ```hcl
  sql_databases = [{
    name = "db"
  }]
  ```

  Each `sql_databases` object accepts the following fields:

  - **`name`**: **_(Required `string`)_**

    The Name of the database.

  - **`charset`**: _(Optional `string`)_

    The charset value. Postgres databases only support a value of `UTF8` at creation time.

  - **`collation`**: _(Optional `string`)_

    The collation value. Postgres databases only support a value of `en_US.UTF8` at creation time.

  - **`project`**: _(Optional `string`)_

    The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- **`sql_ssl_certs`**: _(Optional `list(sql_ssl_certs)`)_

  List of sql ssl certs.

  Example

  ```hcl
  sql_ssl_certs = [{
    common_name = "ssl-name"
  }]
  ```

  Each `sql_ssl_certs` object accepts the following fields:

  - **`common_name`**: **_(Required `string`)_**

    The common name to be used in the certificate to identify the client. Constrained to [a-zA-Z.-_ ]+. Changing this forces a new resource to be created.

  - **`project`**: _(Optional `string`)_

    The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- **`sql_users`**: _(Optional `list(sql_users)`)_

  List of sql users.

  Example

  ```hcl
  sql_users = [{
    name     = "user"
    password = "changeme"
  }]
  ```

  Each `sql_users` object accepts the following fields:

  - **`name`**: **_(Required `string`)_**

    The Name of the user.

  - **`password`**: _(Optional `string`)_

    The password for the user. Can be updated. For Postgres instances this is a Required field.

  - **`type`**: _(Optional `string`)_

    The user type. It determines the method to authenticate the user during login. The default is the database's built-in user type. Flags include `BUILT_IN`, `CLOUD_IAM_USER`, or `CLOUD_IAM_SERVICE_ACCOUNT`.
  
  - **`deletion_policy`**: _(Optional `string`)_

    The deletion policy for the user. Setting `ABANDON` allows the resource to be abandoned rather than deleted. This is useful for Postgres, where users cannot be deleted from the API if they have been granted SQL roles. Possible values are: `ABANDON`.

  - **`host`**: _(Optional `string`)_

    The host the user can connect from. This is only supported for MySQL instances. Don't set this field for PostgreSQL instances. Can be an IP address. Changing this forces a new resource to be created.

  - **`project`**: _(Optional `string`)_

    The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

## Module Attributes Reference

The following attributes are exported in the outputs of the module:

- **`module_enabled`**

  Whether this module is enabled.

- **`instance`**

  SQL Database Instance.

- **`databases`**

  All SQL Databases.

- **`certs`**

  All SQL Certs.

- **`users`**

  All SQL Users.

## External Documentation

- Google Documentation:
  - SQL Server on Google Cloud: https://cloud.google.com/sql-server
  - Configuring SSL/TLS certificates: https://cloud.google.com/sql/docs/mysql/configure-ssl-instance

- Terraform Google Provider Documentation:
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_ssl_cert
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]
This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2021 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-cloud-sql
[hello@mineiros.io]: mailto:hello@mineiros.io

<!-- markdown-link-check-disable -->

[badge-build]: https://github.com/mineiros-io/terraform-google-cloud-sql/workflows/Tests/badge.svg

<!-- markdown-link-check-enable -->

[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-google-cloud-sql.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

<!-- markdown-link-check-disable -->

[build-status]: https://github.com/mineiros-io/terraform-google-cloud-sql/actions
[releases-github]: https://github.com/mineiros-io/terraform-google-cloud-sql/releases

<!-- markdown-link-check-enable -->

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/

<!-- markdown-link-check-disable -->

[variables.tf]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-cloud-sql/issues
[license]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-cloud-sql/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/CONTRIBUTING.md

<!-- markdown-link-check-enable -->