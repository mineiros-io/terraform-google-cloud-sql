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

In contrast to the plain `terraform_google_cloud_sql` resource this module has better features.
While all security features can be disabled as needed best practices
are pre-configured.

<!--
These are some of our custom features:

- **Default Security Settings**:
  secure by default by setting security to `true`, additional security can be added by setting some feature to `enabled`

- **Standard Module Features**:
  Cool Feature of the main resource, tags

- **Extended Module Features**:
  Awesome Extended Feature of an additional related resource,
  and another Cool Feature

- **Additional Features**:
  a Cool Feature that is not actually a resource but a cool set up from us

- _Features not yet implemented_:
  Standard Features missing,
  Extended Features planned,
  Additional Features planned
-->

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-google-cloud-sql" {
  source = "github.com/mineiros-io/terraform-google-cloud-sql.git?ref=v0.1.0"
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

- **`name`**: _(Optional, Computed `string`)_

  The name of the instance. If the name is left blank, Terraform will randomly generate one when the instance is first created. This is done because after a name is used, it cannot be reused for up to one week.
  Default is `null`.

- **`region`**: _(Optional `string`)_

  The region the instance will sit in.  If a region is not provided in the resource definition, the provider region will be used instead.
  Default is `null`.

- **`master_instance_name`**: _(Optional `string`)_

  The name of the existing instance that will act as the master in the replication setup. Note, this requires the master to have binary_log_enabled set, as well as existing backups.
  Default is `null`.

- **`project`**: _(Optional `string`)_

  The ID of the project in which the resource belongs. If it is not provided, the provider project is used.
  Default is `null`.

- **`deletion_protection`**: _(Optional `bool`)_

  Whether or not to allow Terraform to destroy the instance.
  Default is `true`.

- **`activation_policy`**: _(Optional `string`)_

  This specifies when the instance should be active. Can be either ALWAYS, NEVER or ON_DEMAND.
  Default is `null`.

- **`availability_type`**: _(Optional `string`)_

  The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL).' For MySQL instances, ensure that settings.backup_configuration.enabled and settings.backup_configuration.binary_log_enabled are both set to true.
  Default is `null`.

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
  Default is `null`.

- **`replication_type`**: _(Optional `string`)_

  This property is only applicable to First Generation instances.
  Default is `null`.

- **`user_labels`**: _(Optional `map(string)`)_

  A set of key/value user label pairs to assign to the instance.
  Default is `{}`.

- **`database_flags`**: _(Optional `list(database_flags)`)_

  List of database flags.
  Default is `[]`.

  Each `database_flags` object can have the following fields:

  - **`name`**: **_(Required `string`)_**

    Name of the flag.

  - **`value`**: **_(Required `string`)_**

    Value of the flag

  Example
  ```hcl
  user = [{
    name        = "database-example"
    value       = "example-value"
  }]
  ```

- **`backup_configuration`**: _(Optional `object(backup_configuration)`)_

  List of backup configurations.
  Default is `{}`.

  Each `backup_configuration` object can have the following fields:

  - **`binary_log_enabled`**: _(Optional `bool`)_

    True if binary logging is enabled. If settings.backup_configuration.enabled is false, this must be as well. Cannot be used with Postgres.
    Default `true`

  - **`enabled `**: _(Optional `bool`)_

    True if backup configuration is enabled.
    Default `true`

  - **`start_time`**: _(Optional `string`)_

    HH:MM format time indicating when backup configuration starts.
    Default is `null`

  - **`point_in_time_recovery_enabled `**: _(Optional `bool`)_

    True if Point-in-time recovery is enabled. Will restart database if enabled after instance creation. Valid only for PostgreSQL instances.
    Default `true`

  - **`location `**: _(Optional `string`)_

    TThe region where the backup will be stored.
    Default `null`

  - **`transaction_log_retention_days`**: _(Optional `number`)_

    TThe region where the backup will be stored.
    Default `null`

  - **`backup_retention_settings `**: _(Optional `map(string)`)_

    Backup retention settings. The configuration is detailed below.
    Default `[]`

    Each `backup_retention_settings` object can have the following fields:

    - **`retained_backups`**: **_(Required `string`)_**

      Depending on the value of retention_unit, this is used to determine if a backup needs to be deleted. If retention_unit is 'COUNT', we will retain this many backups.
      Default is `null`

    - **`retention_unit`**: **_(Required `string`)_**

      The unit that 'retained_backups' represents.
      Defaults is `COUNT`.

        Example
        ```hcl
        user = [{
            name        = "database-example"
            value       = "example-value"
        }]
         ```

