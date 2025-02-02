<#
.SYNOPSIS
    Deletes a DNS record from a Cloudflare zone using the Cloudflare API.

.DESCRIPTION
    This script connects to the Cloudflare API using an API token and removes a specified DNS record from a given zone.
    It requires the API token, the Cloudflare Zone ID, and the DNS record name to be deleted.

.PARAMETER ApiToken
    The Cloudflare API token with the necessary permissions to manage DNS records.

.PARAMETER ZoneId
    The unique identifier of the Cloudflare zone where the DNS record exists.

.PARAMETER DnsName
    The DNS record name (e.g., subdomain.example.com) to be deleted.

.EXAMPLE
    .\Delete-CloudflareDnsRecord.ps1 -ApiToken "your_api_token" -ZoneId "your_zone_id" -DnsName "subdomain.example.com"
    Deletes the specified DNS record from the Cloudflare zone.

.NOTES
    - Ensure that your API token has permission to delete DNS records.
    - The script requires PowerShell 5.1 or later.
#>

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