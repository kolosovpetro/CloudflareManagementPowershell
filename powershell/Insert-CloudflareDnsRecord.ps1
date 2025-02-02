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

Write-Host "Json body: $body"

$existingDnsRecords = $( .\Get-CloudflareDnsRecords.ps1 -ApiToken $env:CLOUDFLARE_API_KEY -ZoneId "$zoneId" )

Write-Host "Existing DNS records count: $( $existingDnsRecords.Count )"

$recordExists = $existingDnsRecords.ContainsKey($dnsName)

Write-Host "Record $DnsName exists already: $recordExists"

if ($recordExists -eq $True)
{
    Write-Host "Record $DnsName exists already. Skipping"
    exit 0
}

$response = curl $url `
    -X POST `
    -H "Authorization: Bearer $ApiToken" `
    -H "Content-Type: application/json" `
    -d $body

$responseJson = $response | ConvertFrom-Json

if ($responseJson.success -eq $true)
{
    Write-Host "DNS record $( $responseJson.result.id ) created successfully."
    Write-Host "Response: $responseJson"
    return $responseJson.result.id
}
else
{
    Write-Host "Failed to create DNS record."
    Write-Host "Response: $( $response )"
    exit 1
}