Set-Location -Path $PSScriptRoot

$zoneId = $(./Get-CloudflareZoneId.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneName "razumovsky.me");
Write-Host "Zone ID: $zoneId"

$dnsRecords = $(.\Get-CloudflareDnsRecords.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneId "$zoneId")
Write-Host "DNS records count: $($dnsRecords.Count)"