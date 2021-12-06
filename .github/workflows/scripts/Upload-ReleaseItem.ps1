[CmdletBinding()]
param(
    [Parameter(Position = 0, Mandatory)]
    [string]$Token,
    [Parameter(Position = 1, Mandatory)]
    [string]$Name
)

$apiHeaders = @{
    "Authorization" = "Bearer $($Token)";
}

$releaseId = (Invoke-RestMethod -Method "Get" -Headers $apiHeaders -Uri $env:TAG_RELEASE_API)[0].id

Write-Verbose $releaseId

Write-Verbose "$($env:RELEASE_API_URI)/$($releaseId)/assets?name=$($Name)"

Invoke-RestMethod -Method "Post" -Uri "$($env:RELEASE_API_URI)/$($releaseId)/assets?name=$($Name)" -ContentType "application/zip" -Headers $apiHeaders -InFile "./build/SmallsOnline.Azure.AVDSetup.zip" -Verbose -ErrorAction "Stop"