$ErrorActionPreference = "Stop"

$tests = Get-ChildItem -Path "$PSScriptRoot/tests" -Filter "*.ps1"

foreach ($item in $tests)
{
    Write-Host $item.FullName
    Write-Host $item.Name
    Write-Host "================================ Run $( $item.Name ) =================================" -ForegroundColor DarkRed
    . $item.FullName
}