# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.5]

## Added

- Add unit tests

## Removed

- Removed validation from `var.database_version`

## [0.0.4]

### BREAKING CHANGES

- Removed support for Terraform `< v1.0`
- Removed support for Google Provider `< v4.4`

## Added

- Added `allocated_ip_range` attribute to `settings.ip_configuration` block

## Removed

- Removed `replication_type` since it's been removed in provider `v0.4`

## [0.0.3]

### Fixed

- use `var.project` in all resources that need a project

## [0.0.2]

### Fixed

- Fixed `disk_autoresize` default to follow `disk_size` variable.

## [0.0.1]

### Added

- Initial Implementation

[unreleased]: https://github.com/mineiros-io/terraform-google-cloud-sql/compare/v0.0.5...HEAD
[0.0.5]: https://github.com/mineiros-io/terraform-google-cloud-sql/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/mineiros-io/terraform-google-cloud-sql/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/mineiros-io/terraform-google-cloud-sql/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/mineiros-io/terraform-google-cloud-sql/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-google-cloud-sql/releases/tag/v0.0.1
