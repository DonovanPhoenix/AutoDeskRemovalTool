#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Comprehensive Autodesk Complete Removal Tool for Windows
.DESCRIPTION
    This script safely and thoroughly removes all Autodesk software, services, files, 
    directories, registry entries, shortcuts, and firewall rules from Windows systems.
.NOTES
    Author: System Administrator
    Version: 2.0
    Date: July 5, 2025
    Requires: PowerShell 5.1+ and Administrator privileges
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$NoRestart,
    [switch]$SkipRestorePoint
)

# Set strict mode for better error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

# Color definitions for output
$Colors = @{
    Header = "Cyan"
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
    Info = "White"
    Prompt = "Magenta"
}

function Write-ColoredOutput {
    param(
        [string]$Message,
        [string]$Color = "White",
        [switch]$NoNewline
    )
    if ($NoNewline) {
        Write-Host $Message -ForegroundColor $Color -NoNewline
    } else {
        Write-Host $Message -ForegroundColor $Color
    }
}

function Write-Header {
    param([string]$Title)
    Write-ColoredOutput "============================================" -Color $Colors.Header
    Write-ColoredOutput "    $Title" -Color $Colors.Header
    Write-ColoredOutput "============================================" -Color $Colors.Header
}

function Test-AdminPrivileges {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-SystemSafety {
    Write-ColoredOutput "Performing system safety checks..." -Color $Colors.Info
    
    # Check if running as administrator
    if (-not (Test-AdminPrivileges)) {
        Write-ColoredOutput "ERROR: This script must be run as Administrator!" -Color $Colors.Error
        Write-ColoredOutput "Please right-click PowerShell and select 'Run as administrator'" -Color $Colors.Error
        return $false
    }

    # Check if this is a domain controller
    try {
        $domainRole = (Get-WmiObject -Class Win32_ComputerSystem).DomainRole
        if ($domainRole -eq 4 -or $domainRole -eq 5) {
            Write-ColoredOutput "ERROR: This appears to be a Domain Controller!" -Color $Colors.Error
            Write-ColoredOutput "This script should not be run on Domain Controllers." -Color $Colors.Error
            return $false
        }
    } catch {
        Write-ColoredOutput "Warning: Could not determine domain role" -Color $Colors.Warning
    }

    # Check if this is a Windows Server
    $osInfo = Get-WmiObject -Class Win32_OperatingSystem
    if ($osInfo.ProductType -ne 1) {
        Write-ColoredOutput "WARNING: This appears to be a Windows Server!" -Color $Colors.Warning
        Write-ColoredOutput "Running this script on a server may affect other users." -Color $Colors.Warning
        if (-not $Force) {
            $response = Read-Host "Are you sure you want to continue? (Y/N)"
            if ($response -ne "Y" -and $response -ne "y") {
                Write-ColoredOutput "Operation cancelled by user." -Color $Colors.Info
                return $false
            }
        }
    }

    # Check available disk space (need at least 1GB free)
    $drive = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq "C:" }
    if ($drive.FreeSpace -lt 1GB) {
        Write-ColoredOutput "WARNING: Low disk space detected!" -Color $Colors.Warning
        Write-ColoredOutput "You have less than 1GB free space on C: drive." -Color $Colors.Warning
        Write-ColoredOutput "This may cause issues during cleanup." -Color $Colors.Warning
        if (-not $Force) {
            $response = Read-Host "Do you want to continue? (Y/N)"
            if ($response -ne "Y" -and $response -ne "y") {
                Write-ColoredOutput "Operation cancelled by user." -Color $Colors.Info
                return $false
            }
        }
    }

    return $true
}

