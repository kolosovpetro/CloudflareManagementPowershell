<#
.SYNOPSIS
    Retrieves the ID of a Cloudflare zone by its name using the Cloudflare API.

.DESCRIPTION
    This script connects to the Cloudflare API and searches for a zone by its name.
    It returns the zone ID if the zone is found or outputs an error message if not.

.PARAMETER ApiToken
    The Cloudflare API token with the necessary permissions to read zone information.

.PARAMETER ZoneName
    The name of the Cloudflare zone for which the ID is being fetched.

.EXAMPLE
    .\Get-CloudflareZoneId.ps1 -ApiToken "your_api_token" -ZoneName "example.com"
    Retrieves the ID of the Cloudflare zone "example.com".

.NOTES
    - Ensure that your API token has permission to read zone information.
    - The script requires PowerShell 5.1 or later.
    - Uses curl to interact with the Cloudflare API and ConvertFrom-Json to parse the response.
#>


param (
    [Parameter(Mandatory = $true)]
    [string]$ApiToken,

    [Parameter(Mandatory = $true)]
    [string]$ZoneName
)

$ErrorActionPreference = "Stop"

$url = "https://api.cloudflare.com/client/v4/zones"

$response = $( curl -s -S $url -H "Authorization: Bearer $ApiToken" -H "Content-Type: application/json" )

$json = $response | ConvertFrom-Json

$zone = $json.result | Where-Object { $_.name -eq "$ZoneName" }

if ($zone)
{
    Write-Host "Zone $ZoneName with ID $( $zone.id ) fetched succesfully ..." -ForegroundColor Green
    return $zone.id
}
else
{
    Write-Output "Zone '$ZoneName' not found." -ForegroundColor Red
    exit 1
}



