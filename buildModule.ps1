[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet(
        "Release",
        "Debug"
    )]
    [string]$Configuration = "Debug"
)

$scriptRoot = $PSScriptRoot
$projFile = Join-Path -Path $scriptRoot -ChildPath "SmallsOnline.Azure.AVDSetup.csproj"

dotnet msbuild -target:"BuildPowerShellModule" -property:"Configuration=$($Configuration)" "$($projFile)"