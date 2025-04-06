$ErrorActionPreference = "Stop"

Write-Host "================================ Importing modules ================================"


Set-Location $PSScriptRoot
Import-Module $PSScriptRoot\CloudflareDnsTools\CloudflareDnsTools.psd1
Get-Command -Module CloudflareDnsTools

$tests = Get-ChildItem -Path "$PSScriptRoot/tests" -Filter "*.ps1"

foreach ($item in $tests)
{
    Write-Host $item.FullName
    Write-Host $item.Name
    Write-Host "================================ Run $( $item.Name ) =================================" -ForegroundColor DarkRed
    . $item.FullName
}