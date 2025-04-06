$zoneName = "razumovsky.me"

$zoneId = Get-CloudflareZoneId -ApiToken $env:CLOUDFLARE_API_KEY -ZoneName $zoneName

Write-Host "Zone ID: $zoneId"

$newDnsEntriesHashtable = @{ }

$newDnsEntriesHashtable["new-dns-record1.$zoneName"] = "172.205.36.170"
$newDnsEntriesHashtable["new-dns-record2.$zoneName"] = "172.205.36.171"
$newDnsEntriesHashtable["new-dns-record3.$zoneName"] = "172.205.36.172"

foreach ($item in $newDnsEntriesHashtable.GetEnumerator())
{
	$newDnsRecord = $item.Name

	Write-Host "New Dns record: $newDnsRecord"

	$newIpAddress = $item.Value

	Write-Host "New IP address: $newIpAddress"

	Write-Host "Creating new DNS record $newDnsRecord with IP $newIpAddress"

	$comment = "Sent from PowerShell $( $( Get-Date ).DateTime )"

	Add-CloudflareDnsRecord -ApiToken $env:CLOUDFLARE_API_KEY `
	-Comment $comment `
	-DnsName $newDnsRecord `
	-ZoneId $zoneId `
	-IpAddress $newIpAddress
}