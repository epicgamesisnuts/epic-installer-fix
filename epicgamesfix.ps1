<#
.SYNOPSIS
  Fixes Epic Games Launcher Error 1714 / System Error 1612 by purging ghost registry hooks.
.DESCRIPTION
  This script targets corrupted MSI Upgrade Codes and Product GUIDs that block fresh installations.
#>

# Check for Administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as an Administrator!"
    Exit
}

Write-Host "Starting the Epic Games Installer Registry Purge..." -ForegroundColor Cyan

# 1. Clean standard uninstall registry paths
$Paths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)

foreach ($Path in $Paths) {
    if (Test-Path $Path) {
        Get-ChildItem -Path $Path | Where-Object { $_.GetValue("DisplayName") -like "*Epic Games*" } | ForEach-Object {
            Write-Host "Removing registry key: $($_.Name)" -ForegroundColor Yellow
            Remove-Item -Path $_.PSPath -Force -Recurse
        }
    }
}

# 2. Clean corrupted Products cache
Get-ChildItem -Path "HKLM:\SOFTWARE\Classes\Installer\Products" | Where-Object { $_.GetValue("ProductName") -like "*Epic Games*" } | ForEach-Object {
    Write-Host "Removing product cache: $($_.Name)" -ForegroundColor Yellow
    Remove-Item -Path $_.PSPath -Force -Recurse
}

# 3. Purge the specific master Upgrade Code causing Error 1714
$UpgradeCodePath = "HKLM:\SOFTWARE\Classes\Installer\UpgradeCodes\44F9670D954DF0540B48AC3E08267CB5"
if (Test-Path $UpgradeCodePath) {
    Write-Host "Purging master Upgrade Code block..." -ForegroundColor Yellow
    Remove-Item -Path $UpgradeCodePath -Force -Recurse
}

Write-Host "Registry clean up complete! You can now run EpicInstaller.msi cleanly." -ForegroundColor Green
