#Requires -RunAsAdministrator

# run this command if no execution policy is set
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# util functions
function Write-Info($message) {
    Write-Host "[INFO] $message" -ForegroundColor Cyan
}
function Write-ErrorMsg($message) {
    Write-Host "[ERROR] $message" -ForegroundColor Red
}
function Write-Success($message) {
    Write-Host "[SUCCESS] $message" -ForegroundColor Green
}
function Write-WarningMsg($message) {
    Write-Host "[WARNING] $message" -ForegroundColor Yellow
}
function Log-Message($message) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path "error.log" -Value "[$timestamp] $message"
}
function Install-Scoop {
    if (!(Check-CommandExists "scoop")) {
        Write-Info "Installing Scoop..."
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        irm get.scoop.sh | iex
        if (Check-CommandExists "scoop") {
            Log-Message "SUCCESS: Scoop installed successfully."
            Write-Success "Scoop installed successfully."
        } else {
            Log-Message "FAILED: Scoop installation failed."
            Write-ErrorMsg "Scoop installation failed."
        }
    } else {
        Log-Message "INFO: Scoop is already installed."
        Write-Info "Scoop is already installed."
    }
}
function Disable-UAC {
    Write-Info "Disabling UAC (setting to lowest level)..."
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f
    if ($LASTEXITCODE -eq 0) {
        Log-Message "SUCCESS: UAC disabled."
        Write-Success "UAC disabled."
    } else {
        Log-Message "FAILED: Failed to disable UAC."
        Write-ErrorMsg "Failed to disable UAC."
    }
}
function Install-Apps {
    Write-Info "Adding Scoop buckets..."
    scoop bucket add extras
    Write-Info "Installing applications via Scoop..."
    $apps = @("git", "vscode", "notepadplusplus", "googlechrome", "unikey", "7zip", "sourcetree")
    foreach ($app in $apps) {
        Write-Info "Installing $app..."
        scoop install $app
        if ($LASTEXITCODE -eq 0) {
            Log-Message "SUCCESS: $app installed successfully."
            Write-Success "$app installed."
        } else {
            Log-Message "FAILED: $app installation failed."
            Write-ErrorMsg "$app installation failed."
        }
    }
    Write-Success "Applications installation completed."
}

# main setup process
if (Test-Path "error.log") { Remove-Item "error.log" }
Log-Message "Starting setup process..."
Write-Info "Starting setup process..."
Disable-UAC
Install-Scoop
Write-Info "Install Scoop completed."
Install-Apps
Write-Info "Installing Cygwin via Scoop..."
scoop install cygwin
if ($LASTEXITCODE -eq 0) {
    Log-Message "SUCCESS: Cygwin installed successfully."
    Write-Success "Cygwin installed via Scoop."
} else {
    Log-Message "FAILED: Cygwin installation failed."
    Write-ErrorMsg "Cygwin installation failed."
}

# Load Cygwin configuration
$cygwinPath = "$env:USERPROFILE\scoop\apps\cygwin\current"
$cygwinHome = "$cygwinPath\home\$env:USERNAME"
$cygwinEtc = "$cygwinPath\etc"

Write-Info "Copying Cygwin configuration files..."
if (Test-Path .\self_config\self_cygwin_config\home) {
    Copy-Item .\self_config\self_cygwin_config\home\* $cygwinHome -Recurse -Force
    if ($?) {
        Log-Message "SUCCESS: User configuration copied."
        Write-Success "User configuration copied to $cygwinHome"
    } else {
        Log-Message "FAILED: Failed to copy user configuration."
        Write-ErrorMsg "Failed to copy user configuration."
    }
}
if (Test-Path .\self_config\self_cygwin_config\etc) {
    Copy-Item .\self_config\self_cygwin_config\etc\* $cygwinEtc -Recurse -Force
    if ($?) {
        Log-Message "SUCCESS: System configuration copied."
        Write-Success "System configuration copied to $cygwinEtc"
    } else {
        Log-Message "FAILED: Failed to copy system configuration."
        Write-ErrorMsg "Failed to copy system configuration."
    }
}

Write-Info "Installing GCC, Make, and Vim in Cygwin..."
$cygwinBash = "$cygwinPath\bin\bash.exe"
& $cygwinBash -c "wget -q https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg -O /usr/local/bin/apt-cyg && chmod +x /usr/local/bin/apt-cyg"
& $cygwinBash -c "apt-cyg install gcc make vim"
if ($LASTEXITCODE -eq 0) {
    Log-Message "SUCCESS: GCC, Make, and Vim installed in Cygwin."
    Write-Success "GCC, Make, and Vim installed in Cygwin."
} else {
    Log-Message "FAILED: Failed to install GCC, Make, and Vim in Cygwin."
    Write-ErrorMsg "Failed to install GCC, Make, and Vim in Cygwin."
}

Write-Info "Setup completed."
Log-Message "Setup completed."