function New-SystemRestorePoint {
    if ($SkipRestorePoint) {
        Write-ColoredOutput "Skipping system restore point creation (as requested)." -Color $Colors.Warning
        return $true
    }

    Write-ColoredOutput "Creating system restore point for safety..." -Color $Colors.Info
    Write-ColoredOutput "This may take a few minutes..." -Color $Colors.Info
    
    try {
        # Enable System Restore if not already enabled
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        
        # Create restore point
        $restorePointName = "Before Autodesk Removal - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        Checkpoint-Computer -Description $restorePointName -RestorePointType "APPLICATION_INSTALL"
        
        Write-ColoredOutput "System restore point created successfully!" -Color $Colors.Success
        return $true
    } catch {
        Write-ColoredOutput "WARNING: Could not create system restore point." -Color $Colors.Warning
        Write-ColoredOutput "This may be because System Restore is disabled." -Color $Colors.Warning
        Write-ColoredOutput "Error: $($_.Exception.Message)" -Color $Colors.Warning
        
        if (-not $Force) {
            $response = Read-Host "Do you want to continue anyway? (Y/N)"
            if ($response -ne "Y" -and $response -ne "y") {
                Write-ColoredOutput "Operation cancelled by user." -Color $Colors.Info
                return $false
            }
        }
        return $true
    }
}