- **`ip_configuration`**: _(Optional `object(ip_configuration)`)_

  List of ip configurations.
  Default is `{}`.

  Each `ip_configuration` object can have the following fields:

  - **`ipv4_enabled`**: _(Optional `bool`)_

    Whether this Cloud SQL instance should be assigned a public IPV4 address. At least `ipv4_enabled` must be enabled or a `private_network` must be configured
    Default `null`

  - **`private_network`**: _(Optional `bool`)_

    The VPC network from which the Cloud SQL instance is accessible for private IP. For example, projects/myProject/global/networks/default. Specifying a network enables private IP. At least `ipv4_enabled` must be enabled or a `private_network` must be configured. This setting can be updated, but it cannot be removed after it is set.
    Default `null`

  - **`require_ssl`**: _(Optional `bool`)_

    Whether SSL connections over IP are enforced or not.
    Default is `null`

- **`location_preference`**: _(Optional `object(location_preference)`)_

  A Map of location preferences.
  Default is `{}`.

  Each `location_preference` object can have the following fields:

  - **`follow_gae_application`**: _(Optional `string`)_

    A GAE application whose zone to remain in. Must be in the same region as this instance.
    Default `null`

  - **`zone`**: _(Optional `string`)_

    The preferred compute engine zone.
    Default `null`

- **`maintenance_window`**: _(Optional `object(maintenance_window)`)_

  A Map of maintenance window.
  Default is `{}`.

  Each `maintenance_window` object can have the following fields:

  - **`day`**: _(Optional `number`)_

    Day of week (`1-7`), starting on Monday
    Default `null`

  - **`hour`**: _(Optional `number`)_

    Hour of day (`0-23`), ignored if `day` not set
    Default `null`

  - **`update_track`**: _(Optional `string`)_

    Receive updates earlier (`canary`) or later (`stable`)
    Default `null`

- **`insights_config`**: _(Optional `object(insights_config)`)_

  A Map of insight config.
  Default is `{}`.

  Each `insights_config` object can have the following fields:

  - **`query_insights_enabled`**: _(Optional `bool`)_

    True if Query Insights feature is enabled.
    Default `null`

  - **`query_string_length`**: _(Optional `number`)_

    Maximum query length stored in bytes. Between 256 and 4500. Default to 1024.
    Default `null`

  - **`record_application_tags`**: _(Optional `bool`)_

    True if Query Insights will record application tags from query when enabled.
    Default `null`

  - **`record_client_address`**: _(Optional `bool`)_

    True if Query Insights will record client address when enabled.
    Default `null`

- **`replica_configuration`**: _(Optional `object(replica_configuration)`)_

  A Map of replica configuration.`replica_configuration` block must have master_instance_name set to work, cannot be updated.
  Default is `{}`.

  Each `replica_configuration` object can have the following fields:

  - **`ca_certificate`**: _(Optional `string`)_

    PEM representation of the trusted CA's x509 certificate.
    Default `null`

  - **`client_key`**: _(Optional `string`)_

    PEM representation of the replica's private key. The corresponding public key in encoded in the client_certificate.
    Default `null`

  - **`connect_retry_interval`**: _(Optional `number`)_

    The number of seconds between connect retries.
    Default `null`

  - **`dump_file_path`**: _(Optional `string`)_

    Path to a SQL file in GCS from which replica instances are created. Format is gs://bucket/filename.
    Default `null`

  - **`failover_target`**: _(Optional `string`)_

    Specifies if the replica is the failover target. If the field is set to true the replica will be designated as a failover replica. If the master instance fails, the replica instance will be promoted as the new master instance.
    Default `null`

  - **`master_heartbeat_period`**: _(Optional `string`)_

    Time in ms between replication heartbeats.
    Default `null`

  - **`password`**: _(Optional `string`)_

    Password for the replication connection.
    Default `null`

  - **`sslCipher`**: _(Optional `string`)_

    Permissible ciphers for use in SSL encryption.
    Default `null`

  - **`username`**: _(Optional `number`)_

    Maximum query length stored in bytes. Between 256 and 4500. Default to 1024.
    Default `null`

  - **`verify_server_certificate`**: _(Optional `bool`)_

    True if the master's common name value is checked during the SSL handshake.
    Default `null`

