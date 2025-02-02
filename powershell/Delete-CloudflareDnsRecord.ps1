param(
    [Parameter(Mandatory = $true)]
    [string]$ApiToken,

    [Parameter(Mandatory = $true)]
    [string]$ZoneId,

    [Parameter(Mandatory = $true)]
    [string]$RecordId

)

$ErrorActionPreference = "Stop"

$url = "https://api.cloudflare.com/client/v4/zones/$ZoneId/dns_records/$RecordId"

$response = curl $url `
    -X DELETE `
    -H "Authorization: Bearer $ApiToken" `
    -H "Content-Type: application/json"

$responseJson = $response | ConvertFrom-Json

if ($responseJson.success -eq $true)
{
    Write-Host "DNS record $RecordId deleted successfully."
    Write-Host "Response: $responseJson"
    return $responseJson.result.id
}
else
{
    Write-Host "Failed to delete DNS record $RecordId."
    Write-Host "Response: $( $response )"
    exit 1
}