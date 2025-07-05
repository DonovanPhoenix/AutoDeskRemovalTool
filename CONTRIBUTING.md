# Contributing to Autodesk Complete Removal Tool

**AI-Created Project** - Thank you for your interest in contributing to this AI-developed project! 

This tool was created by AI to address the significant shortcomings in Autodesk's removal methods after they discontinued their comprehensive "Autodesk Uninstall Tool" and replaced it with [inadequate manual instructions](https://www.autodesk.com/support/technical/article/caas/sfdcarticles/sfdcarticles/Clean-uninstall.html).

This document provides guidelines for contributing to the Autodesk Complete Removal Tool.

## 🤝 How to Contribute

### Reporting Bugs
When reporting bugs, please include:
- Windows version and build number
- PowerShell version (`$PSVersionTable.PSVersion`)
- Autodesk products that were installed
- Complete error message and stack trace
- Screenshots of the problem
- Steps to reproduce the issue

### Suggesting Features
Before suggesting a feature:
- Check if it's already been requested in Issues
- Ensure it aligns with the project's goals
- Consider the safety and security implications
- Provide a clear use case

### Submitting Code Changes

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Make your changes**
4. **Test thoroughly** (see Testing Guidelines below)
5. **Commit with clear messages**: `git commit -m "Add feature: description"`
6. **Push to your fork**: `git push origin feature/your-feature-name`
7. **Submit a Pull Request**

## 📋 Development Guidelines

### Code Style
- Follow PowerShell best practices
- Use approved verbs for function names
- Include comment-based help for all functions
- Use meaningful variable names
- Keep functions focused and single-purpose

### Error Handling
- Always include proper error handling
- Use try-catch blocks where appropriate
- Set `$ErrorActionPreference = "Continue"` for non-critical operations
- Provide meaningful error messages to users

### Safety Requirements
- Never remove safety checks
- Always test destructive operations
- Include confirmation prompts for dangerous actions
- Maintain system restore point functionality

### Documentation
- Update README.md if adding new features
- Update USAGE.md if changing user interface
- Include inline comments for complex logic
- Update parameter documentation

## 🧪 Testing Guidelines

### Before Submitting
Test your changes on:
- [ ] Windows 10 (latest version)
- [ ] Windows 11 (latest version)
- [ ] Windows Server 2019/2022
- [ ] Systems with different Autodesk products installed
- [ ] Clean systems without Autodesk products

### Test Cases
- [ ] Run with no parameters (interactive mode)
- [ ] Run with `-Force` parameter
- [ ] Run with `-NoRestart` parameter
- [ ] Run with `-SkipRestorePoint` parameter
- [ ] Test all parameter combinations
- [ ] Test on systems with locked files
- [ ] Test on systems with minimal permissions
- [ ] Test error recovery scenarios

### Virtual Machine Testing
Consider using VMs for testing:
- Create snapshots before testing
- Test different Windows versions
- Test with various Autodesk installations
- Test recovery procedures

## 🔒 Security Considerations

### Code Security
- Never include hardcoded credentials
- Validate all user inputs
- Use secure methods for file operations
- Avoid code injection vulnerabilities

### System Security
- Maintain principle of least privilege
- Don't disable security features unnecessarily
- Ensure restore points are created
- Validate system state before making changes

## 📝 Pull Request Template

When submitting a PR, include:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Code refactoring
- [ ] Performance improvement

## Testing
- [ ] Tested on Windows 10
- [ ] Tested on Windows 11
- [ ] Tested with Autodesk products installed
- [ ] Tested error scenarios
- [ ] Tested recovery procedures

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or clearly documented)
- [ ] All tests pass
```

## 🚀 Development Setup

### Prerequisites
- Windows 10/11 or Windows Server
- PowerShell 5.1 or higher
- Git for version control
- Text editor or PowerShell ISE

### Recommended Tools
- **Visual Studio Code** with PowerShell extension
- **PowerShell ISE** for testing
- **Windows Sandbox** for safe testing
- **Hyper-V** or **VMware** for VM testing

### Development Environment
```powershell
# Check PowerShell version
$PSVersionTable.PSVersion

# Install PowerShell modules for development
Install-Module -Name PSScriptAnalyzer
Install-Module -Name Pester

# Clone the repository
git clone https://github.com/your-username/autodesk-removal-tool.git
cd autodesk-removal-tool
```

## 🛠️ Code Quality

### PowerShell Script Analyzer
Run PSScriptAnalyzer before submitting:
```powershell
Invoke-ScriptAnalyzer -Path .\AutoDeskRemovalTool.ps1
```

### Common Issues to Avoid
- Hardcoded paths (use environment variables)
- Missing error handling
- Unsafe file operations
- Inadequate user feedback
- Breaking changes without documentation

## 📊 Performance Considerations

### Optimization Guidelines
- Use efficient PowerShell cmdlets
- Avoid unnecessary loops
- Use parallel processing where safe
- Minimize external tool dependencies
- Optimize registry operations

### Resource Usage
- Monitor memory usage during development
- Test on systems with limited resources
- Avoid excessive disk I/O
- Clean up temporary files

## 🔄 Release Process

### Version Numbering
- Use semantic versioning (MAJOR.MINOR.PATCH)
- Increment MAJOR for breaking changes
- Increment MINOR for new features
- Increment PATCH for bug fixes

### Release Checklist
- [ ] All tests pass
- [ ] Documentation updated
- [ ] Version number updated
- [ ] Changelog updated
- [ ] Security review completed
- [ ] Backward compatibility verified

## 📞 Getting Help

### Discussion Channels
- **GitHub Issues**: For bug reports and feature requests
- **GitHub Discussions**: For general questions and ideas
- **Pull Request Comments**: For code review discussions

### Contact Information
- Create an issue for public discussions
- Use pull request comments for code-specific questions
- Check existing issues before creating new ones

## 🙏 Recognition

Contributors will be recognized in:
- README.md contributors section
- Git commit history
- Release notes (for significant contributions)

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to making Windows systems cleaner and more manageable!**
