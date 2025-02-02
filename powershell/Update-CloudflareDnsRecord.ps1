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

Write-Host "Checking existing DNS records ..."

$existingDnsRecords = $( .\Get-CloudflareDnsRecords.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneId "$zoneId" )

Write-Host "Existing DNS records count: $( $existingDnsRecords.Count )"

$recordExists = $existingDnsRecords.ContainsKey($DnsName)

Write-Host "Record $DnsName exists already: $recordExists"

if ($recordExists -eq $False)
{
    Write-Host "Record $DnsName does not exist. Skipping update ..."
    exit 0
}

$recordId = $existingDnsRecords[$DnsName]

Write-Host "Record to update: $recordId"

$url = "https://api.cloudflare.com/client/v4/zones/$ZoneId/dns_records/$recordId"

$response = curl $url `
    -X PATCH `
    -H "Authorization: Bearer $ApiToken" `
    -H "Content-Type: application/json" `
    -d $body

$responseJson = $response | ConvertFrom-Json

# Check the response
if ($responseJson.success -eq $true)
{
    Write-Host "DNS record $recordId updated successfully."
    Write-Host "Response: $responseJson"
    return $responseJson.success
}
else
{
    Write-Host "Failed to update DNS record $recordId."
    Write-Host "Response: $( $response )"
    exit 1
}

#.\Update-CloudflareDnsRecord.ps1 -ApiToken $env:CLOUDFLARE_API_KEY `
#	-DnsName "auth-eventtriangle.razumovsky.me" `
#	-ZoneId $zoneId `
#	-IpAddress "172.205.36.169"
