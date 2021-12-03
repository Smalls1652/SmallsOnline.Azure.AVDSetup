function New-AvdHostPoolTokenExpirationDate {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [datetime]$ExpirationDateTime = ([datetime]::Now.AddHours(6))
    )

    return $ExpirationDateTime.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffffffZ")
}