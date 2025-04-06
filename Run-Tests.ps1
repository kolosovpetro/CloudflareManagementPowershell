$ErrorActionPreference = "Stop"

Write-Host "================================ Importing modules ================================"


Set-Location $PSScriptRoot
Install-Module -Name CloudflareDnsTools -Force -AllowClobber
Get-Command -Module CloudflareDnsTools

$tests = Get-ChildItem -Path "$PSScriptRoot/tests" -Filter "*.ps1"

foreach ($item in $tests)
{
    Write-Host $item.FullName
    Write-Host $item.Name
    Write-Host "================================ Run $( $item.Name ) =================================" -ForegroundColor DarkRed
    . $item.FullName
}