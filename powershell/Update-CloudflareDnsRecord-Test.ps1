$zoneId = $( ./Get-CloudflareZoneId.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneName "razumovsky.me" );
Write-Host "Zone ID: $zoneId"

$dnsRecords = $( .\Get-CloudflareDnsRecords.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneId "$zoneId" )
$dnsRecords

if ($dnsRecords -is [Hashtable] -and $dnsRecords.Count -eq 0)
{
    Write-Output "Empty DNS records, skipping"
    return
}

Write-Host "Getting first or default record"

$firstItem = $dnsRecords.GetEnumerator() | Select-Object -First 1
$firstItem
$firstItem.Name
$firstItem.Value

.\Update-CloudflareDnsRecord.ps1 -ApiToken $env:CLOUDFLARE_API_KEY `
	-Comment "Sent from PowerShell $( $( Get-Date ).DateTime )" `
	-DnsName $firstItem.Name `
	-ZoneId $zoneId `
	-RecordId $firstItem.Value `
	-IpAddress "172.205.36.169"