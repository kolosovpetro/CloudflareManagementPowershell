$zoneId = $( ./Get-CloudflareZoneId.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneName "razumovsky.me" );

Write-Host "Zone ID: $zoneId"

$zoneName = "razumovsky.me"

$newDnsEntriesHashtable = @{ }

$newDnsEntriesHashtable["new-dns-record1.$zoneName"] = "172.205.36.170"
$newDnsEntriesHashtable["new-dns-record2.$zoneName"] = "172.205.36.171"
$newDnsEntriesHashtable["new-dns-record3.$zoneName"] = "172.205.36.172"

$existingDnsRecords = $( .\Get-CloudflareDnsRecords.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneId "$zoneId" )

Write-Host "Existing DNS records"
$existingDnsRecords

foreach ($entry in $newDnsEntriesHashtable.GetEnumerator())
{

    $dnsName = $entry.Name

    $existingDnsRecordsContainsKey = $($existingDnsRecords.ContainsKey($dnsName) );

    Write-Host "Existing DNS contains key $dnsName is $existingDnsRecordsContainsKey"

    if (-not $existingDnsRecordsContainsKey)
    {
        Write-Host "DNS name $dnsName does not exist. Skipping ..."
        continue
    }

    $recordId = $existingDnsRecords[$dnsName]

    Write-Host "Record ID to delete: $recordId. Starting deletion..."


    .\Delete-CloudflareDnsRecord.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneId $zoneId -RecordId $recordId
}