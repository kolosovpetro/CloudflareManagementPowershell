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

Write-Host "Existing DNS records"
$existingDnsRecords

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
        $recordId = $existingDnsRecords[$dnsName]

        Write-Host "Found existing DNS record for $dnsName. Record ID: $recordId" -ForegroundColor Green
        Write-Host "Updating DNS record for $dnsName with IP Address: $ipAddress" -ForegroundColor Yellow

        try
        {
            .\Update-CloudflareDnsRecord.ps1 -ApiToken $ApiToken `
                -Comment $comment `
                -DnsName $dnsName `
                -ZoneId $zoneId `
                -RecordId $recordId `
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
