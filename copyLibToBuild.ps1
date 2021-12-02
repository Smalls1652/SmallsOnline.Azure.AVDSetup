[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet(
        "Release",
        "Debug"
    )]
    [string]$Configuration = "Debug"
)

$writeInfoSplat = @{
    "InformationAction" = "Continue";
}

$scriptRoot = $PSScriptRoot

$buildOutPath = Join-Path -Path $scriptRoot -ChildPath "build\"
$buildOutModulePath = Join-Path -Path $buildOutPath -ChildPath "SmallsOnline.Azure.AVDSetup\"

$librarySrcPath = Join-Path -Path $scriptRoot -ChildPath "src\SmallsOnline.Azure.AVDSetup.Lib\"
$librarySrcPublishPath = Join-Path -Path $librarySrcPath -ChildPath "bin\$($Configuration)\net6.0\publish\"

Write-Information @writeInfoSplat -MessageData "- Creating lib folder in module's build directory"
$moduleDependenciesDir = New-Item -Path $buildOutModulePath -ItemType "Directory" -Name "lib"

Write-Information @writeInfoSplat -MessageData "- Copying compiled library files"
$compiledLibraryFiles = Get-ChildItem -Path $librarySrcPublishPath
foreach ($fileItem in $compiledLibraryFiles) {
    Write-Information @writeInfoSplat -MessageData "`t| $($fileItem.Name) -> $($moduleDependenciesDir.FullName)"
    Copy-Item -Path $fileItem.FullName -Destination $moduleDependenciesDir.FullName
}