function Show-SafetyWarnings {
    Write-ColoredOutput ""
    Write-ColoredOutput "SAFETY WARNINGS:" -Color $Colors.Warning
    Write-ColoredOutput "- A system restore point has been created (if possible)" -Color $Colors.Warning
    Write-ColoredOutput "- This script will make extensive changes to your system" -Color $Colors.Warning
    Write-ColoredOutput "- Make sure you have backups of important data" -Color $Colors.Warning
    Write-ColoredOutput "- Close all applications before proceeding" -Color $Colors.Warning
    Write-ColoredOutput "- The system will need to be restarted after completion" -Color $Colors.Warning
    Write-ColoredOutput ""
    
    if (-not $Force) {
        Write-ColoredOutput "Press any key to continue or Ctrl+C to cancel..." -Color $Colors.Prompt
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

function Stop-AutodeskServices {
    Write-ColoredOutput "Stopping Autodesk services..." -Color $Colors.Info
    
    # Dynamically find all Autodesk Material Library services (future-proof for new years)
    $materialLibraryServices = Get-Service | Where-Object { $_.DisplayName -like "Autodesk Material Library*" } | Select-Object -ExpandProperty Name

    $services = @(
        "FlexNet Licensing Service 64",
        "AdskLicensingService",
        "Autodesk Desktop App Service",
        "Autodesk Single Sign On Service",
        "Autodesk Genuine Service"
    ) + $materialLibraryServices
    
    foreach ($serviceName in $services | Sort-Object -Unique) {
        try {
            $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
            if ($service) {
                Write-ColoredOutput "Stopping service: $serviceName" -Color $Colors.Info
                Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
                
                # Try to delete the service
                & sc.exe delete $serviceName 2>$null
            }
        } catch {
            Write-ColoredOutput "Could not stop service: $serviceName" -Color $Colors.Warning
        }
    }
}

function Stop-AutodeskProcesses {
    Write-ColoredOutput "Stopping Autodesk processes..." -Color $Colors.Info
    
    # First stop explorer temporarily
    try {
        Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    } catch {
        Write-ColoredOutput "Could not stop explorer temporarily" -Color $Colors.Warning
    }
    
    $processes = @(
        "lmgrd", "adskflex", "AcEventSync", "AcQMod", "AdskLicensingAgent",
        "autocad", "acad", "AdskAccessServiceHost", "AdskIdentityManager",
        "AdApplicationManager", "AdskLicensingService", "DesktopApp",
        "inventor", "3dsmax", "maya", "revit", "fusion360", "AdskAccessCore",
        "AdskAccessCoreService", "CAMDuctPostProcess", "ConnectivityUtility",
        "FusionWebHelperService", "AdGenuineService", "msiexec", "setup",
        "install", "uninstall", "uninst", "InstallShield", "InstallAgent",
        # Additional Autodesk products
        "civil3d", "navisworks", "alias", "vault", "advancesteel", "infraworks",
        "recap", "plant3d", "robot", "moldflow", "powermill", "powerinspect",
        "powershape", "flame", "smoke", "motionbuilder", "mudbox", "characterGenerator",
        "sketchbook", "eagle", "bim360", "formit", "structuralbridge", "structuraldetailing"
    )
    
    foreach ($processName in $processes | Sort-Object -Unique) {
        try {
            $runningProcesses = Get-Process -Name $processName -ErrorAction SilentlyContinue
            if ($runningProcesses) {
                Write-ColoredOutput "Stopping process: $processName" -Color $Colors.Info
                $runningProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
            }
        } catch {
            # Process might not be running, which is fine
        }
    }
    
    # Stop processes in Autodesk directories (expanded for more products)
    try {
        $allProcesses = Get-WmiObject -Class Win32_Process | Where-Object { 
            $_.ExecutablePath -and 
            (
                $_.ExecutablePath -like "*autodesk*" -or 
                $_.ExecutablePath -like "*autocad*" -or 
                $_.ExecutablePath -like "*inventor*" -or 
                $_.ExecutablePath -like "*maya*" -or 
                $_.ExecutablePath -like "*3dsmax*" -or 
                $_.ExecutablePath -like "*revit*" -or 
                $_.ExecutablePath -like "*fusion*" -or 
                $_.ExecutablePath -like "*adsk*" -or
                $_.ExecutablePath -like "*civil3d*" -or
                $_.ExecutablePath -like "*navisworks*" -or
                $_.ExecutablePath -like "*alias*" -or
                $_.ExecutablePath -like "*vault*" -or
                $_.ExecutablePath -like "*advancesteel*" -or
                $_.ExecutablePath -like "*infraworks*" -or
                $_.ExecutablePath -like "*recap*" -or
                $_.ExecutablePath -like "*plant3d*" -or
                $_.ExecutablePath -like "*robot*" -or
                $_.ExecutablePath -like "*moldflow*" -or
                $_.ExecutablePath -like "*powermill*" -or
                $_.ExecutablePath -like "*powerinspect*" -or
                $_.ExecutablePath -like "*powershape*" -or
                $_.ExecutablePath -like "*flame*" -or
                $_.ExecutablePath -like "*smoke*" -or
                $_.ExecutablePath -like "*motionbuilder*" -or
                $_.ExecutablePath -like "*mudbox*" -or
                $_.ExecutablePath -like "*characterGenerator*" -or
                $_.ExecutablePath -like "*sketchbook*" -or
                $_.ExecutablePath -like "*eagle*" -or
                $_.ExecutablePath -like "*bim360*" -or
                $_.ExecutablePath -like "*formit*" -or
                $_.ExecutablePath -like "*structuralbridge*" -or
                $_.ExecutablePath -like "*structuraldetailing*"
            )
        }
        
        foreach ($process in $allProcesses) {
            try {
                Write-ColoredOutput "Killing process from Autodesk directory: $($process.Name)" -Color $Colors.Info
                Stop-Process -Id $process.ProcessId -Force -ErrorAction SilentlyContinue
            } catch {
                Write-ColoredOutput "Could not stop process: $($process.Name)" -Color $Colors.Warning
            }
        }
    } catch {
        Write-ColoredOutput "Could not enumerate processes in Autodesk directories" -Color $Colors.Warning
    }
    
    # Restart explorer
    try {
        Start-Process -FilePath "explorer.exe" -ErrorAction SilentlyContinue
    } catch {
        Write-ColoredOutput "Could not restart explorer" -Color $Colors.Warning
    }
}

function Invoke-OfficialUninstallers {
    Write-ColoredOutput "Running official Autodesk uninstall tools..." -Color $Colors.Info
    
    # Run RemoveODIS.exe
    $removeODISPath = "C:\Program Files\Autodesk\AdODIS\V1\RemoveODIS.exe"
    if (Test-Path $removeODISPath) {
        Write-ColoredOutput "Running RemoveODIS.exe..." -Color $Colors.Info
        try {
            Start-Process -FilePath $removeODISPath -ArgumentList "/S" -Wait -ErrorAction SilentlyContinue
        } catch {
            Write-ColoredOutput "Could not run RemoveODIS.exe" -Color $Colors.Warning
        }
    }
    
    # Run AdskLicensing uninstall.exe
    $adskLicensingPath = "C:\Program Files (x86)\Common Files\Autodesk Shared\AdskLicensing\uninstall.exe"
    if (Test-Path $adskLicensingPath) {
        Write-ColoredOutput "Running AdskLicensing uninstall.exe..." -Color $Colors.Info
        try {
            Start-Process -FilePath $adskLicensingPath -ArgumentList "/S" -Wait -ErrorAction SilentlyContinue
        } catch {
            Write-ColoredOutput "Could not run AdskLicensing uninstaller" -Color $Colors.Warning
        }
    }
}

function Remove-AutodeskTempFiles {
    Write-ColoredOutput "Clearing temporary files..." -Color $Colors.Info
    
    $tempPaths = @(
        $env:TEMP,
        $env:TMP,
        "C:\Windows\Temp"
    )
    
    $patterns = @(
        "*Autodesk*", "*AutoCAD*", "*Inventor*", "*Maya*", "*3dsMax*", "*Revit*", "*Fusion*",
        "*AutodeskDesktopApp*", "*Autodesk,_Inc*", "*AutodeskLicensing*", "*AutodeskMaterial*",
        "*AutodeskAccess*", "*AutodeskIdentity*", "*AutodeskDesktop*", "*AutodeskGenuine*"
    )
    
    foreach ($tempPath in $tempPaths) {
        if (Test-Path $tempPath) {
            foreach ($pattern in $patterns) {
                try {
                    # Remove files
                    Get-ChildItem -Path $tempPath -Filter $pattern -Force -ErrorAction SilentlyContinue | 
                        Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
                } catch {
                    # Continue if files are locked
                }
            }
        }
    }
}

function Grant-FullControlPermissions {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        return
    }
    
    try {
        # Take ownership
        & takeown.exe /f $Path /r /d Y 2>$null
        
        # Grant full control
        & icacls.exe $Path /grant "administrators:F" /t 2>$null
        
        # Unregister any DLLs in the path
        Get-ChildItem -Path $Path -Filter "*.dll" -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                & regsvr32.exe /u /s $_.FullName 2>$null
            } catch {
                # Continue if registration fails
            }
        }
    } catch {
        Write-ColoredOutput "Could not grant permissions to: $Path" -Color $Colors.Warning
    }
}

