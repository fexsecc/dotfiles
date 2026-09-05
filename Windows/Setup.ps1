$ErrorActionPreference = 'Stop'

# Check if the current user is in the Administrator group
$adminrole = ([Security.Principal.WindowsBuiltInRole] "Administrator")
$wid = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent())

# If not running with administrative privileges...
If (-not $wid.IsInRole($adminrole)) {
    # Prepare to relaunch the script with elevated rights
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
    # Pass the current script's path as argument so it relaunches itself
    $newProcess.Arguments = $myInvocation.MyCommand.Definition
    # Use 'runas' to trigger UAC elevation prompt
    $newProcess.Verb = "runas"
    # Start the new elevated process
    [System.Diagnostics.Process]::Start($newProcess)
    # Exit the current (non-elevated) process to avoid duplicate execution
    exit
}

# Create env vars
$TargetLevel = [System.EnvironmentVariableTarget]::User
[Environment]::SetEnvironmentVariable("ZELLIJ_CONFIG_FILE", "$env:USERPROFILE\.config\zellij\config.kdl", $TargetLevel)
[Environment]::SetEnvironmentVariable("CARGO_HOME", "$env:USERPROFILE\.config\cargo", $TargetLevel)
[Environment]::SetEnvironmentVariable("RUSTUP_HOME", "$env:USERPROFILE\.config\rustup", $TargetLevel)
[Environment]::SetEnvironmentVariable("GOPATH", "$env:USERPROFILE\.config\go", $TargetLevel)
[Environment]::SetEnvironmentVariable("POWERSHELL_TELEMETRY_OPTOUT", 1, $TargetLevel)

$ZellijDir = "$env:USERPROFILE/.config/zellij"
$AlacrittyDir = "$env:APPDATA/alacritty"
$PowerShellDir = "$env:USERPROFILE/Documents/PowerShell"

# Make sure the directories exist
New-Item -Path $ZellijDir -ItemType Directory -Force | Out-Null
New-Item -Path $AlacrittyDir -ItemType Directory -Force | Out-Null
New-Item -Path $PowerShellDir -ItemType Directory -Force | Out-Null

$ZellijPath = "$ZellijDir/config.kdl"
$AlacrittyPath = "$AlacrittyDir/alacritty.toml"
$PowerShellProfilePath = "$PowerShellDir/Microsoft.PowerShell_profile.ps1"

Copy-Item -Path "$PSScriptRoot/Cli/config.kdl" -Destination $ZellijPath -Force
Copy-Item -Path "$PSScriptRoot/Cli/alacritty.toml" -Destination $AlacrittyPath -Force
Copy-Item -Path "$PSScriptRoot/Cli/Microsoft.PowerShell_profile.ps1" -Destination $PowerShellProfilePath -Force

# Install NerdFonts
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Administrator privileges are required to install fonts globally."
    exit
}
$TempDir = Join-Path $env:TEMP "JetBrainsMonoNF_Temp"
$ZipPath = Join-Path $TempDir "font.zip"
$FontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
if (Test-Path $TempDir) { 
    Remove-Item -Path $TempDir -Recurse -Force 
}
New-Item -ItemType Directory -Path $TempDir | Out-Null
Invoke-WebRequest -Uri $FontUrl -OutFile $ZipPath
Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force
$FontRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
$FontFiles = Get-ChildItem -Path $TempDir -Filter "*.ttf" -Recurse

foreach ($Font in $FontFiles) {
    $Destination = Join-Path -Path $env:windir -ChildPath "Fonts\$($Font.Name)"
    
    if (Test-Path -Path $Destination) {
        continue
    }

    try {
        Copy-Item -Path $Font.FullName -Destination $Destination -Force -ErrorAction Stop
        
        $RegName = "$($Font.BaseName) (TrueType)"
        Set-ItemProperty -Path $FontRegPath -Name $RegName -Value $Font.Name
    } catch {
        Write-Warning "Skipping $($Font.Name): File is actively in use by another process."
    }
}
Remove-Item -Path $TempDir -Recurse -Force

# Call network setup and service disabling script
& ".\NetSetup.ps1"
# Overwrite hosts with custom file
Copy-Item "$PSScriptRoot\..\Misc\windows_hosts" "C:\Windows\System32\drivers\etc\hosts" -Force

Write-Host -NoNewLine 'Press any key to exit...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
