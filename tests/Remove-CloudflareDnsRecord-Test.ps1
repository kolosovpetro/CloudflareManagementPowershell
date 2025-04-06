$zoneId = Get-CloudflareZoneId -ApiToken $env:CLOUDFLARE_API_KEY -ZoneName "razumovsky.me"

Write-Host "Zone ID: $zoneId"

$zoneName = "razumovsky.me"

$newDnsEntriesArray = @(
    "new-dns-record1.$zoneName",
    "new-dns-record2.$zoneName",
    "new-dns-record3.$zoneName"
)

foreach ($dns in $newDnsEntriesArray)
{
    Remove-CloudflareDnsRecord -ApiToken $env:CLOUDFLARE_API_KEY -ZoneId $zoneId -DnsName $dns
}