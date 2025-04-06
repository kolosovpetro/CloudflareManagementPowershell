@{
    RootModule = 'CloudflareDnsTools.psm1'
    ModuleVersion = '1.0.0'
    GUID = '71aaf224-afd5-4589-a310-c6248b0f1bf8'
    Author = 'Petro Kolosov'
    CompanyName = 'github.com/kolosovpetro/CloudflareManagementPowershell'
    Description = 'Manages DNS records using Cloudflare API.'
    PowerShellVersion = '7.0'
    FunctionsToExport = @(
        'Get-CloudflareZoneId',
        'Get-CloudflareDnsRecords',
        'Add-CloudflareDnsRecord',
        'Remove-CloudflareDnsRecord',
        'Update-CloudflareDnsRecord',
        'Set-CloudflareDnsRecord'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
}
