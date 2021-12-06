function Register-AvdSessionHost {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory)]
        [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachine]$VM,
        [Parameter(Position = 1, Mandatory)]
        [string]$RegistrationTokenString
    )

    $scriptRoot = $PSScriptRoot
    $invokeAgentSetupScriptPath = [System.IO.Path]::GetFullPath("..\..\runCommand_scripts\Invoke-AvdAgentSetup.ps1", $scriptRoot)

    $runJob = Invoke-AzVMRunCommand -VM $VM -CommandId "RunPowerShellScript" -ScriptPath $invokeAgentSetupScriptPath -Parameter @{ "RegistrationToken" = $RegistrationTokenString; } -AsJob

    return $runJob
}