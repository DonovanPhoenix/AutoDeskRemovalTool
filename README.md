# 🔧 Autodesk Complete Removal Tool

A comprehensive PowerShell script for safely and thoroughly removing all Autodesk software from Windows systems.

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://docs.microsoft.com/en-us/powershell/)
[![Windows](https://img.shields.io/badge/Windows-10%2F11%2FServer-lightgrey.svg)](https://www.microsoft.com/windows/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🚀 Overview

**Created by AI** to address the inadequacy of Autodesk's official removal methods. After Autodesk discontinued their comprehensive "Autodesk Uninstall Tool" and replaced it with [limited manual instructions](https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/Clean-uninstall.html), users were left without a reliable way to completely remove Autodesk software.

This AI-developed tool provides a complete solution for removing all traces of Autodesk software from Windows systems. It goes beyond standard uninstallation and Autodesk's insufficient manual methods by removing:

- **All Autodesk applications** (AutoCAD, Inventor, Maya, 3ds Max, Revit, Fusion 360, etc.)
- **Services and processes** (including licensing services)
- **Registry entries** (software keys, file associations, installer entries)
- **Files and directories** (program files, user data, temp files, cache)
- **Shortcuts** (desktop, start menu, taskbar, quick launch)
- **System files** (MSI cache, prefetch files, event logs)
- **Network settings** (firewall rules, hosts file cleanup)

## ✨ Features

### 🛡️ Safety First
- **Administrator privilege verification**
- **System safety checks** (Domain Controller detection, disk space verification)
- **Automatic system restore point creation**
- **Comprehensive error handling**
- **Recovery instructions and backup creation**

### 🎯 Thorough Removal
- **Process termination** - Safely stops all Autodesk processes
- **Service management** - Stops and removes Autodesk services
- **Official uninstallers** - Runs RemoveODIS.exe and AdskLicensing uninstaller
- **Registry cleanup** - Removes all Autodesk registry entries
- **File system cleanup** - Handles locked files and permissions
- **Network reset** - Cleans firewall rules and network settings

### 💡 User Experience
- **Color-coded output** - Clear visual feedback
- **Progress indicators** - Shows current operation
- **Interactive prompts** - Confirms dangerous operations
- **Flexible execution** - Multiple command-line options
- **Detailed logging** - Comprehensive operation feedback

## 📋 Prerequisites

- **Windows 10/11 or Windows Server**
- **PowerShell 5.1 or higher**
- **Administrator privileges**
- **At least 1GB free disk space**

## 🚦 Quick Start

1. **Download the script**: `AutoDeskRemovalTool.ps1`
2. **Right-click PowerShell** and select **"Run as administrator"**
3. **Navigate to the script directory**
4. **Run the script**:
   ```powershell
   .\AutoDeskRemovalTool.ps1
   ```

## 📖 Usage

### Basic Usage
```powershell
# Interactive mode with all safety checks
.\AutoDeskRemovalTool.ps1

# Force mode (skip confirmations) - USE WITH CAUTION
.\AutoDeskRemovalTool.ps1 -Force

# Skip automatic restart prompt
.\AutoDeskRemovalTool.ps1 -NoRestart

# Skip system restore point creation
.\AutoDeskRemovalTool.ps1 -SkipRestorePoint

# Combine options
.\AutoDeskRemovalTool.ps1 -Force -NoRestart
```

### Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `-Force` | Skip user confirmations (use with caution) | `$false` |
| `-NoRestart` | Skip automatic restart prompt | `$false` |
| `-SkipRestorePoint` | Skip system restore point creation | `$false` |

## 🔍 What Gets Removed

### Software Applications
- AutoCAD (all versions)
- Inventor
- Maya
- 3ds Max
- Revit
- Fusion 360
- Autodesk Desktop App
- All Autodesk licensing components

### Services
- FlexNet Licensing Service
- Autodesk Licensing Service
- Autodesk Material Library Services
- Autodesk Desktop App Service
- Autodesk Genuine Service

### Files and Directories
- `C:\Program Files\Autodesk`
- `C:\Program Files (x86)\Autodesk`
- `C:\ProgramData\Autodesk`
- `C:\ProgramData\FLEXnet`
- User AppData directories
- Temp files and cache
- And many more...

### Registry Entries
- `HKLM\SOFTWARE\Autodesk`
- `HKCU\SOFTWARE\Autodesk`
- File associations (.dwg, .dwt, etc.)
- Windows Installer entries
- Service registry keys

## ⚠️ Safety Warnings

### Before Running
- ✅ **Create backups** of important data
- ✅ **Close all applications**
- ✅ **Ensure you have Administrator privileges**
- ✅ **Verify you have at least 1GB free space**

### Automatic Safety Features
- 🛡️ **System restore point** created automatically
- 🛡️ **Hosts file backup** created
- 🛡️ **Domain Controller detection** (prevents running on DCs)
- 🛡️ **Server environment warnings**

## 🔧 Recovery Options

If you experience issues after running the script:

### System Restore
1. Type `rstrui` in the Start menu
2. Select the restore point created by the script
3. Follow the wizard to restore your system

### Manual Recovery
- **Hosts file**: Restore from `C:\Windows\System32\drivers\etc\hosts.backup`
- **Windows Update**: Check for missing drivers
- **Firewall**: Reconfigure settings if needed

## 📊 Supported Autodesk Products

The script removes all versions and installations of:

| Product Category | Applications |
|------------------|--------------|
| **CAD Software** | AutoCAD, AutoCAD LT, AutoCAD Architecture, AutoCAD Electrical, AutoCAD Mechanical |
| **3D Modeling** | Inventor, Fusion 360, 3ds Max, Maya |
| **Architecture** | Revit, AutoCAD Architecture |
| **Manufacturing** | Inventor, Fusion 360, PowerMill, FeatureCAM |
| **Media & Entertainment** | Maya, 3ds Max, MotionBuilder |
| **Utilities** | Autodesk Desktop App, Autodesk Genuine Service, FLEXnet Licensing |

## 🐛 Troubleshooting

### Common Issues

**"Access Denied" Errors**
- Ensure you're running as Administrator
- The script handles most permission issues automatically

**"Service Cannot Be Stopped" Errors**
- Some services may be in use; the script will retry
- Restart your computer if services remain after script completion

**"Registry Key Not Found" Errors**
- This is normal - means the key was already removed or doesn't exist
- The script continues with other operations

**Script Execution Policy Error**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### Development
- Follow PowerShell best practices
- Maintain error handling and safety checks
- Test on different Windows versions
- Update documentation for new features

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This tool makes extensive changes to your system. While it includes safety features:

- **Use at your own risk**
- **Test in a non-production environment first**
- **Ensure you have system backups**
- **Review the code before running**

The authors are not responsible for any damage caused by this tool.

## 🙏 Acknowledgments

- **Created by AI** in response to Autodesk's inadequate removal solutions
- Developed after Autodesk discontinued their comprehensive "Autodesk Uninstall Tool"
- Inspired by the need for a reliable alternative to Autodesk's [limited manual cleanup instructions](https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/Clean-uninstall.html)
- Thanks to the PowerShell community for best practices and techniques
- Built with safety, thoroughness, and user needs in mind - something Autodesk failed to provide

## 🤖 Why This AI Tool Was Created

### The Problem with Autodesk's Solutions
Autodesk previously provided a comprehensive "Autodesk Uninstall Tool" that could effectively remove their software. However, they **discontinued this tool** and now only provide [basic manual cleanup instructions](https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/Clean-uninstall.html) that are:

- ❌ **Incomplete** - Leaves behind hundreds of files and registry entries
- ❌ **Manual** - Requires users to manually delete files and edit registry
- ❌ **Time-consuming** - Takes hours of manual work
- ❌ **Error-prone** - Easy to miss components or damage system
- ❌ **Unsafe** - No backup or recovery options provided

### The AI Solution
This tool was developed by AI to provide what Autodesk failed to deliver:

- ✅ **Complete removal** of all Autodesk components
- ✅ **Automated process** with minimal user intervention  
- ✅ **Safety features** including restore points and backups
- ✅ **Comprehensive cleanup** beyond what Autodesk's manual method covers
- ✅ **Error handling** and recovery procedures
- ✅ **User-friendly interface** with clear feedback

**The result**: A tool that actually works and removes Autodesk software completely, something Autodesk themselves no longer provides.

---

**⭐ If this tool helped you, please give it a star!**

**🐛 Found a bug? Please report it in the Issues section.**

**💡 Have a suggestion? We'd love to hear it!**
