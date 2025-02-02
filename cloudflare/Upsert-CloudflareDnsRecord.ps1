<#
.SYNOPSIS
    Updates or creates Cloudflare DNS records based on a provided hashtable of DNS entries.

.DESCRIPTION
    This script updates existing DNS records for a given Cloudflare zone based on the provided DNS name and IP address.
    If the DNS record does not exist, it creates a new one. The script fetches the zone ID and existing DNS records from Cloudflare
    and uses separate scripts to update or insert DNS records.

.PARAMETER ApiToken
    The Cloudflare API token with the necessary permissions to manage DNS records.

.PARAMETER ZoneName
    The name of the Cloudflare zone for which DNS records need to be updated or created.

.PARAMETER NewDnsEntriesHashtable
    A hashtable containing DNS entries where the key is the DNS name and the value is the IP address.

.EXAMPLE
    .\Update-Or-Create-CloudflareDnsRecords.ps1 -ApiToken "your_api_token" -ZoneName "example.com" -NewDnsEntriesHashtable @{ "subdomain1.example.com" = "192.0.2.1"; "subdomain2.example.com" = "198.51.100.1" }
    Updates existing DNS records or creates new ones for "subdomain1.example.com" and "subdomain2.example.com" with the respective IP addresses.

.NOTES
    - Ensure that your API token has permission to manage DNS records.
    - The script requires PowerShell 5.1 or later.
    - Utilizes other PowerShell scripts such as `Get-CloudflareZoneId.ps1`, `Get-CloudflareDnsRecords.ps1`, `Update-CloudflareDnsRecord.ps1`, and `Insert-CloudflareDnsRecord.ps1`.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ApiToken,

    [Parameter(Mandatory = $true)]
    [string]$ZoneName,
    
    [Parameter(Mandatory = $true)]
    [Hashtable]$NewDnsEntriesHashtable
)

$ErrorActionPreference = "Stop"

Write-Host "Starting Cloudflare DNS Records Update Script..." -ForegroundColor Cyan
Write-Host "Fetching Zone ID for Zone Name: $ZoneName..." -ForegroundColor Yellow

$zoneId = $( ./Get-CloudflareZoneId.ps1 -ApiToken $ApiToken -ZoneName $ZoneName )

if (-not $zoneId)
{
    Write-Error "Failed to fetch Zone ID. Exiting script."
    exit 1
}

Write-Host "Zone ID Retrieved: $zoneId" -ForegroundColor Green

Write-Host "Fetching existing DNS records for Zone ID: $zoneId..." -ForegroundColor Yellow
$existingDnsRecords = $( .\Get-CloudflareDnsRecords.ps1 -ApiToken $ApiToken -ZoneId "$zoneId" )

Write-Host "Existing DNS records Count: $($existingDnsRecords.Count)"

if (-not $existingDnsRecords -or -not ($existingDnsRecords -is [hashtable]))
{
    Write-Error "Failed to fetch DNS records or records are not in the expected format. Exiting script."
    exit 1
}

Write-Host "DNS Records Retrieved: $( $existingDnsRecords.Count ) records found." -ForegroundColor Green

Write-Host "Fetching new DNS entries to update..." -ForegroundColor Yellow
Write-Host "New DNS entries: $NewDnsEntriesHashtable"

if (-not $NewDnsEntriesHashtable -or -not ($NewDnsEntriesHashtable -is [hashtable]))
{
    Write-Error "Failed to fetch new DNS entries or entries are not in the expected format. Exiting script."
    exit 1
}

Write-Host "New DNS Entries Retrieved: $( $NewDnsEntriesHashtable.Count ) entries to process." -ForegroundColor Green

Write-Host "Starting to process new DNS entries..." -ForegroundColor Cyan

$comment = "Sent from PowerShell $( $( Get-Date ).DateTime )"

foreach ($entry in $NewDnsEntriesHashtable.GetEnumerator())
{
    $dnsName = $entry.Name
    $ipAddress = $entry.Value

    Write-Host "`nProcessing Entry: $dnsName => $ipAddress" -ForegroundColor Cyan

    if ( $existingDnsRecords.ContainsKey($dnsName))
    {
        Write-Host "Found existing DNS record for $dnsName. Record ID: $recordId" -ForegroundColor Green
        Write-Host "Updating DNS record for $dnsName with IP Address: $ipAddress" -ForegroundColor Yellow

        try
        {
            .\Update-CloudflareDnsRecord.ps1 -ApiToken $ApiToken `
                -Comment $comment `
                -DnsName $dnsName `
                -ZoneId $zoneId `
                -IpAddress $ipAddress

            Write-Host "Successfully updated DNS record for $dnsName." -ForegroundColor Green
        }
        catch
        {
            Write-Error "Failed to update DNS record for $dnsName. Error: $_"
        }
    }
    else
    {
        Write-Host "DNS name $dnsName does not exist in Cloudflare. Creating it ..." -ForegroundColor Yellow

        .\Insert-CloudflareDnsRecord.ps1 -ApiToken $env:CLOUDFLARE_API_KEY `
	        -Comment $comment `
	        -DnsName $dnsName `
	        -ZoneId $zoneId `
	        -IpAddress $ipAddress
    }
}

Write-Host "`nDNS records update process completed successfully!" -ForegroundColor Green
