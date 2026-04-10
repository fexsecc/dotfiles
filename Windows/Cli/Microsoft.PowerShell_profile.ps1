New-Alias vim nvim
Import-Module PSReadline

Set-PSReadLineKeyHandler -Key "Ctrl+a" -Function BeginningOfLine
Set-PSReadLineKeyHandler -Key "Ctrl+e" -Function EndOfLine
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function DeleteCharOrExit
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

#$Env:KOMOREBI_CONFIG_HOME = $ENV:HOMEDRIVE + $ENV:HOMEPATH + '\.config\komorebi'
$Env:NODE_REPL_HISTORY = $ENV:HOMEDRIVE + $ENV:HOMEPATH + '\.config\node\node_repl_history'
$Env:HCLI_CURRENT_IDA_INSTALL_DIR = "C:\Program Files\IDA Professional 9.3"

#function prompt {
#    $p = $executionContext.SessionState.Path.CurrentLocation
#    if ($p.Provider.Name -eq "FileSystem") {
#        $e = [char]27
#        $path = $p.ProviderPath -Replace "\\", "/"
#        "$e]7;file://${env:COMPUTERNAME}/${path}$e\" + "PS $p> "
#    } else {
#        "PS $p> "
#    }
#}

function prompt {
    $CurrentPath = $executionContext.SessionState.Path.CurrentLocation
    
    if ($CurrentPath.Provider.Name -eq "FileSystem") {
        [System.Environment]::CurrentDirectory = $CurrentPath.ProviderPath
    }
    
    "PS $CurrentPath> "
}

function vc {
    # Force vswhere to find the installation containing the C++ Compiler tools
    $vsInstallPath = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    
    if (-not $vsInstallPath) {
        Write-Host "Fatal: Could not find any Visual Studio installation with the C++ tools workload." -ForegroundColor Red
        return
    }

    # Import the Developer Shell module from the correct Build Tools path
    Import-Module "$vsInstallPath\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
    
    # Enter the environment targeting 64-bit architecture
    Enter-VsDevShell -VsInstallPath $vsInstallPath -SkipAutomaticLocation -Arch amd64 -HostArch amd64
    
    Write-Host "MSVC Environment Loaded (x64) from: $vsInstallPath" -ForegroundColor Green
}

function clang64 {
    # Set the master switch for the environment
    $env:MSYSTEM = 'CLANG64'

    # Magic variable: Tells MSYS2 NOT to send you to the home (~) directory.
    # It keeps you in the exact Windows folder you are currently working in!
    $env:CHERE_INVOKING = '1'

    # Launch the raw bash shell as a login shell
    & "C:\msys64\usr\bin\bash.exe" --login -i
}

Remove-Item alias:ls -ErrorAction SilentlyContinue
. "C:\clones\eza\completions\pwsh\_eza.ps1"
function ls {
    eza --icons --group-directories-first @args
}
$CompRoot = "C:\clones"
$ezaCompPath = $CompRoot + "\eza\completions\pwsh\_eza.ps1"
if (Test-Path $ezaCompPath) {
    # Read the raw script text
    $rawScript = Get-Content $ezaCompPath -Raw
    # Use regex to find "-CommandName 'eza'" (ignoring quotes/case) and replace it with 'ls'
    $lsScript = $rawScript -replace "(?i)-CommandName\s+['""]?eza['""]?", "-CommandName 'ls'"
    # Run the modified script in memory to register the completion for 'ls'
    Invoke-Expression $lsScript
}

Remove-Item alias:cat -ErrorAction SilentlyContinue
function cat {
    bat @args
}

# zellij completions generated through zellij setup --generate-completion powershell
. "$PSScriptRoot\zellij_comp.ps1"

