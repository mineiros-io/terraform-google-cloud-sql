[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-cloud-sql)

[![Build Status](https://github.com/mineiros-io/terraform-google-cloud-sql/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-cloud-sql/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-cloud-sql.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-cloud-sql/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-cloud-sql

A [Terraform] module for [Google Cloud Platform (GCP)][gcp].

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 4._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Module Configuration](#module-configuration)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Extended Resource Configuration](#extended-resource-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Google Documentation](#google-documentation)
  - [Terraform Google Provider Documentation](#terraform-google-provider-documentation)
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
  source = "github.com/mineiros-io/terraform-google-cloud-sql.git?ref=v0.0.5"

  tier             = "db-f1-micro"
  database_version = "MYSQL_5_6"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:

  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

### Main Resource Configuration

- [**`database_version`**](#var-database_version): *(**Required** `string`)*<a name="var-database_version"></a>

  The MySQL, PostgreSQL or SQL Server (beta) version to use.

- [**`tier`**](#var-tier): *(**Required** `string`)*<a name="var-tier"></a>

  The machine type to use.

- [**`name`**](#var-name): *(Optional `string`)*<a name="var-name"></a>

  The name of the instance. If the name is left blank, Terraform will randomly generate one when the instance is first created. This is done because after a name is used, it cannot be reused for up to one week.

- [**`region`**](#var-region): *(Optional `string`)*<a name="var-region"></a>

  The region the instance will sit in.  If a region is not provided in the resource definition, the provider region will be used instead.

- [**`master_instance_name`**](#var-master_instance_name): *(Optional `string`)*<a name="var-master_instance_name"></a>

  The name of the existing instance that will act as the master in the replication setup. Note, this requires the master to have `binary_log_enabled` set, as well as existing backups.

- [**`project`**](#var-project): *(Optional `string`)*<a name="var-project"></a>

  The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- [**`deletion_protection`**](#var-deletion_protection): *(Optional `bool`)*<a name="var-deletion_protection"></a>

  Whether or not to allow Terraform to destroy the instance.

  Default is `true`.

- [**`activation_policy`**](#var-activation_policy): *(Optional `string`)*<a name="var-activation_policy"></a>

  This specifies when the instance should be active. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.

- [**`availability_type`**](#var-availability_type): *(Optional `string`)*<a name="var-availability_type"></a>

  The availability type of the Cloud SQL instance, high availability `REGIONAL` or single zone `ZONAL`. For MySQL instances, ensure that `settings.backup_configuration.enabled` and `settings.backup_configuration.binary_log_enabled` are both set to `true`.

- [**`disk_autoresize`**](#var-disk_autoresize): *(Optional `bool`)*<a name="var-disk_autoresize"></a>

  Configuration to increase storage size automatically.

  Default is `true`.

- [**`disk_size`**](#var-disk_size): *(Optional `number`)*<a name="var-disk_size"></a>

  The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased.

  Default is `10`.

- [**`disk_type`**](#var-disk_type): *(Optional `string`)*<a name="var-disk_type"></a>

  The type of data disk: `PD_SSD` or `PD_HDD`.

  Default is `"PD_SSD"`.

- [**`pricing_plan`**](#var-pricing_plan): *(Optional `string`)*<a name="var-pricing_plan"></a>

  Pricing plan for this instance, can only be `PER_USE`.

- [**`user_labels`**](#var-user_labels): *(Optional `map(string)`)*<a name="var-user_labels"></a>

  A set of key/value user label pairs to assign to the instance.

- [**`database_flags`**](#var-database_flags): *(Optional `list(database_flag)`)*<a name="var-database_flags"></a>

  List of database flags.

  Each `database_flag` object in the list accepts the following attributes:

  - [**`name`**](#attr-database_flags-name): *(**Required** `string`)*<a name="attr-database_flags-name"></a>

    Name of the flag.

  - [**`value`**](#attr-database_flags-value): *(**Required** `string`)*<a name="attr-database_flags-value"></a>

    Value of the flag.

    Example:

    ```hcl
    database_flags = [{
      name  = "long_query_time"
      value = "1"
    }]
    ```

- [**`backup_configuration`**](#var-backup_configuration): *(Optional `object(backup_configuration)`)*<a name="var-backup_configuration"></a>

  An object of backup configuration.

  Example:

  ```hcl
  backup_configuration = {
    enabled    = true
    start_time = "17:00"
  }
  ```

  The `backup_configuration` object accepts the following attributes:

  - [**`binary_log_enabled`**](#attr-backup_configuration-binary_log_enabled): *(Optional `bool`)*<a name="attr-backup_configuration-binary_log_enabled"></a>

    True if binary logging is enabled. If `settings.backup_configuration.enabled` is `false`, this must be as well. Cannot be used with Postgres.

  - [**`enabled`**](#attr-backup_configuration-enabled): *(Optional `bool`)*<a name="attr-backup_configuration-enabled"></a>

    True if backup configuration is enabled.

  - [**`start_time`**](#attr-backup_configuration-start_time): *(Optional `string`)*<a name="attr-backup_configuration-start_time"></a>

    `HH:MM` format time indicating when backup configuration starts.

  - [**`point_in_time_recovery_enabled`**](#attr-backup_configuration-point_in_time_recovery_enabled): *(Optional `bool`)*<a name="attr-backup_configuration-point_in_time_recovery_enabled"></a>

    True if Point-in-time recovery is enabled. Will restart database if enabled after instance creation. Valid only for PostgreSQL instances.

  - [**`location`**](#attr-backup_configuration-location): *(Optional `string`)*<a name="attr-backup_configuration-location"></a>

    The region where the backup will be stored.

  - [**`transaction_log_retention_days`**](#attr-backup_configuration-transaction_log_retention_days): *(Optional `number`)*<a name="attr-backup_configuration-transaction_log_retention_days"></a>

    The number of days of transaction logs we retain for point in time restore, from 1-7.

  - [**`backup_retention_settings`**](#attr-backup_configuration-backup_retention_settings): *(Optional `list(backup_retention_setting)`)*<a name="attr-backup_configuration-backup_retention_settings"></a>

    A List of backup retention settings.

    Example:

    ```hcl
    backup_retention_settings = [{
      retained_backups = 3
      retention_unit   = "COUNT"
    }]
    ```

    Each `backup_retention_setting` object in the list accepts the following attributes:

    - [**`retained_backups`**](#attr-backup_configuration-backup_retention_settings-retained_backups): *(Optional `number`)*<a name="attr-backup_configuration-backup_retention_settings-retained_backups"></a>

      Depending on the value of `retention_unit`, this is used to determine if a backup needs to be deleted. If `retention_unit` is `COUNT`, we will retain this many backups.

    - [**`retention_unit`**](#attr-backup_configuration-backup_retention_settings-retention_unit): *(Optional `string`)*<a name="attr-backup_configuration-backup_retention_settings-retention_unit"></a>

      The unit that `retained_backups` represents.

      Default is `"COUNT"`.

- [**`ip_configuration`**](#var-ip_configuration): *(Optional `object(ip_configuration)`)*<a name="var-ip_configuration"></a>

  An object of ip configuration.

  Example:

  ```hcl
  ip_configuration = {
    ipv4_enabled = true
  }
  ```

  The `ip_configuration` object accepts the following attributes:

  - [**`ipv4_enabled`**](#attr-ip_configuration-ipv4_enabled): *(Optional `bool`)*<a name="attr-ip_configuration-ipv4_enabled"></a>

    Whether this Cloud SQL instance should be assigned a public IPV4 address. At least `ipv4_enabled` must be enabled or a `private_network` must be configured.

  - [**`private_network`**](#attr-ip_configuration-private_network): *(Optional `string`)*<a name="attr-ip_configuration-private_network"></a>

    The VPC network from which the Cloud SQL instance is accessible for private IP. For example, `projects/myProject/global/networks/default`. Specifying a network enables private IP. At least `ipv4_enabled` must be enabled or a `private_network` must be configured. This setting can be updated, but it cannot be removed after it is set.

  - [**`require_ssl`**](#attr-ip_configuration-require_ssl): *(Optional `bool`)*<a name="attr-ip_configuration-require_ssl"></a>

    Whether SSL connections over IP are enforced or not.

  - [**`allocated_ip_range `**](#attr-ip_configuration-allocated_ip_range ): *(Optional `string`)*<a name="attr-ip_configuration-allocated_ip_range "></a>

    The name of the allocated ip range for the private ip CloudSQL instance.
    For example: `google-managed-services-default`. If set, the instance
    ip will be created in the allocated range. The range name must
    comply with [RFC 1035](https://tools.ietf.org/html/rfc1035).
    Specifically, the name must be 1-63 characters long and match
    the regular expression `a-z?`.

  - [**`authorized_networks`**](#attr-ip_configuration-authorized_networks): *(Optional `list(authorized_network)`)*<a name="attr-ip_configuration-authorized_networks"></a>

    A List of backup retention settings.

    Example:

    ```hcl
    authorized_networks = [{
      value = "10.10.10.10/32"
    }]
    ```

    Each `authorized_network` object in the list accepts the following attributes:

    - [**`expiration_time`**](#attr-ip_configuration-authorized_networks-expiration_time): *(Optional `string`)*<a name="attr-ip_configuration-authorized_networks-expiration_time"></a>

      The RFC 3339 formatted date time string indicating when this whitelist expires.

    - [**`name`**](#attr-ip_configuration-authorized_networks-name): *(Optional `string`)*<a name="attr-ip_configuration-authorized_networks-name"></a>

      A name for this whitelist entry.

    - [**`value`**](#attr-ip_configuration-authorized_networks-value): *(**Required** `string`)*<a name="attr-ip_configuration-authorized_networks-value"></a>

      A CIDR notation IPv4 or IPv6 address that is allowed to access this instance. Must be set even if other two attributes are not for the whitelist to become active.

- [**`location_preference`**](#var-location_preference): *(Optional `object(location_preference)`)*<a name="var-location_preference"></a>

  An object of location preferences.

  Example:

  ```hcl
  location_preference = {
    zone = "us-central1-a"
  }
  ```

  The `location_preference` object accepts the following attributes:

  - [**`follow_gae_application`**](#attr-location_preference-follow_gae_application): *(Optional `string`)*<a name="attr-location_preference-follow_gae_application"></a>

    A GAE application whose zone to remain in. Must be in the same region as this instance.

  - [**`zone`**](#attr-location_preference-zone): *(Optional `string`)*<a name="attr-location_preference-zone"></a>

    The preferred compute engine zone.

- [**`maintenance_window`**](#var-maintenance_window): *(Optional `object(maintenance_window)`)*<a name="var-maintenance_window"></a>

  An object of maintenance window.

  Example:

  ```hcl
  maintenance_window = {
    day          = 1
    hour         = 0
    update_track = "stable"
  }
  ```

  The `maintenance_window` object accepts the following attributes:

  - [**`day`**](#attr-maintenance_window-day): *(Optional `number`)*<a name="attr-maintenance_window-day"></a>

    Day of week (1-7), starting on Monday.

  - [**`hour`**](#attr-maintenance_window-hour): *(Optional `number`)*<a name="attr-maintenance_window-hour"></a>

    Hour of day (0-23), ignored if day not set.

  - [**`update_track`**](#attr-maintenance_window-update_track): *(Optional `string`)*<a name="attr-maintenance_window-update_track"></a>

    Receive updates earlier `canary` or later `stable`.

- [**`insights_config`**](#var-insights_config): *(Optional `object(insights_config)`)*<a name="var-insights_config"></a>

  An object of insight config.

  Example:

  ```hcl
  insights_config = {
    query_insights_enabled = true
  }
  ```

  The `insights_config` object accepts the following attributes:

  - [**`query_insights_enabled`**](#attr-insights_config-query_insights_enabled): *(Optional `bool`)*<a name="attr-insights_config-query_insights_enabled"></a>

    True if Query Insights feature is enabled.

  - [**`query_string_length`**](#attr-insights_config-query_string_length): *(Optional `number`)*<a name="attr-insights_config-query_string_length"></a>

    Maximum query length stored in bytes. Between 256 and 4500. Default to 1024.

    Default is `1024`.

  - [**`record_application_tags`**](#attr-insights_config-record_application_tags): *(Optional `bool`)*<a name="attr-insights_config-record_application_tags"></a>

    True if Query Insights will record application tags from query when enabled.

  - [**`record_client_address`**](#attr-insights_config-record_client_address): *(Optional `bool`)*<a name="attr-insights_config-record_client_address"></a>

    True if Query Insights will record client address when enabled.

- [**`replica_configuration`**](#var-replica_configuration): *(Optional `object(replica_configuration)`)*<a name="var-replica_configuration"></a>

  An object of replica configuration.

  Example:

  ```hcl
  replica_configuration = {
    failover_target = true
  }
  ```

  The `replica_configuration` object accepts the following attributes:

  - [**`ca_certificate`**](#attr-replica_configuration-ca_certificate): *(Optional `string`)*<a name="attr-replica_configuration-ca_certificate"></a>

    PEM representation of the trusted CA's x509 certificate.

  - [**`client_certificate`**](#attr-replica_configuration-client_certificate): *(Optional `string`)*<a name="attr-replica_configuration-client_certificate"></a>

    PEM representation of the replica's x509 certificate.

  - [**`client_key`**](#attr-replica_configuration-client_key): *(Optional `string`)*<a name="attr-replica_configuration-client_key"></a>

    PEM representation of the replica's private key. The corresponding public key in encoded in the `client_certificate`.

  - [**`connect_retry_interval`**](#attr-replica_configuration-connect_retry_interval): *(Optional `number`)*<a name="attr-replica_configuration-connect_retry_interval"></a>

    The number of seconds between connect retries.

    Default is `60`.

  - [**`dump_file_path`**](#attr-replica_configuration-dump_file_path): *(Optional `string`)*<a name="attr-replica_configuration-dump_file_path"></a>

    Path to a SQL file in GCS from which replica instances are created. Format is `gs://bucket/filename`.

  - [**`failover_target`**](#attr-replica_configuration-failover_target): *(Optional `bool`)*<a name="attr-replica_configuration-failover_target"></a>

    Specifies if the replica is the failover target. If the field is set to true the replica will be designated as a failover replica. If the master instance fails, the replica instance will be promoted as the new master instance.

  - [**`master_heartbeat_period`**](#attr-replica_configuration-master_heartbeat_period): *(Optional `number`)*<a name="attr-replica_configuration-master_heartbeat_period"></a>

    Time in ms between replication heartbeats.

  - [**`password`**](#attr-replica_configuration-password): *(Optional `string`)*<a name="attr-replica_configuration-password"></a>

    Password for the replication connection.

  - [**`ssl_cipher`**](#attr-replica_configuration-ssl_cipher): *(Optional `string`)*<a name="attr-replica_configuration-ssl_cipher"></a>

    Permissible ciphers for use in SSL encryption.

  - [**`username`**](#attr-replica_configuration-username): *(Optional `string`)*<a name="attr-replica_configuration-username"></a>

    Username for replication connection.

  - [**`verify_server_certificate`**](#attr-replica_configuration-verify_server_certificate): *(Optional `bool`)*<a name="attr-replica_configuration-verify_server_certificate"></a>

    True if the master's common name value is checked during the SSL handshake.

- [**`module_timeouts`**](#var-module_timeouts): *(Optional `map(module_timeout)`)*<a name="var-module_timeouts"></a>

  `resource_timeouts` are keyed by resource type and define default timeouts for various terraform operations (see [Operation Timeouts](https://www.terraform.io/docs/language/resources/syntax.html#operation-timeouts))

  Example:

  ```hcl
  module_timeouts = {
    google_sql_database_instance = {
      create = "30m"
      update = "30m"
      delete = "30m"
    }
  }
  ```

  Each `module_timeout` object in the map accepts the following attributes:

  - [**`google_sql_database_instance`**](#attr-module_timeouts-google_sql_database_instance): *(Optional `map(string)`)*<a name="attr-module_timeouts-google_sql_database_instance"></a>

    - **`create`**: _(Optional)_ 

      Used for sql database instance creation. 

      Default is `"30m"`.

    - **`update`**: _(Optional)_ 

      Used for sql database instance manipulation. 

      Default is `"30m"`.

    - **`delete`**: _(Optional)_ 

      Used for sql database instance deletion.  

      Default is `"30m"`.

    Default is `"30m"`.

  - [**`google_sql_database`**](#attr-module_timeouts-google_sql_database): *(Optional `map(string)`)*<a name="attr-module_timeouts-google_sql_database"></a>

    - **`create`**: _(Optional)_ 

      Used for sql database creation. 

      Default is `"15m"`.

    - **`update`**: _(Optional)_ 

      Used for sql database manipulation. 

      Default is `"10m"`.

    - **`delete`**: _(Optional)_ 

      Used for sql database deletion.  

      Default is `"10m"`.

    Default is `"15m"`.

  - [**`google_sql_ssl_cert`**](#attr-module_timeouts-google_sql_ssl_cert): *(Optional `map(string)`)*<a name="attr-module_timeouts-google_sql_ssl_cert"></a>

    - **`create`**: _(Optional)_ 

      Used for sql user creation. 

      Default is `"10m"`.

    - **`delete`**: _(Optional)_ 

      Used for sql user deletion.  

      Default is `"10m"`.

    Default is `"10m"`.

  - [**`google_sql_user`**](#attr-module_timeouts-google_sql_user): *(Optional `map(string)`)*<a name="attr-module_timeouts-google_sql_user"></a>

    - **`create`**: _(Optional)_ 

      Used for sql user creation. 

      Default is `"10m"`.

    - **`update`**: _(Optional)_ 

      Used for sql user manipulation. 

      Default is `"10m"`.

    - **`delete`**: _(Optional)_ 

      Used for sql user deletion.  

      Default is `"10m"`.

    Default is `"10m"`.

### Extended Resource Configuration

- [**`sql_databases`**](#var-sql_databases): *(Optional `list(sql_database)`)*<a name="var-sql_databases"></a>

  List of sql databases.

  Example:

  ```hcl
  sql_databases = [{
    name = "db"
  }]
  ```

  Each `sql_database` object in the list accepts the following attributes:

  - [**`name`**](#attr-sql_databases-name): *(**Required** `string`)*<a name="attr-sql_databases-name"></a>

    The Name of the database.

  - [**`charset`**](#attr-sql_databases-charset): *(Optional `string`)*<a name="attr-sql_databases-charset"></a>

    The charset value. Postgres databases only support a value of `UTF8` at creation time.

  - [**`collation`**](#attr-sql_databases-collation): *(Optional `string`)*<a name="attr-sql_databases-collation"></a>

    The collation value. Postgres databases only support a value of `en_US.UTF8` at creation time.

  - [**`project`**](#attr-sql_databases-project): *(Optional `string`)*<a name="attr-sql_databases-project"></a>

    The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- [**`sql_ssl_certs`**](#var-sql_ssl_certs): *(Optional `list(sql_ssl_cert)`)*<a name="var-sql_ssl_certs"></a>

  List of sql ssl certs.

  Example:

  ```hcl
  sql_ssl_certs = [{
    common_name = "ssl-name"
  }]
  ```

  Each `sql_ssl_cert` object in the list accepts the following attributes:

  - [**`common_name`**](#attr-sql_ssl_certs-common_name): *(**Required** `string`)*<a name="attr-sql_ssl_certs-common_name"></a>

    The common name to be used in the certificate to identify the client. Constrained to [a-zA-Z.-_ ]+. Changing this forces a new resource to be created.

  - [**`project`**](#attr-sql_ssl_certs-project): *(Optional `string`)*<a name="attr-sql_ssl_certs-project"></a>

    The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- [**`sql_users`**](#var-sql_users): *(Optional `list(sql_user)`)*<a name="var-sql_users"></a>

  List of sql users.

  Example:

  ```hcl
  sql_users = [{
    name     = "user"
    password = "changeme"
  }]
  ```

  Each `sql_user` object in the list accepts the following attributes:

  - [**`name`**](#attr-sql_users-name): *(**Required** `string`)*<a name="attr-sql_users-name"></a>

    The Name of the user.

  - [**`password`**](#attr-sql_users-password): *(Optional `string`)*<a name="attr-sql_users-password"></a>

    The password for the user. Can be updated. For Postgres instances this is a Required field.

  - [**`type`**](#attr-sql_users-type): *(Optional `string`)*<a name="attr-sql_users-type"></a>

    The user type. It determines the method to authenticate the user during login. The default is the database's built-in user type. Flags include `BUILT_IN`, `CLOUD_IAM_USER`, or `CLOUD_IAM_SERVICE_ACCOUNT`.

  - [**`deletion_policy`**](#attr-sql_users-deletion_policy): *(Optional `string`)*<a name="attr-sql_users-deletion_policy"></a>

    The deletion policy for the user. Setting `ABANDON` allows the resource to be abandoned rather than deleted. This is useful for Postgres, where users cannot be deleted from the API if they have been granted SQL roles. Possible values are: `ABANDON`.

  - [**`host`**](#attr-sql_users-host): *(Optional `string`)*<a name="attr-sql_users-host"></a>

    The host the user can connect from. This is only supported for MySQL instances. Don't set this field for PostgreSQL instances. Can be an IP address. Changing this forces a new resource to be created.

  - [**`project`**](#attr-sql_users-project): *(Optional `string`)*<a name="attr-sql_users-project"></a>

    The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`module_enabled`**](#output-module_enabled): *(`object(instance)`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

- [**`instance`**](#output-instance): *(`object(instance)`)*<a name="output-instance"></a>

  SQL Database Instance.

- [**`databases`**](#output-databases): *(`map(database)`)*<a name="output-databases"></a>

  All SQL Databases.

- [**`certs`**](#output-certs): *(`map(cert)`)*<a name="output-certs"></a>

  All SQL Certs.

- [**`users`**](#output-users): *(`map(user)`)*<a name="output-users"></a>

  All SQL Users.

## External Documentation

### Google Documentation

- SQL Server on Google Cloud: https://cloud.google.com/sql-server
- Configuring SSL/TLS certificates: https://cloud.google.com/sql/docs/mysql/configure-ssl-instance

### Terraform Google Provider Documentation

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

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-cloud-sql
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-google-cloud-sql/workflows/Tests/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-google-cloud-sql.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[build-status]: https://github.com/mineiros-io/terraform-google-cloud-sql/actions
[releases-github]: https://github.com/mineiros-io/terraform-google-cloud-sql/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-cloud-sql/issues
[license]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-cloud-sql/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/CONTRIBUTING.md
