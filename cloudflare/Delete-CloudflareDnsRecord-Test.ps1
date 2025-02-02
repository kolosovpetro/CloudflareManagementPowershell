Set-Location -Path $PSScriptRoot

$zoneId = $( ./Get-CloudflareZoneId.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneName "razumovsky.me" );

Write-Host "Zone ID: $zoneId"

$zoneName = "razumovsky.me"

$newDnsEntriesArray = @(
    "new-dns-record1.$zoneName",
    "new-dns-record2.$zoneName",
    "new-dns-record3.$zoneName"
)

foreach ($dns in $newDnsEntriesArray)
{
    .\Delete-CloudflareDnsRecord.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneId $zoneId -DnsName $dns
}