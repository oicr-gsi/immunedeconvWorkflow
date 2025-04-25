# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2025-04-23
### Added
- [GRD-795](https://jira.oicr.on.ca/browse/GRD-795) - Expanded built-in documentation (metadata changes only).

## [1.2.0] - 2024-06-25
### Added
- [GRD-797](https://jira.oicr.on.ca/browse/GRD-797) - add vidarr labels to outputs (changes to medata only)

## [1.1.0] - 2022-11-10
### Changed
- Change CIBERSORT output type to optional (some inputs may have zero L22 panel genes expressed). Should prevent cases like this failing.
  This updates relies on a newer version of immunedeconv-tools (also 1.1.0)

## [1.0.0] - 2022-09-09
### Added
- Released as version 1.0.0 (vidarr workflow)

## [Unreleased]
### Added
- Initial release of `immunedeconv` workflow
- Runs the CIBERSORT tool
- Open to future expansion, to include other immune profiling tools
