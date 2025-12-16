# WinSetup: Automated Windows Development Environment Setup

* Enable script execution in PowerShell:
  ```
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

## Project Description
This project provides an automated PowerShell script (`setup.ps1`) to set up a development environment on a new Windows machine. Running the script installs necessary tools and configures Cygwin with personal configurations.

## Usage
1. Clone this repo from GitHub.
2. Open PowerShell with Administrator privileges.
3. Run: `.\setup.ps1`
4. Check `error.log` for detailed logs.

## Installed Applications and Packages
The script automatically installs the following applications and packages via Scoop:

### Windows Applications:
- **Git**: Version control system.
- **VS Code**: Popular code editor.
- **Notepad++**: Advanced text editor.
- **Google Chrome**: Web browser.
- **Unikey**: Vietnamese input software.
- **7-Zip**: File compression/decompression tool.
- **SourceTree**: Git GUI client.

### Cygwin and Packages:
- **Cygwin**: Unix-like environment on Windows, with personal configurations (home and etc files from `self_config/self_cygwin_config/`).
- **GCC**: C/C++ compiler.
- **Make**: Build automation tool.
- **Vim**: Text editor.

### Other Steps:
- Disable UAC (User Account Control) for smoother installations.
- Install Scoop (Windows package manager).
- Add `extras` bucket to Scoop.
- Log status to `error.log` with success/failure for each step.

After running, you can test Cygwin by opening bash and running `make build` in `test/cygwin_c/`.