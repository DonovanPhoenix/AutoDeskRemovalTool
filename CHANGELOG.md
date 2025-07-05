# Changelog

All notable changes to the Autodesk Complete Removal Tool will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2025-07-06

### Changed
- Future-proofed Autodesk Material Library service stopping: dynamically finds all services with names starting with "Autodesk Material Library" (no more hardcoded years).
- Expanded process termination: added support for more Autodesk products (Civil 3D, Navisworks, Alias, Vault, Advance Steel, InfraWorks, Recap, Plant 3D, Robot, Moldflow, PowerMill, PowerInspect, PowerShape, Flame, Smoke, MotionBuilder, Mudbox, Character Generator, SketchBook, Eagle, BIM 360, FormIt, Structural Bridge, Structural Detailing, and more).
- Moved official uninstaller execution (`Invoke-OfficialUninstallers`) to run before directory removal, ensuring uninstallers are not deleted before execution.

### Fixed
- No script errors detected after recent changes.

### Notes
- These changes improve reliability and future compatibility for new Autodesk product versions and variants.

## [2.0.0] - 2025-07-05

### Background
- **AI-Created Solution** developed to address Autodesk's inadequate removal methods
- Created after Autodesk discontinued their comprehensive "Autodesk Uninstall Tool"
- Developed in response to users being left with only [basic manual cleanup instructions](https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/Clean-uninstall.html)
- Fills the gap that Autodesk failed to address with proper removal tools

### Added
- **Complete PowerShell rewrite** of the original batch script
- **Enhanced safety checks** including Domain Controller detection
- **Comprehensive error handling** with graceful failure recovery
- **Color-coded output** for better user experience
- **Modular function architecture** for better maintainability
- **Command-line parameters** for flexible execution modes
- **Automatic system restore point creation** before making changes
- **Hosts file backup and reset** functionality
- **Network stack reset** capabilities
- **Comprehensive registry cleanup** with pattern-based removal
- **Process detection and termination** for running Autodesk applications
- **Official uninstaller execution** (RemoveODIS.exe, AdskLicensing)
- **Stubborn file removal** using takeown, icacls, and robocopy
- **Windows Firewall reset** and Autodesk rule removal
- **Event log cleanup** for Autodesk-related logs
- **MSI cache cleanup** for Windows Installer files
- **Prefetch file removal** for system optimization
- **Comprehensive shortcut removal** (desktop, start menu, taskbar, quick launch)
- **Detailed recovery instructions** and troubleshooting guide
- **Interactive restart prompt** with countdown timer

### Enhanced
- **User prompts and confirmations** for dangerous operations
- **Disk space verification** before starting operations
- **Server environment detection** with warnings
- **Progress indicators** throughout the removal process
- **Detailed logging** of all operations
- **Permission handling** for locked files and directories
- **Service management** with proper stopping and deletion
- **Registry pattern matching** for comprehensive cleanup
- **Directory removal** with fallback methods for stubborn folders

### Security
- **Administrator privilege verification** before execution
- **System safety checks** to prevent damage to critical systems
- **Backup creation** before making system changes
- **Recovery point creation** for system restoration
- **Safe file operations** with proper error handling
- **Validation of system state** before proceeding with removal

### Parameters
- `-Force` - Skip user confirmations (use with caution)
- `-NoRestart` - Skip automatic restart prompt
- `-SkipRestorePoint` - Skip system restore point creation

### Supported Products
- AutoCAD (all versions and variants)
- Inventor
- Maya
- 3ds Max
- Revit
- Fusion 360
- Autodesk Desktop App
- Autodesk Licensing components
- FLEXnet Licensing
- Autodesk Genuine Service
- All Autodesk Material Libraries

### Technical Improvements
- **PowerShell 5.1+ compatibility** with modern cmdlets
- **WMI and CIM usage** for system information gathering
- **Proper exception handling** with try-catch blocks
- **Resource cleanup** and memory management
- **Cross-platform path handling** using environment variables
- **Secure file operations** with proper permissions
- **Optimized registry operations** with batch processing
- **Efficient directory traversal** with filtered searches

## [1.0.0] - 2025-07-04

### Added
- **Initial batch script version** with basic Autodesk removal
- **Service stopping and deletion** functionality
- **Process termination** for running Autodesk applications
- **Basic directory removal** for common Autodesk locations
- **Registry cleanup** for main Autodesk keys
- **Shortcut removal** from desktop and start menu
- **Basic system restore point creation**
- **Simple safety checks** for administrator privileges

### Features
- Remove main Autodesk directories
- Stop and delete Autodesk services
- Kill running Autodesk processes
- Clean registry entries
- Remove desktop shortcuts
- Basic error handling

### Limitations
- Limited error recovery options
- Basic user interface
- No comprehensive pattern matching
- Limited registry cleanup
- No network settings reset
- No advanced permission handling

---

## Version History Overview

| Version | Release Date | Major Changes |
|---------|--------------|---------------|
| 2.1.0   | 2025-07-06   | Improved service stopping, process termination, and uninstaller execution order |
| 2.0.0   | 2025-07-05   | Complete PowerShell rewrite with enhanced safety and features |
| 1.0.0   | 2025-07-04   | Initial batch script version |

## Future Roadmap

### Planned Features
- **GUI interface** for easier use
- **Selective removal** options for specific products
- **Installation detection** and reporting
- **License backup and restore** functionality
- **Advanced logging** with detailed reports
- **Multi-language support** for international users
- **Configuration file support** for customized behavior

### Under Consideration
- **Silent installation mode** for enterprise deployment
- **Integration with deployment tools** (SCCM, Intune)
- **Scheduled cleanup** functionality
- **Remote execution capabilities** for IT administrators
- **Audit trail generation** for compliance requirements

---

**Note**: This changelog follows the Keep a Changelog format. For detailed commit history, please refer to the Git log.
