# 📖 How to Use the Autodesk Complete Removal Tool

**AI-Created Solution** for comprehensive Autodesk software removal.

This guide provides detailed instructions on how to safely and effectively use the Autodesk Complete Removal Tool. This tool was created by AI to address the significant shortcomings in Autodesk's official removal methods after they discontinued their comprehensive "Autodesk Uninstall Tool" and replaced it with [inadequate manual instructions](https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/Clean-uninstall.html).

## 🎯 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Download and Preparation](#download-and-preparation)
3. [Basic Usage](#basic-usage)
4. [Advanced Usage](#advanced-usage)
5. [Understanding the Process](#understanding-the-process)
6. [Command Line Options](#command-line-options)
7. [What to Expect](#what-to-expect)
8. [Recovery and Troubleshooting](#recovery-and-troubleshooting)
9. [Best Practices](#best-practices)

## 🔧 Prerequisites

### System Requirements
- **Operating System**: Windows 10, Windows 11, or Windows Server 2016+
- **PowerShell**: Version 5.1 or higher (check with `$PSVersionTable.PSVersion`)
- **Privileges**: Administrator rights required
- **Disk Space**: At least 1GB free space on C: drive
- **Network**: Internet connection (for downloading if needed)

### Before You Begin
- [ ] **Close all Autodesk applications** completely
- [ ] **Save your work** in any open applications
- [ ] **Create a backup** of important data
- [ ] **Ensure you have recovery media** (Windows installation media)
- [ ] **Note down your Autodesk license information** (if you plan to reinstall)
- [ ] **Understand this tool was created by AI** because Autodesk's [official cleanup methods](https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/Clean-uninstall.html) are insufficient

## 📥 Download and Preparation

### Step 1: Download the Script
1. Download `AutoDeskRemovalTool.ps1` from the repository
2. Save it to a folder you can easily access (e.g., `C:\AutodeskRemoval\`)

### Step 2: Verify the Download
1. Right-click the script file
2. Select **Properties**
3. Check the **Digital Signatures** tab (if available)
4. Ensure the file size matches the repository

### Step 3: Check PowerShell Version
```powershell
$PSVersionTable.PSVersion
```
You should see version 5.1 or higher.

## 🚀 Basic Usage

### Method 1: Interactive Mode (Recommended)

1. **Open PowerShell as Administrator**:
   - Press `Windows Key + X`
   - Select **"Windows PowerShell (Admin)"** or **"Terminal (Admin)"**
   - Confirm the UAC prompt

2. **Navigate to the script directory**:
   ```powershell
   cd "C:\AutodeskRemoval"
   ```

3. **Run the script**:
   ```powershell
   .\AutoDeskRemovalTool.ps1
   ```

4. **Follow the prompts**:
   - Review safety warnings
   - Confirm you want to proceed
   - Wait for completion
   - Choose whether to restart

### Method 2: Context Menu

1. **Right-click the script file**
2. Select **"Run with PowerShell"**
3. **Important**: If you get an access denied error, you need to run as Administrator

## 🔬 Advanced Usage

### Using Command Line Parameters

```powershell
# Force mode - skips user confirmations (USE WITH CAUTION)
.\AutoDeskRemovalTool.ps1 -Force

# Skip restart prompt
.\AutoDeskRemovalTool.ps1 -NoRestart

# Skip creating system restore point
.\AutoDeskRemovalTool.ps1 -SkipRestorePoint

# Combine multiple options
.\AutoDeskRemovalTool.ps1 -Force -NoRestart -SkipRestorePoint
```

### Execution Policy Issues

If you encounter execution policy errors:

```powershell
# Check current policy
Get-ExecutionPolicy

# Set policy for current user (recommended)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Alternative: Bypass policy for this session only
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Run the script with bypass (one-time)
PowerShell.exe -ExecutionPolicy Bypass -File ".\AutoDeskRemovalTool.ps1"
```

## 🔍 Understanding the Process

### Phase 1: Safety Checks (30 seconds)
- ✅ Administrator privilege verification
- ✅ System type detection (workstation vs server)
- ✅ Disk space verification
- ✅ Domain Controller detection

### Phase 2: Backup Creation (2-5 minutes)
- 🛡️ System restore point creation
- 🛡️ Hosts file backup
- 🛡️ Safety warning display

### Phase 3: Service and Process Termination (1-2 minutes)
- 🛑 Autodesk services stopped
- 🛑 Running processes terminated
- 🛑 Explorer temporarily restarted

### Phase 4: Official Uninstallers (3-10 minutes)
- 🔧 RemoveODIS.exe execution
- 🔧 AdskLicensing uninstaller execution

### Phase 5: File System Cleanup (5-15 minutes)
- 🗂️ Temporary files removed
- 🗂️ Program directories removed
- 🗂️ User data directories cleaned
- 🗂️ Stubborn files handled

### Phase 6: Registry Cleanup (2-5 minutes)
- 📝 Autodesk registry keys removed
- 📝 File associations cleaned
- 📝 Windows Installer entries removed
- 📝 Service registry keys removed

### Phase 7: System Cleanup (2-3 minutes)
- 🧹 MSI cache cleaned
- 🧹 Prefetch files removed
- 🧹 Event logs cleared
- 🧹 License files removed

### Phase 8: Network Reset (1-2 minutes)
- 🌐 Hosts file reset
- 🌐 Firewall rules removed
- 🌐 Network stack reset

**Total Time**: 15-40 minutes (depending on system and installed software)

## 🎛️ Command Line Options

### Parameter Details

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `-Force` | Switch | Skips all user confirmations | `.\AutoDeskRemovalTool.ps1 -Force` |
| `-NoRestart` | Switch | Skips restart prompt at end | `.\AutoDeskRemovalTool.ps1 -NoRestart` |
| `-SkipRestorePoint` | Switch | Skips system restore point creation | `.\AutoDeskRemovalTool.ps1 -SkipRestorePoint` |

### Usage Scenarios

#### Development/Testing Environment
```powershell
# Quick removal without restore point or restart
.\AutoDeskRemovalTool.ps1 -SkipRestorePoint -NoRestart
```

#### Production Environment
```powershell
# Full safety mode (default)
.\AutoDeskRemovalTool.ps1
```

#### Automated Deployment
```powershell
# Unattended execution with full safety
.\AutoDeskRemovalTool.ps1 -Force
```

#### Emergency Removal
```powershell
# Fastest removal (not recommended for production)
.\AutoDeskRemovalTool.ps1 -Force -SkipRestorePoint -NoRestart
```

## 📊 What to Expect

### Normal Output Colors
- **🔵 Blue (Cyan)**: Headers and important information
- **⚪ White**: General information and progress
- **🟢 Green**: Success messages
- **🟡 Yellow**: Warnings (non-critical)
- **🔴 Red**: Errors (usually handled automatically)
- **🟣 Magenta**: User prompts and questions

### Expected Warnings
These warnings are normal and expected:
- "Could not stop service: [ServiceName]" - Service may not be installed
- "Could not remove registry key: [KeyName]" - Key may not exist
- "Could not remove directory: [Path]" - Directory may not exist
- "Could not clear prefetch files" - Files may be locked

### Successful Completion Indicators
- ✅ "System restore point created successfully!"
- ✅ "Hosts file backed up successfully."
- ✅ "Autodesk Removal Completed Successfully!"
- ✅ Final summary with recovery information

## 🚨 Recovery and Troubleshooting

### If Something Goes Wrong

#### 1. Use System Restore (Primary Recovery Method)
```powershell
# Open System Restore
rstrui.exe
```
1. Select **"Restore my computer to an earlier time"**
2. Choose the restore point created by the script
3. Follow the wizard to complete restoration

#### 2. Manual Recovery Steps

**Restore Hosts File:**
```powershell
# If network issues occur
Copy-Item "C:\Windows\System32\drivers\etc\hosts.backup" "C:\Windows\System32\drivers\etc\hosts" -Force
```

**Reset Network Settings:**
```powershell
# If network connectivity issues
netsh winsock reset
netsh int ip reset
ipconfig /flushdns
```

**Restore Windows Firewall:**
```powershell
# If firewall issues
netsh advfirewall reset
```

#### 3. Common Issues and Solutions

**Issue**: "Access Denied" errors
**Solution**: 
```powershell
# Run as Administrator
Start-Process PowerShell -Verb RunAs
```

**Issue**: "Execution Policy" errors
**Solution**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Issue**: Script appears to hang
**Solution**:
- Wait 10-15 minutes (some operations take time)
- Check if any dialog boxes are waiting for input
- Press Ctrl+C to cancel if needed

**Issue**: Some files/services remain
**Solution**:
- Restart computer and run script again
- Use Windows built-in uninstaller for remaining items
- Check Windows Update for driver issues

## 💡 Best Practices

### Before Running
1. **Create a full system backup** (not just restore point)
2. **Document your current Autodesk installations** and licenses
3. **Close all applications** completely
4. **Disconnect from network** if working with sensitive data
5. **Run during maintenance window** (if in business environment)

### During Execution
1. **Don't interrupt the process** - let it complete
2. **Monitor the output** for any unexpected errors
3. **Take screenshots** of any unusual messages
4. **Be patient** - some operations take time

### After Completion
1. **Restart your computer** as prompted
2. **Test system functionality** after restart
3. **Check Windows Update** for any missing drivers
4. **Verify network connectivity** and firewall settings
5. **Clean up temporary files** if needed

### For Business Environments
1. **Test in lab environment** first
2. **Schedule during maintenance window**
3. **Inform users** about the maintenance
4. **Have recovery plan** ready
5. **Document the process** for compliance

## 🔍 Verification Steps

After running the script, verify removal:

### Check Programs and Features
1. Open **Control Panel** → **Programs** → **Programs and Features**
2. Look for any remaining Autodesk entries
3. Uninstall any remaining items manually

### Check Services
```powershell
# Check for remaining Autodesk services
Get-Service | Where-Object {$_.Name -like "*Autodesk*" -or $_.Name -like "*Adsk*"}
```

### Check Processes
```powershell
# Check for remaining Autodesk processes
Get-Process | Where-Object {$_.ProcessName -like "*Autodesk*" -or $_.ProcessName -like "*Adsk*"}
```

### Check Registry
```powershell
# Check for remaining registry keys (advanced users)
Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | Where-Object {$_.GetValue("DisplayName") -like "*Autodesk*"}
```

## 📞 Getting Help

### Self-Help Resources
1. **Read the error message** carefully
2. **Check the troubleshooting section** above
3. **Search the repository issues** for similar problems
4. **Review the script comments** for technical details

### Reporting Issues
When reporting issues, include:
- Windows version and build number
- PowerShell version
- Autodesk products that were installed
- Complete error message
- Screenshots of the problem
- Steps you took before the error occurred

### Community Support
- **GitHub Issues**: For bug reports and feature requests
- **Discussions**: For general questions and tips
- **Wiki**: For additional documentation and examples
- **Note**: This AI-created tool exists because Autodesk's own removal methods are inadequate

---

**Why This Tool Exists**: Autodesk discontinued their comprehensive "Autodesk Uninstall Tool" and now only provides [basic manual cleanup instructions](https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/Clean-uninstall.html) that leave behind countless files, registry entries, and system modifications. This AI-developed tool fills that gap with a comprehensive, automated solution.

**Remember**: This tool makes extensive system changes. Always test in a non-production environment first and ensure you have proper backups!
