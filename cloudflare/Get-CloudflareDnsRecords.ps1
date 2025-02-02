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
