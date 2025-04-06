$zoneId = Get-CloudflareZoneId -ApiToken $env:CLOUDFLARE_API_KEY -ZoneName "razumovsky.me"
Write-Host "Zone ID: $zoneId"