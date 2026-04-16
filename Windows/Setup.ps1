# Create env vars
$TargetLevel = [System.EnvironmentVariableTarget]::User
[Environment]::SetEnvironmentVariable("ZELLIJ_CONFIG_FILE", "$env:USERPROFILE\.config\zellij\config.kdl", $TargetLevel)
[Environment]::SetEnvironmentVariable("CARGO_HOME", "$env:USERPROFILE\.config\cargo", $TargetLevel)
[Environment]::SetEnvironmentVariable("RUSTUP_HOME", "$env:USERPROFILE\.config\rustup", $TargetLevel)
[Environment]::SetEnvironmentVariable("GOPATH", "$env:USERPROFILE\.config\go", $TargetLevel)

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
