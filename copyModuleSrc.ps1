[CmdletBinding()]
param(
)

$writeInfoSplat = @{
    "InformationAction" = "Continue";
}

$scriptRoot = $PSScriptRoot

$buildOutPath = Join-Path -Path $scriptRoot -ChildPath "build\"
$moduleSrcPath = Join-Path -Path $scriptRoot -ChildPath "src\SmallsOnline.Azure.AVDSetup\"

Write-Information @writeInfoSplat -MessageData "- Copying module content"
Copy-Item -Path $moduleSrcPath -Destination $buildOutPath -Recurse