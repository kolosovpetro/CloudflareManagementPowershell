param(
    [Parameter(Mandatory = $true)]
    [string]$ApiToken,

    [Parameter(Mandatory = $true)]
    [string]$ZoneId,

    [Parameter(Mandatory = $true)]
    [string]$DnsName

)

$ErrorActionPreference = "Stop"

$existingDnsRecords = $( .\Get-CloudflareDnsRecords.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneId "$zoneId" )

Write-Host "Existing DNS records count: $( $existingDnsRecords.Count )"

$dnsRecordExists = $existingDnsRecords.ContainsKey($DnsName)

Write-Host "DNS name $DnsName exists: $dnsRecordExists"

if ($dnsRecordExists -eq $False)
{
    Write-Host "DNS record $DnsName does not exist. Skipping deletion ..." -ForegroundColor Yellow
    exit 0
}

Write-Host "DNS record $DnsName exists. Starting deletion ..." -ForegroundColor Green

$recordId = $existingDnsRecords[$DnsName]

$url = "https://api.cloudflare.com/client/v4/zones/$ZoneId/dns_records/$recordId"

$response = curl -s -S $url `
    -X DELETE `
    -H "Authorization: Bearer $ApiToken" `
    -H "Content-Type: application/json"

$responseJson = $response | ConvertFrom-Json

if ($responseJson.success -eq $true)
{
    Write-Host "DNS record $DnsName ID: $recordId deleted successfully." -ForegroundColor Green
    Write-Host "Response: $responseJson"
    return $responseJson.result.id
}
else
{
    Write-Host "Failed to delete DNS record $recordId." -ForegroundColor Red
    Write-Host "Response: $( $response )"
    exit 1
}