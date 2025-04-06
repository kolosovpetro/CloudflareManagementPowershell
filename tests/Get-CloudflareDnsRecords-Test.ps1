$zoneId = Get-CloudflareZoneId -ApiToken $env:CLOUDFLARE_API_KEY -ZoneName "razumovsky.me"

Write-Host "Zone ID: $zoneId"

$dnsRecords = Get-CloudflareDnsRecords -ApiToken $env:CLOUDFLARE_API_KEY -ZoneId "$zoneId"

Write-Host "DNS records count: $($dnsRecords.Count)"