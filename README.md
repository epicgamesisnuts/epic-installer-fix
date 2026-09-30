# Epic Games Installer Fix (Error 1714 / 1612)
or also the file d36fcc10-a805-47ce-924f-9be09c8ea60f_8cfbad219c that epic game cannot find
If you are trying to install the Epic Games Launcher and getting stuck on "Error 1714: Cannot remove older version" or "System Error 1612", this script is for you. 

This usually happens because Windows thinks an older version of Epic is still installed (often due to WinGet or deleted temporary cache folders), but it can't find the original `.msi` file to uninstall it. This script hunts down those hidden registry keys and wipes them out so you can do a clean install.

## What it clears:
* Leftover Epic Games registry keys in Uninstall paths.
* Corrupted installer product caches.
* The broken master Upgrade Code (`44F9670D954DF0540B48AC3E08267CB5`) that causes the 1714 loop.

## How to use it:
1. Download `Fix-Epic-Installer.ps1`.
2. Right-click the file and select **Run with PowerShell** (Make sure to run it as **Administrator**).
3. Once it finishes, run your fresh `EpicInstaller.msi` again.
