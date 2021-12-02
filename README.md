# Azure Virtual Desktop host deployment

This PowerShell module is a work-in-progress automation tool I've been working on to provision new AVD session hosts from images in an Azure Compute Gallery.

**⚠️Warning:** This module requires PowerShell 7.2 or higher to use.

# Building from source

## Requirements

- .NET 6.0 SDK
  - [Download from here](https://dotnet.microsoft.com/download)
- PowerShell 7.2
  - [Instructions for Windows](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2)
  - [Instructions for macOS](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.2)
  - [Instructions for Linux](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2)

## Building

Open a CMD/PowerShell/Shell prompt and navigate to the folder of the cloned repo. Then run the following command:

```
dotnet msbuild -target:"BuildPowerShellModule" -property:"Configuration=Release" ".\SmallsOnline.Azure.AVDSetup.csproj"
```

The fully compiled module will be located in the `\build\` directory.