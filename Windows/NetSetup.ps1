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

# Disable the main Connected Devices Platform Service
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\CDPSvc" -Name "Start" -Value 4
# Disable the template User Service (prevents dynamic generation of CDPUserSvc_xxxx)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\CDPUserSvc" -Name "Start" -Value 4
# Stop the currently running main service
Stop-Service -Name "CDPSvc" -Force -ErrorAction SilentlyContinue
# Stop any currently running per-user service instances
Get-Service -Name "CDPUserSvc*" | Stop-Service -Force -ErrorAction SilentlyContinue

# Disable Function Discovery Resource Publication (stops advertising this PC)
Set-Service -Name "FDResPub" -StartupType Disabled
Stop-Service -Name "FDResPub" -Force -ErrorAction SilentlyContinue
# Disable Function Discovery Provider Host (stops discovering other PCs)
Set-Service -Name "fdPHost" -StartupType Disabled
Stop-Service -Name "fdPHost" -Force -ErrorAction SilentlyContinue

# Stops and disables the SMB Server service
Set-Service -Name "LanmanServer" -StartupType Disabled
Stop-Service -Name "LanmanServer" -Force
# Unbinds the server component from all active network adapters at the kernel level
Get-NetAdapterBinding -ComponentID ms_server | Disable-NetAdapterBinding

# Disables NetBIOS over TCP/IP on all IPv4 enabled adapters
Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'" | Invoke-CimMethod -MethodName SetTcpipNetbios -Arguments @{TcpipNetbiosOptions = 2}
# Disable LLMNR
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
If (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}
Set-ItemProperty -Path $registryPath -Name "EnableMulticast" -Value 0

# Firewall Setup
Get-NetFirewallRule | Remove-NetFirewallRule
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True -DefaultInboundAction Block -DefaultOutboundAction Allow
# Syncthing
New-NetFirewallRule -DisplayName "Allow Syncthing TCP" -Direction Inbound -LocalPort 22000 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Syncthing UDP" -Direction Inbound -LocalPort 22000,21027 -Protocol UDP -Action Allow
# usbipd
$Sw = Get-VMSwitch -Name "USBIP Switch" -ErrorAction SilentlyContinue
if (!$Sw) {
    New-VMSwitch -Name "USBIP Switch" -SwitchType Internal
}
New-NetFirewallRule -DisplayName "usbipd - VM Switch Only" -Direction Inbound -LocalPort 3240 -Protocol TCP -Action Allow -InterfaceAlias "vEthernet (USBIP Switch)"
# misc
New-NetFirewallRule -DisplayName "Block Public RPC" -Description "Block Public RPC and its dynamic ephemeral port range" -Direction Inbound -LocalPort 135,49152-65535 -Protocol TCP -Action Block
