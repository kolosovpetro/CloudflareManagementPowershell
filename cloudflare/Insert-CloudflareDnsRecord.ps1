<#
.SYNOPSIS
    Creates a new DNS record in a Cloudflare zone if it doesn't already exist.

.DESCRIPTION
    This script checks if a DNS record with the specified name exists in the given Cloudflare zone.
    If the record doesn't exist, it creates an "A" type DNS record with the provided IP address and comment.
    It interacts with the Cloudflare API to create the record and handles both success and failure responses.

.PARAMETER ApiToken
    The Cloudflare API token with the necessary permissions to manage DNS records.

.PARAMETER DnsName
    The DNS record name (e.g., subdomain.example.com) to be created.

.PARAMETER ZoneId
    The unique identifier of the Cloudflare zone where the DNS record should be created.

.PARAMETER IpAddress
    The IP address to associate with the DNS record.

.PARAMETER Comment
    A comment to associate with the DNS record.

.EXAMPLE
    .\Create-CloudflareDnsRecord.ps1 -ApiToken "your_api_token" -DnsName "subdomain.example.com" -ZoneId "your_zone_id" -IpAddress "192.0.2.1" -Comment "New DNS record"
    Creates a new DNS "A" record for "subdomain.example.com" with the IP address "192.0.2.1" in the specified Cloudflare zone.

.NOTES
    - Ensure that your API token has permission to create DNS records.
    - The script requires PowerShell 5.1 or later.
    - Utilizes `curl` to interact with the Cloudflare API and `ConvertFrom-Json` for response handling.
#>


param(
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

$url = "https://api.cloudflare.com/client/v4/zones/$ZoneId/dns_records"

$existingDnsRecords = $( .\Get-CloudflareDnsRecords.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneId "$zoneId" )

Write-Host "Existing DNS records count: $( $existingDnsRecords.Count )"

$recordExists = $existingDnsRecords.ContainsKey($dnsName)

Write-Host "Record $DnsName exists already: $recordExists"

if ($recordExists -eq $True)
{
    Write-Host "Record $DnsName exists already. Skipping..." -ForegroundColor Yellow
    exit 0
}

Write-Host "Record $DnsName does not exist. Creating ..." -ForegroundColor Green

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
    -X POST `
    -H "Authorization: Bearer $ApiToken" `
    -H "Content-Type: application/json" `
    -d $body

$responseJson = $response | ConvertFrom-Json

if ($responseJson.success -eq $true)
{
    Write-Host "DNS record $DnsName ID: $( $responseJson.result.id ) created successfully." -ForegroundColor Green
    Write-Host "Response: $responseJson"
    return $responseJson.result.id
}
else
{
    Write-Host "Failed to create DNS record $DnsName." -ForegroundColor Red
    Write-Host "Response: $( $response )"
    exit 1
}