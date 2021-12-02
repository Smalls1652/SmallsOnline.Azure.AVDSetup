function Import-AvdSetupConfigFile {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory)]
        [string]$FilePath
    )

    try {
        $filePathResolved = (Resolve-Path -Path $FilePath -ErrorAction "Stop").Path
    }
    catch {
        $errorDetails = $PSItem
        $PSCmdlet.ThrowTerminatingError($errorDetails)
    }

    $fileItem = Get-Item -Path $filePathResolved
    if ($fileItem.Extension -ne ".json") {
        $PSCmdlet.ThrowTerminatingError(
            [System.Management.Automation.ErrorRecord]::new(
                [System.IO.FileFormatException]::new("The file format of the specified file is not a JSON file."),
                "InvalidInputFile",
                [System.Management.Automation.ErrorCategory]::InvalidData,
                $fileItem
            )
        )
    }

    if ($PSCmdlet.ShouldProcess($fileItem.FullName, "Import config file")) {
        $importedConfig = [SmallsOnline.Azure.AVDSetup.Lib.Models.ConfigFile]::new(
            $fileItem.FullName,
            [SmallsOnline.Azure.AVDSetup.Lib.Models.JsonInputType]::FilePath
        )

        Write-Output -InputObject $importedConfig
    }
}