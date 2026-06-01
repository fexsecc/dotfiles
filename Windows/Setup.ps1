$ErrorActionPreference = 'Stop'

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
$ShellApp = New-Object -ComObject Shell.Application
$FontsFolder = $ShellApp.Namespace(0x14)
$FontFiles = Get-ChildItem -Path $TempDir -Filter "*.ttf" -Recurse
foreach ($Font in $FontFiles) {
    $FontsFolder.CopyHere($Font.FullName, 16)
}
Remove-Item -Path $TempDir -Recurse -Force
