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



