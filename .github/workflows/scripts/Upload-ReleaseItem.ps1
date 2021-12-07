[CmdletBinding()]
param(
    [Parameter(Position = 0, Mandatory)]
    [string]$Token,
    [Parameter(Position = 1, Mandatory)]
    [string]$Name
)

$commonSplat = @{
    "Authentication" = "OAuth";
    "Token"          = (ConvertTo-SecureString -String $Token -AsPlainText -Force);
    "ErrorAction"    = "Stop";
}

$releaseId = (Invoke-RestMethod @commonSplat -Method "Get" -Uri $env:TAG_RELEASE_API)[0].id

Write-Information -InformationAction "Continue" -MessageData $releaseId

Write-Information -InformationAction "Continue" -MessageData "$($env:RELEASE_API_URI)/$($releaseId)/assets?name=$($Name)"

Invoke-RestMethod @commonSplat -Method "Post" -Uri "$($env:RELEASE_API_URI)/$($releaseId)/assets?name=$($Name)" -ContentType "application/zip" -InFile "./build/SmallsOnline.Azure.AVDSetup.zip"