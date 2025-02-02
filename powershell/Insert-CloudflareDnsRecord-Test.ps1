$zoneId = $( ./Get-CloudflareZoneId.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneName "razumovsky.me" );
Write-Host "Zone ID: $zoneId"

$newDnsRecord = "new-dns-record"

Write-Host "New Dns record: $newDnsRecord"

$newIpAddress = "172.205.36.169"

Write-Host "New IP address: $newIpAddress"

Write-Host "Creating new DNS record $newDnsRecord with IP $newIpAddress"

$comment = "Sent from PowerShell $( $( Get-Date ).DateTime )"

.\Insert-CloudflareDnsRecord.ps1 -ApiToken $env:CLOUDFLARE_API_KEY `
	-Comment $comment `
	-DnsName $newDnsRecord `
	-ZoneId $zoneId `
	-IpAddress $newIpAddress