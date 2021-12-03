function New-AvdHost {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0, Mandatory, ParameterSetName = "DirectConfigFile")]
        [ValidateNotNullOrEmpty()]
        [SmallsOnline.Azure.AVDSetup.Lib.Models.ConfigFile]$Config,
        [Parameter(Position = 0, Mandatory, ParameterSetName = "ConfigFilePath")]
        [ValidateNotNullOrEmpty()]
        [string]$ConfigFilePath
    )

    $configItem = $null
    switch ($PSCmdlet.ParameterSetName) {
        "ConfigFilePath" {
            $configItem = Import-AvdSetupConfigFile -FilePath $ConfigFilePath -ErrorAction "Stop" -WhatIf:$false
            break
        }

        Default {
            $configItem = $Config
            break
        }
    }

    $vnet = Get-AzVirtualNetwork -ResourceGroupName $configItem.VirtualNetworkConfig.ResourceGroupName -Name $configItem.VirtualNetworkConfig.Name
    $vnetSubnet = $vnet | Get-AzVirtualNetworkSubnetConfig -Name $configItem.VirtualNetworkConfig.SubnetName

    $avdImageGallery = Get-AzGallery -ResourceGroupName $configItem.GalleryConfig.ResourceGroupName -Name $configItem.GalleryConfig.GalleryName
    $avdSelectedImage = Get-AzGalleryImageVersion -ResourceGroupName $avdImageGallery.ResourceGroupName -GalleryName $avdImageGallery.Name -GalleryImageDefinitionName $configItem.GalleryConfig.ImageDefinitionName -Name $configItem.GalleryConfig.ImageDefinitionVersion

    $vmSecretItemLocalAdmin = ($configItem.SecretItems | Where-Object { $PSItem.Type -eq [SmallsOnline.Azure.AVDSetup.Lib.Models.Config.SecretItemType]::LocalAdmin })[0]
    $vmSecretItemDomainJoiner = ($configItem.SecretItems | Where-Object { $PSItem.Type -eq [SmallsOnline.Azure.AVDSetup.Lib.Models.Config.SecretItemType]::DomainJoiner })[0]

    $vmLocalAdminCreds = Get-Secret -Vault $vmSecretItemLocalAdmin.VaultName -Name $vmSecretItemLocalAdmin.Name
    $vdiJoinerCreds = Get-Secret -Vault $vmSecretItemDomainJoiner.VaultName -Name $vmSecretItemDomainJoiner.Name

    Write-Verbose "Generating possible list of VM names."
    $possibleVmNames = for ($i = 0; $i -le 1000; $i++) {
        "$($configItem.VMConfig.HostNamePrefix)-$($i.ToString("00"))"
    }

    Write-Verbose "Determining what the VM name should be."
    $currentVmsCreated = Get-AzVM -ResourceGroupName $configItem.VMConfig.ResourceGroupName | Where-Object { ($PSItem.Name -like "$($configItem.VMConfig.HostNamePrefix)-*") }
    $currentVmsCreated = $currentVmsCreated | Where-Object { ($PSItem.Name -ne "$($configItem.VMConfig.HostNamePrefix)-image") -and ($PSItem.Name -ne "$($configItem.VMConfig.HostNamePrefix)-template") }
    $firstAvailableVmName = ($possibleVmNames | Where-Object { $PSItem -notin $currentVmsCreated.Name })[0]

    $vmHostName = $firstAvailableVmName
    $vmNicName = "$($vmHostName)_nic"
    Write-Verbose "VM hostname will be: $($vmHostName)"

    if ($PSCmdlet.ShouldProcess("$($vmHostName)/VM config", "Create")) {
        $vmConfig = New-AzVMConfig -VMName $vmHostName -VMSize $configItem.VMConfig.Size
    }

    if ($PSCmdlet.ShouldProcess($vmNicName, "Create")) {
        $vmNic = New-AzNetworkInterface -ResourceGroupName $configItem.VMConfig.ResourceGroupName -Name $vmNicName -Location $configItem.VMConfig.Location -Subnet $vnetSubnet
    }

    if ($PSCmdlet.ShouldProcess("$($vmHostName)/VM config", "Add network interface")) {
        $vmConfig = Add-AzVMNetworkInterface -VM $vmConfig -NetworkInterface $vmNic
    }

    if ($PSCmdlet.ShouldProcess("$($vmHostName)/VM config", "Set OS disk to use gallery image")) {
        $vmConfig = Set-AzVMSourceImage -VM $vmConfig -Id $avdSelectedImage.Id
    }

    if ($PSCmdlet.ShouldProcess("$($vmHostName)/VM config", "Set OS settings")) {
        $vmConfig = Set-AzVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmHostName -Credential $vmLocalAdminCreds -PatchMode "Manual" -EnableAutoUpdate:$false -ProvisionVMAgent
    }

    if ($PSCmdlet.ShouldProcess("$($vmHostName)/VM config", "Disabling boot diagnostics config")) {
        $vmConfig = Set-AzVMBootDiagnostic -VM $vmConfig -Disable
    }

    if ($PSCmdlet.ShouldProcess($vmHostName, "Create VM")) {
        $null = New-AzVM -VM $vmConfig -ResourceGroupName $configItem.VMConfig.ResourceGroupName -Location $configItem.VMConfig.Location -DisableBginfoExtension -ErrorAction "Stop"
    }

    if ($PSCmdlet.ShouldProcess($vmHostName, "Join to $($configItem.ActiveDirectoryConfig.DomainName) domain")) {
        $null = Set-AzVMADDomainExtension -ResourceGroupName $configItem.VMConfig.ResourceGroupName -VMName $vmHostName -Name "JoinVmToDomainExtension" -DomainName $configItem.ActiveDirectoryConfig.DomainName -OUPath $configItem.ActiveDirectoryConfig.OrganizationalUnitPath -Credential $vdiJoinerCreds -JoinOption 3 -Restart
    }

    if ($PSCmdlet.ShouldProcess("Output", "Write created VM")) {
        $createdVM = Get-AzVM -ResourceGroupName $configItem.VMConfig.ResourceGroupName -Name $vmHostName
        Write-Output -InputObject $createdVM
    }
}