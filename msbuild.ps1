<#
.SYNOPSIS
Run MSBuild out of a Developer PowerShell

.NOTES
241117

.NOTES
Install-Module -Scope CurrentUser VSSetup

.NOTES
For .NET projects, see a modern way (but there're some different) from https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-msbuild

#>
param (
    [Parameter(Position=0)]
    [string]$Project,

    [string]$Target,
    [switch]$ReleaseBuild,

    [switch]$Clean,
    [switch]$V,
    [switch]$VV
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

if ('' -eq [string]$Project) {
    $Project = "."
}
$Project = Resolve-Path -LiteralPath $Project
if (Test-Path -PathType Container $Project) {
    $ProjectDir = $Project
    $Project = "."
}
else {
    $ProjectDir = [IO.Path]::GetDirectoryName($Project)
    $Project = [IO.Path]::GetFileName($Project)
}

if ('' -eq [string]$Target) {
    $Target = "Build"
}
$Targets = $Target.Split(',')
if ($Clean) {
    $Targets = @("Clean") + $Targets
}

$BuildProfile = @{
    Target = [string]::Join(',', $Targets);
    Configuration = ($ReleaseBuild ? "Release": "Debug");
    # Platform = "AnyCPU";
    Platform = "x64";
    MaxCpuCount = 4;
}

# -Prerelease if needed
$vsInstance = Get-VSSetupInstance | Select-Object -First 1
if ($null -eq $vsInstance) {
    Write-Error 'Failed to Get-VSSetupInstance'
    exit(1)
}

# not work by now
# see: https://github.com/dotnet/msbuild/issues/1596
$env:DOTNET_CLI_UI_LANGUAGE = "en-US"
$env:PreferredUILang = "en-US"
$env:VSLANG = "1033"
# chcp 65001

Push-Location $ProjectDir
try {
    $exeArgs = @(
        $Project,
        "/NoLogo",
        "/t:$($BuildProfile.Target)",
        "/p:Configuration=$($BuildProfile.Configuration)",
        "/p:Platform=$($BuildProfile.Platform)",
        "/MaxCpuCount:$($BuildProfile.MaxCpuCount)"
    )

    if ($VV) {
        $exeArgs += "/verbosity:diag"
    }
    elseif ($V) {
        $exeArgs += "/verbosity:detailed"
    }

    if ($env:PROCESSOR_ARCHITECTURE -ieq 'AMD64') {
        # Hostx64
        & "$($vsInstance.InstallationPath)\MSBuild\Current\Bin\amd64\MSBuild.exe" @exeArgs @args
    }
    else {
        # Hostx86
        & "$($vsInstance.InstallationPath)\MSBuild\Current\Bin\MSBuild.exe" @exeArgs @args
    }
}
finally {
    Pop-Location
}