- **`timeouts`**: _(Optional `object(timeouts)`)_

  Timeouts configuration options:
  Default is `{}`.

  Each `timeout` object can have the following fields:

  - **`create`**: _(Optional `number`)_

    Timeout for create.
    Default `30` minutes.

  - **`update`**: _(Optional `number`)_

    Timeout for update.
    Default `30` minutes.

  - **`delete`**: _(Optional `number`)_

    Timeout for delete.
    Default `30` minutes.

- **`sql_databases`**: _(Optional `list(sql_databases`)_

  Represents a SQL database inside the Cloud SQL instance.
  Default is `[]`.

  Each `sql_database` object can have the following fields:

  - **`name`**: **_(Required `string`)_**

    The name of the database in the Cloud SQL instance. This does not include the project ID or instance name.

  - **`instance`**: **_(Required `string`)_**

    The name of the Cloud SQL instance. This does not include the project ID.

  - **`charset`**: _(Optional `string`)_

    The charset value. See MySQL's Supported Character Sets and Collations and Postgres' Character Set Support for more details and supported values. Postgres databases only support a value of UTF8 at creation time.
    Default is `null`.

  - **`collation`**: _(Optional `string`)_

    The collation value. See MySQL's Supported Character Sets and Collations and Postgres' Collation Support for more details and supported values. Postgres databases only support a value of en_US.UTF8 at creation time.
    Default is `null`.

  - **`project`**: _(Optional `string`)_

    The ID of the project in which the resource belongs. If it is not provided, the provider project is used.
    Default is `null`.

- **`sql_ssl_certs`**: _(Optional `list(sql_ssl_certs)`)_

  Creates a new Google SQL SSL Cert on a Google SQL Instance.
  Default is `[]`.

  Each `sql_ssl_cert` object can have the following fields:

  - **`instance`**: **_(Required `string`)_**

    The name of the Cloud SQL instance. Changing this forces a new resource to be created.

  - **`common_name`**: **_(Required `string`)_**

    The common name to be used in the certificate to identify the client. Constrained to [a-zA-Z.-_ ]+. Changing this forces a new resource to be created.

  - **`project`**: _(Optional `string`)_

    The ID of the project in which the resource belongs. If it is not provided, the provider project is used.
    Default is `null`.

#### Extended Resource Configuration

## Module Attributes Reference

The following attributes are exported in the outputs of the module:

- **`module_enabled`**

  Whether this module is enabled.

- **`instance`**

  SQL Database Instance

- **`databases`**

  All SQL Databases

- **`certs`**

  All SQL Certs

## External Documentation

- Google Documentation:
  - Cloud sql: https://cloud.google.com/sql/docs/features

- Terraform Google Provider Documentation:
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database
  - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_ssl_cert

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

<!--
[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.
-->
Copyright &copy; 2020-2021 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-cloud-sql
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
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[terraform]: https://www.terraform.io
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/

<!-- markdown-link-check-disable -->

[variables.tf]: https://github.com/mineiros-io/terraform-google-cloud-sql/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-cloud-sql/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-cloud-sql/issues
[license]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-cloud-sql/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-cloud-sql/blob/main/CONTRIBUTING.md

<!-- markdown-link-check-enable -->