function Remove-AutodeskShortcuts {
    Write-ColoredOutput "Removing Autodesk shortcuts..." -Color $Colors.Info
    
    $shortcutPaths = @(
        "$env:USERPROFILE\Desktop",
        "$env:PUBLIC\Desktop",
        "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs",
        "$env:APPDATA\Microsoft\Windows\Start Menu\Programs",
        "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch"
    )
    
    $patterns = @(
        "*Autodesk*", "*AutoCAD*", "*Inventor*", "*Maya*", "*3ds Max*", "*Revit*", "*Fusion*"
    )
    
    foreach ($path in $shortcutPaths) {
        if (Test-Path $path) {
            foreach ($pattern in $patterns) {
                try {
                    Get-ChildItem -Path $path -Filter "$pattern.lnk" -ErrorAction SilentlyContinue | 
                        Remove-Item -Force -ErrorAction SilentlyContinue
                } catch {
                    # Continue if shortcuts are locked
                }
            }
        }
    }
    
    # Remove taskbar pinned shortcuts
    try {
        Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Force -ErrorAction SilentlyContinue
    } catch {
        # Continue if registry key doesn't exist
    }
}

function Remove-AutodeskDirectories {
    Write-ColoredOutput "Removing Autodesk directories..." -Color $Colors.Info
    
    $mainDirectories = @(
        "C:\ProgramData\FLEXnet",
        "C:\Program Files\Autodesk",
        "C:\Program Files\Common Files\Autodesk Shared",
        "C:\Program Files (x86)\Autodesk",
        "C:\Program Files (x86)\Common Files\Autodesk Shared",
        "C:\ProgramData\Autodesk",
        "$env:LOCALAPPDATA\Autodesk",
        "$env:APPDATA\Autodesk",
        "$env:PUBLIC\Documents\Autodesk",
        "$env:TEMP\Autodesk",
        "C:\ProgramData\Package Cache\Autodesk",
        "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Autodesk",
        "$env:USERPROFILE\Desktop\Autodesk",
        "C:\Autodesk",
        "C:\ADSK",
        "C:\ProgramData\Autodesk Genuine Service",
        "C:\Program Files\Autodesk Genuine Service",
        "C:\Program Files (x86)\Autodesk Genuine Service",
        "$env:USERPROFILE\AppData\Local\Temp\Autodesk",
        "$env:PUBLIC\Autodesk",
        "C:\ProgramData\Application Data\Autodesk"
    )
    
    # Grant permissions first
    foreach ($dir in $mainDirectories) {
        if (Test-Path $dir) {
            Grant-FullControlPermissions -Path $dir
        }
    }
    
    # Remove directories
    foreach ($dir in $mainDirectories) {
        if (Test-Path $dir) {
            try {
                Write-ColoredOutput "Removing directory: $dir" -Color $Colors.Info
                Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue
            } catch {
                # Try with robocopy method for stubborn directories
                try {
                    $emptyDir = Join-Path $env:TEMP "empty_dir_$(Get-Random)"
                    New-Item -ItemType Directory -Path $emptyDir -Force | Out-Null
                    & robocopy.exe $emptyDir $dir /mir /r:1 /w:1 2>$null
                    Remove-Item -Path $emptyDir -Force -ErrorAction SilentlyContinue
                    Remove-Item -Path $dir -Force -ErrorAction SilentlyContinue
                } catch {
                    Write-ColoredOutput "Could not remove directory: $dir" -Color $Colors.Warning
                }
            }
        }
    }
    
    # Remove directories with patterns
    $searchPaths = @(
        "$env:USERPROFILE\AppData\Local",
        "$env:USERPROFILE\AppData\Roaming",
        "$env:USERPROFILE\AppData\LocalLow",
        "$env:PROGRAMDATA",
        "C:\Program Files",
        "C:\Program Files (x86)",
        "$env:PUBLIC\Documents",
        "$env:PUBLIC",
        "$env:TEMP"
    )
    
    $patterns = @(
        "Autodesk*", "AutoCAD*", "Inventor*", "Maya*", "3dsMax*", "Revit*", "Fusion*", "ADSK*"
    )
    
    foreach ($searchPath in $searchPaths) {
        if (Test-Path $searchPath) {
            foreach ($pattern in $patterns) {
                try {
                    Get-ChildItem -Path $searchPath -Filter $pattern -Directory -ErrorAction SilentlyContinue | 
                        ForEach-Object {
                            try {
                                Grant-FullControlPermissions -Path $_.FullName
                                Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
                            } catch {
                                Write-ColoredOutput "Could not remove directory: $($_.FullName)" -Color $Colors.Warning
                            }
                        }
                } catch {
                    # Continue if search fails
                }
            }
        }
    }
}

