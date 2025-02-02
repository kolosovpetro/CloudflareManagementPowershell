<#
.SYNOPSIS
    Retrieves a list of DNS records from a Cloudflare zone using the Cloudflare API.

.DESCRIPTION
    This script connects to the Cloudflare API and fetches all DNS records for a specified zone.
    It returns a hashtable where the DNS record names are the keys and their corresponding IDs are the values.

.PARAMETER ApiToken
    The Cloudflare API token with the necessary permissions to read DNS records.

.PARAMETER ZoneId
    The unique identifier of the Cloudflare zone from which to retrieve DNS records.

.EXAMPLE
    .\Get-CloudflareDnsRecords.ps1 -ApiToken "your_api_token" -ZoneId "your_zone_id"
    Retrieves all DNS records for the specified Cloudflare zone and returns them as a hashtable.

.NOTES
    - Ensure that your API token has permission to read DNS records.
    - The script requires PowerShell 5.1 or later.
    - Uses curl to fetch data from the Cloudflare API and ConvertFrom-Json to parse the response.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ApiToken,

    [Parameter(Mandatory = $true)]
    [string]$ZoneId
)

$ErrorActionPreference = "Stop"

$url = "https://api.cloudflare.com/client/v4/zones/$ZoneId/dns_records"

$response = $( curl -s -S $url -H "Authorization: Bearer $ApiToken" -H "Content-Type: application/json" )

$json = $response | ConvertFrom-Json

$dnsRecords = @{ }

$json.result | ForEach-Object {
    $dnsRecords[$_.name] = $_.id
}

return $dnsRecords
