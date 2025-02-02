<#
.SYNOPSIS
    Updates an existing DNS record in a Cloudflare zone if it exists.

.DESCRIPTION
    This script checks if a DNS record with the specified name exists in the given Cloudflare zone.
    If the record exists, it updates the record with the provided IP address and comment.
    The script uses the Cloudflare API to update the DNS record and handles both success and failure responses.

.PARAMETER ApiToken
    The Cloudflare API token with the necessary permissions to manage DNS records.

.PARAMETER DnsName
    The DNS record name (e.g., subdomain.example.com) to be updated.

.PARAMETER ZoneId
    The unique identifier of the Cloudflare zone where the DNS record should be updated.

.PARAMETER IpAddress
    The new IP address to associate with the DNS record.

.PARAMETER Comment
    A comment to associate with the DNS record update.

.EXAMPLE
    .\Update-CloudflareDnsRecord.ps1 -ApiToken "your_api_token" -DnsName "subdomain.example.com" -ZoneId "your_zone_id" -IpAddress "198.51.100.1" -Comment "Updated DNS record"
    Updates the existing DNS record for "subdomain.example.com" with the new IP address "198.51.100.1" in the specified Cloudflare zone.

.NOTES
    - Ensure that your API token has permission to update DNS records.
    - The script requires PowerShell 5.1 or later.
    - Utilizes `curl` to interact with the Cloudflare API and `ConvertFrom-Json` for response handling.
#>


param (
    [Parameter(Mandatory = $true)]
    [string]$ApiToken,

    [Parameter(Mandatory = $true)]
    [string]$DnsName,

    [Parameter(Mandatory = $true)]
    [string]$ZoneId,

    [Parameter(Mandatory = $true)]
    [string]$IpAddress,

    [Parameter(Mandatory = $true)]
    [string]$Comment
)

$ErrorActionPreference = "Stop"

Write-Host "Checking existing DNS records ..."

$existingDnsRecords = $( .\Get-CloudflareDnsRecords.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneId "$zoneId" )

Write-Host "Existing DNS records count: $( $existingDnsRecords.Count )"

$recordExists = $existingDnsRecords.ContainsKey($DnsName)

Write-Host "Record $DnsName exists: $recordExists"

if ($recordExists -eq $False)
{
    Write-Host "Record $DnsName does not exist. Skipping update ..." -ForegroundColor Yellow
    exit 0
}

Write-Host "Record $DnsName exists. Starting update ..." -ForegroundColor Green

$recordId = $existingDnsRecords[$DnsName]

Write-Host "Record to update Name: $DnsName ID: $recordId"

$url = "https://api.cloudflare.com/client/v4/zones/$ZoneId/dns_records/$recordId"

$body = @{
    comment = $Comment
    content = $IpAddress
    name = $DnsName
    proxied = $false
    settings = @{
        ipv4_only = $false
        ipv6_only = $false
    }
    ttl = 1
    type = "A"
} | ConvertTo-Json -Depth 4

$response = curl -s -S $url `
    -X PATCH `
    -H "Authorization: Bearer $ApiToken" `
    -H "Content-Type: application/json" `
    -d $body

$responseJson = $response | ConvertFrom-Json

if ($responseJson.success -eq $true)
{
    Write-Host "DNS record Name: $DnsName ID: $recordId updated successfully." -ForegroundColor Green
    Write-Host "Response: $responseJson"
    return $responseJson.success
}
else
{
    Write-Host "Failed to update DNS record Name: $DnsName ID: $recordId" -ForegroundColor Red
    Write-Host "Response: $( $response )"
    exit 1
}

#.\Update-CloudflareDnsRecord.ps1 -ApiToken $env:CLOUDFLARE_API_KEY `
#	-DnsName "auth-eventtriangle.razumovsky.me" `
#	-ZoneId $zoneId `
#	-IpAddress "172.205.36.169"
