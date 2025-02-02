# Cloudflare Management Powershell

A complete PowerShell solution for managing Cloudflare DNS records: fetch Zone ID, retrieve all DNS records, create new
records, update existing ones, delete records, or create/update. Includes SYNOPSIS documentation for better user
experience. Tested on ubuntu-latest and windows-latest agents using GitHub Actions and Azure Pipelines.

## What's done so far

- PowerShell script to fetch Cloudflare Zone ID (including test)
- PowerShell script to fetch all DNS records by Cloudflare Zone ID (including test)
- PowerShell script to create new Cloudflare DNS record (including test)
- PowerShell script to update existing Cloudflare DNS record (including test)
- PowerShell script to create new or update existing Cloudflare DNS record (including test)
- PowerShell script to delete existing Cloudflare DNS record (including test)
- All PowerShell scripts that create or update are idempotent
- Add SYNOPSIS documentation for better user experience
- All scripts are tested on `ubuntu-latest` and `windows-latest` agents using `GitHub Actions`
- All scripts are tested on `ubuntu-latest` and `windows-latest` agents using `Azure Pipelines`

## Cloudflare API docs

- https://developers.cloudflare.com/api/resources/zones/methods/list/
- https://developers.cloudflare.com/api/resources/dns/subresources/records/methods/list/
- https://developers.cloudflare.com/api/resources/dns/subresources/records/methods/create/
- https://developers.cloudflare.com/api/resources/dns/subresources/records/methods/delete/
- https://developers.cloudflare.com/api/resources/dns/subresources/records/methods/edit/