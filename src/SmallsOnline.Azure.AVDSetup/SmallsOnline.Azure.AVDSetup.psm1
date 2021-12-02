$scriptRoot = $PSScriptRoot

$libPath = Join-Path -Path $scriptRoot -ChildPath "lib\SmallsOnline.Azure.AVDSetup.Lib.dll"
$null = Add-Type -Path $libPath

$exportableFunctions = Get-ChildItem -Path (Join-Path -Path $scriptRoot -ChildPath "functions\") -Recurse | Where-Object { $PSItem.Extension -eq ".ps1" }
foreach ($item in $exportableFunctions) {
    . "$($item.FullName)"
}