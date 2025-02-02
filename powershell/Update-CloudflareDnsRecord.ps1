param (
    [Parameter(Mandatory = $true)]
    [string]$ApiToken,

    [Parameter(Mandatory = $true)]
    [string]$DnsName,

    [Parameter(Mandatory = $true)]
    [string]$ZoneId,

    [Parameter(Mandatory = $true)]
    [string]$RecordId,

    [Parameter(Mandatory = $true)]
    [string]$IpAddress,

    [Parameter(Mandatory = $true)]
    [string]$Comment
)

$ErrorActionPreference = "Stop"

$url = "https://api.cloudflare.com/client/v4/zones/$ZoneId/dns_records/$RecordId"

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

# Perform the API request
$response = curl $url `
    -X PATCH `
    -H "Authorization: Bearer $ApiToken" `
    -H "Content-Type: application/json" `
    -d $body

$responseJson = $response | ConvertFrom-Json

# Check the response
if ($responseJson.success -eq $true)
{
    Write-Host "DNS record $RecordId updated successfully."
    Write-Host "Response: $responseJson"
    return $responseJson.success
}
else
{
    Write-Host "Failed to update DNS record $RecordId."
    Write-Host "Response: $( $response )"
    exit 1
}

#.\Update-CloudflareDnsRecord.ps1 -ApiToken $env:CLOUDFLARE_API_KEY `
#	-DnsName "auth-eventtriangle.razumovsky.me" `
#	-ZoneId $zoneId `
#	-RecordId "98b014141c8d4bae0db9800617c04076" `
#	-IpAddress "172.205.36.169"
