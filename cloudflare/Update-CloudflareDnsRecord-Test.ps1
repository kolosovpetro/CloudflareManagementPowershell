Set-Location -Path $PSScriptRoot

$zoneName = "razumovsky.me"
Write-Host "Zone Name: $zoneName"

$zoneId = $( ./Get-CloudflareZoneId.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneName $zoneName );
Write-Host "Zone ID: $zoneId"

$validDnsRecord = "postman-test.$zoneName"
$dnsDoesNotExist = "postman-test1.$zoneName"

Write-Host "Checking valid DNS record to update $validDnsRecord .."

.\Update-CloudflareDnsRecord.ps1 -ApiToken $env:CLOUDFLARE_API_KEY `
	-Comment "Sent from PowerShell $( $( Get-Date ).DateTime )" `
	-DnsName $validDnsRecord `
	-ZoneId $zoneId `
	-IpAddress "172.205.36.170"

Write-Host "Checking invalid DNS record to update $dnsDoesNotExist .."

.\Update-CloudflareDnsRecord.ps1 -ApiToken $env:CLOUDFLARE_API_KEY `
	-Comment "Sent from PowerShell $( $( Get-Date ).DateTime )" `
	-DnsName $dnsDoesNotExist `
	-ZoneId $zoneId `
	-IpAddress "172.205.36.169"
