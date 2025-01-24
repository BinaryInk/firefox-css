#!/usr/bin/env -S pwsh -NoProfile
using namespace System.Text

param(
    [Parameter(Position = 0)]
    [string]
    $Path = "$PSScriptRoot/sass/userChrome/_index.scss",

    [Parameter(Position = 1)]
    [string]
    $Destination = "$PSScriptRoot/userChrome.css",

    [Parameter()]
    [switch]
    $Watch,

    [Parameter()]
    [switch]
    $IncludeMaps,

    [Parameter()]
    [switch]
    $Beta
)

$iex = [StringBuilder]::new() 
if ($Beta) {
    $Destination = [System.IO.Path]::ChangeExtension($Destination, 'beta.css')
}
$iex.Append("/usr/bin/sass $Path $Destination ") | Out-Null
$Watch ? $iex.Append('--watch ') : $null | Out-Null
$IncludeMaps ? '--source-map ' : '--no-source-map ' | ForEach-Object { $iex.Append($_) | Out-Null }

Write-Debug "iex: $($iex.ToString())"
$iex.ToString() | Invoke-Expression
