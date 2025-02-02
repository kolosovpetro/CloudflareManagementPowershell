# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning v2.0.0](https://semver.org/spec/v2.0.0.html).

## v1.0.0 - In Progress

### Changed

- PowerShell script to fetch Cloudflare Zone ID (including test)
- PowerShell script to fetch all DNS records by Cloudflare Zone ID (including test)
- PowerShell script to create new Cloudflare DNS record (including test)
- PowerShell script to update existing Cloudflare DNS record (including test)
- PowerShell script to create new or update existing Cloudflare DNS record (including test)
- PowerShell script to delete existing Cloudflare DNS record (including test)
- All PowerShell scripts that create or update are idempotent
- Add SYNOPSIS documentation for clarity
- All scripts are tested on `ubuntu-latest` and `windows-latest` agents using GitHub Actions
