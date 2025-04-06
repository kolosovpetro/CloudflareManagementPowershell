$zoneName = "razumovsky.me"

$newDnsEntriesHashtable = @{ }

$newDnsEntriesHashtable["new-dns-record1.$zoneName"] = "172.205.36.170"
$newDnsEntriesHashtable["new-dns-record2.$zoneName"] = "172.205.36.171"
$newDnsEntriesHashtable["new-dns-record3.$zoneName"] = "172.205.36.172"

Set-CloudflareDnsRecord `
    -ApiToken $env:CLOUDFLARE_API_KEY `
    -ZoneName $zoneName `
    -NewDnsEntriesHashtable $newDnsEntriesHashtable