function Remove-AutodeskRegistryEntries {
    Write-ColoredOutput "Removing Autodesk registry entries..." -Color $Colors.Info
    
    $registryPaths = @(
        "HKLM:\SOFTWARE\Autodesk",
        "HKCU:\SOFTWARE\Autodesk",
        "HKLM:\SOFTWARE\WOW6432Node\Autodesk",
        "HKCU:\SOFTWARE\WOW6432Node\Autodesk",
        "HKLM:\SOFTWARE\FLEXlm",
        "HKLM:\SOFTWARE\WOW6432Node\FLEXlm",
        "HKLM:\SOFTWARE\Autodesk Genuine Service",
        "HKLM:\SOFTWARE\WOW6432Node\Autodesk Genuine Service",
        "HKCU:\SOFTWARE\Autodesk Genuine Service"
    )
    
    foreach ($regPath in $registryPaths) {
        try {
            if (Test-Path $regPath) {
                Write-ColoredOutput "Removing registry key: $regPath" -Color $Colors.Info
                Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
            }
        } catch {
            Write-ColoredOutput "Could not remove registry key: $regPath" -Color $Colors.Warning
        }
    }
    
    # Remove file associations
    $fileAssociations = @(
        "HKCR:\AutoCAD.Drawing",
        "HKCR:\AutoCAD.Drawing.22",
        "HKCR:\AutoCAD.Drawing.23",
        "HKCR:\AutoCAD.Drawing.24",
        "HKCR:\AutoCAD.Drawing.25",
        "HKCR:\.dwg",
        "HKCR:\.dwt",
        "HKCR:\.dws"
    )
    
    foreach ($association in $fileAssociations) {
        try {
            if (Test-Path $association) {
                Remove-Item -Path $association -Recurse -Force -ErrorAction SilentlyContinue
            }
        } catch {
            # Continue if association doesn't exist
        }
    }
    
    # Remove Windows Installer entries
    try {
        $uninstallKeys = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        )
        
        foreach ($uninstallKey in $uninstallKeys) {
            if (Test-Path $uninstallKey) {
                Get-ChildItem -Path $uninstallKey -ErrorAction SilentlyContinue | 
                    Where-Object { $_.Name -like "*Autodesk*" } | 
                    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    } catch {
        Write-ColoredOutput "Could not remove Windows Installer entries" -Color $Colors.Warning
    }
    
    # Remove service entries
    try {
        $serviceKeys = @(
            "HKLM:\SYSTEM\CurrentControlSet\Services"
        )
        
        foreach ($serviceKey in $serviceKeys) {
            if (Test-Path $serviceKey) {
                Get-ChildItem -Path $serviceKey -ErrorAction SilentlyContinue | 
                    Where-Object { $_.Name -like "*FlexNet*" -or $_.Name -like "*Adsk*" } | 
                    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    } catch {
        Write-ColoredOutput "Could not remove service registry entries" -Color $Colors.Warning
    }
}

function Clear-SystemFiles {
    Write-ColoredOutput "Clearing system files..." -Color $Colors.Info
    
    # Clear Windows Installer cache
    try {
        $msiCachePath = "C:\Windows\Installer"
        if (Test-Path $msiCachePath) {
            Get-ChildItem -Path $msiCachePath -Filter "*.msi" -ErrorAction SilentlyContinue | 
                Where-Object { $_.Name -like "*autodesk*" } | 
                Remove-Item -Force -ErrorAction SilentlyContinue
        }
    } catch {
        Write-ColoredOutput "Could not clear MSI cache" -Color $Colors.Warning
    }
    
    # Clear prefetch files
    try {
        $prefetchPath = "C:\Windows\Prefetch"
        if (Test-Path $prefetchPath) {
            $prefetchPatterns = @(
                "*AUTODESK*", "*AUTOCAD*", "*INVENTOR*", "*MAYA*", "*3DSMAX*", "*REVIT*", "*FUSION*"
            )
            
            foreach ($pattern in $prefetchPatterns) {
                Get-ChildItem -Path $prefetchPath -Filter "$pattern.pf" -ErrorAction SilentlyContinue | 
                    Remove-Item -Force -ErrorAction SilentlyContinue
            }
        }
    } catch {
        Write-ColoredOutput "Could not clear prefetch files" -Color $Colors.Warning
    }
    
    # Clear event logs
    try {
        $eventLogs = Get-WinEvent -ListLog * -ErrorAction SilentlyContinue | 
            Where-Object { $_.LogName -like "*autodesk*" }
        
        foreach ($log in $eventLogs) {
            try {
                & wevtutil.exe cl $log.LogName 2>$null
            } catch {
                # Continue if log cannot be cleared
            }
        }
    } catch {
        Write-ColoredOutput "Could not clear event logs" -Color $Colors.Warning
    }
    
    # Remove licensing files
    $licensingPaths = @(
        "C:\ProgramData\FLEXnet\*.lic",
        "C:\Program Files\Common Files\Autodesk Shared\AdskLicensing\*.lic",
        "C:\Program Files (x86)\Common Files\Autodesk Shared\AdskLicensing\*.lic"
    )
    
    foreach ($licPath in $licensingPaths) {
        try {
            Get-ChildItem -Path $licPath -ErrorAction SilentlyContinue | 
                Remove-Item -Force -ErrorAction SilentlyContinue
        } catch {
            # Continue if licensing files don't exist
        }
    }
    
    # Remove hidden FLEXnet files
    try {
        $flexnetPath = "C:\ProgramData\FLEXnet"
        if (Test-Path $flexnetPath) {
            Get-ChildItem -Path $flexnetPath -Filter "adsk*" -Force -ErrorAction SilentlyContinue | 
                ForEach-Object {
                    $_.Attributes = $_.Attributes -band (-bnot [System.IO.FileAttributes]::Hidden)
                    Remove-Item -Path $_.FullName -Force -ErrorAction SilentlyContinue
                }
        }
    } catch {
        Write-ColoredOutput "Could not remove FLEXnet files" -Color $Colors.Warning
    }
}

function Reset-NetworkSettings {
    Write-ColoredOutput "Resetting network settings and firewall..." -Color $Colors.Info
    
    # Backup hosts file
    try {
        $hostsPath = "C:\Windows\System32\drivers\etc\hosts"
        $hostsBackupPath = "C:\Windows\System32\drivers\etc\hosts.backup"
        
        if (Test-Path $hostsPath) {
            Write-ColoredOutput "Backing up hosts file..." -Color $Colors.Info
            Copy-Item -Path $hostsPath -Destination $hostsBackupPath -Force -ErrorAction Stop
            Write-ColoredOutput "Hosts file backed up successfully." -Color $Colors.Success
            
            # Reset hosts file to default
            $defaultHosts = @"
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost

127.0.0.1       localhost
::1             localhost
"@
            Set-Content -Path $hostsPath -Value $defaultHosts -Encoding ASCII
        }
    } catch {
        Write-ColoredOutput "WARNING: Could not backup/reset hosts file!" -Color $Colors.Warning
        Write-ColoredOutput "Error: $($_.Exception.Message)" -Color $Colors.Warning
    }
    
    # Reset Windows Firewall
    try {
        Write-ColoredOutput "Resetting Windows Firewall..." -Color $Colors.Info
        & netsh.exe advfirewall reset 2>$null
        & netsh.exe firewall reset 2>$null
        
        # Remove Autodesk firewall rules
        $autodeskPrograms = @(
            "*autodesk*", "*autocad*", "*inventor*", "*maya*", "*3dsmax*", "*revit*", "*fusion*", "*adsk*"
        )
        
        foreach ($program in $autodeskPrograms) {
            & netsh.exe advfirewall firewall delete rule name="all" program=$program 2>$null
        }
    } catch {
        Write-ColoredOutput "Could not reset firewall completely" -Color $Colors.Warning
    }
    
    # Reset network stack
    try {
        Write-ColoredOutput "Resetting network stack..." -Color $Colors.Info
        & netsh.exe winsock reset 2>$null
        & netsh.exe int ip reset 2>$null
        & ipconfig.exe /flushdns 2>$null
    } catch {
        Write-ColoredOutput "Could not reset network stack" -Color $Colors.Warning
    }
}

function Show-CompletionMessage {
    Write-ColoredOutput ""
    Write-Header "Autodesk Removal Completed Successfully!"
    
    Write-ColoredOutput "IMPORTANT NOTES AND RECOVERY INFORMATION:" -Color $Colors.Info
    Write-ColoredOutput "- A system restore point was created before starting" -Color $Colors.Info
    Write-ColoredOutput "- Hosts file backup: C:\Windows\System32\drivers\etc\hosts.backup" -Color $Colors.Info
    Write-ColoredOutput "- Windows Firewall has been reset to default settings" -Color $Colors.Info
    Write-ColoredOutput "- Network settings have been reset" -Color $Colors.Info
    Write-ColoredOutput ""
    Write-ColoredOutput "IF YOU EXPERIENCE PROBLEMS AFTER RESTART:" -Color $Colors.Warning
    Write-ColoredOutput "1. Use System Restore to return to the restore point created" -Color $Colors.Warning
    Write-ColoredOutput "2. Restore your hosts file from the backup if needed" -Color $Colors.Warning
    Write-ColoredOutput "3. Check Windows Update for any missing drivers" -Color $Colors.Warning
    Write-ColoredOutput "4. Reconfigure your firewall settings if needed" -Color $Colors.Warning
    Write-ColoredOutput ""
    Write-ColoredOutput "TO ACCESS SYSTEM RESTORE:" -Color $Colors.Info
    Write-ColoredOutput "1. Type 'rstrui' in Start menu and press Enter" -Color $Colors.Info
    Write-ColoredOutput "2. Select the restore point created today" -Color $Colors.Info
    Write-ColoredOutput "3. Follow the wizard to restore your system" -Color $Colors.Info
    Write-ColoredOutput ""
    Write-ColoredOutput "Please restart your computer for all changes to take effect" -Color $Colors.Success
    Write-Header "Operation Complete"
}

function Request-SystemRestart {
    if ($NoRestart) {
        Write-ColoredOutput "Restart skipped as requested. Please restart manually." -Color $Colors.Warning
        return
    }
    
    Write-ColoredOutput ""
    Write-ColoredOutput "Would you like to restart your computer now? (Y/N): " -Color $Colors.Prompt -NoNewline
    $response = Read-Host
    
    if ($response -eq "Y" -or $response -eq "y") {
        Write-ColoredOutput "Restarting computer in 10 seconds..." -Color $Colors.Info
        Write-ColoredOutput "Press Ctrl+C to cancel restart." -Color $Colors.Info
        
        for ($i = 10; $i -gt 0; $i--) {
            Write-ColoredOutput "$i..." -Color $Colors.Info
            Start-Sleep -Seconds 1
        }
        
        Restart-Computer -Force
    } else {
        Write-ColoredOutput "Please remember to restart your computer manually." -Color $Colors.Warning
    }
}

# Main execution
function Main {
    try {
        # Show header
        Write-Header "Autodesk Complete Removal Tool"
        Write-ColoredOutput "Please make sure all Autodesk applications are closed" -Color $Colors.Info
        Write-ColoredOutput "This will remove all Autodesk software and data" -Color $Colors.Info
        Write-Header ""
        
        # Perform safety checks
        if (-not (Test-SystemSafety)) {
            return
        }
        
        # Create restore point
        if (-not (New-SystemRestorePoint)) {
            return
        }
        
        # Show safety warnings
        Show-SafetyWarnings
        
        # Execute removal steps
        Stop-AutodeskServices
        Stop-AutodeskProcesses
        Invoke-OfficialUninstallers
        Remove-AutodeskTempFiles
        Remove-AutodeskShortcuts
        Remove-AutodeskDirectories
        Remove-AutodeskRegistryEntries
        Clear-SystemFiles
        Reset-NetworkSettings
        
        # Show completion message
        Show-CompletionMessage
        
        # Request restart
        Request-SystemRestart
        
    } catch {
        Write-ColoredOutput "An unexpected error occurred: $($_.Exception.Message)" -Color $Colors.Error
        Write-ColoredOutput "Please check the system restore point if you experience issues." -Color $Colors.Warning
    }
}

# Execute main function
Main
