Set-Location -Path $PSScriptRoot

$zoneId = $(./Get-CloudflareZoneId.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneName "razumovsky.me");
Write-Host "Zone ID: $zoneId"



