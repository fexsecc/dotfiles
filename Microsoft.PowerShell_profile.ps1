New-Alias vim nvim
Import-Module PSReadline
$Env:KOMOREBI_CONFIG_HOME = $ENV:HOMEDRIVE + $ENV:HOMEPATH + '\.config\komorebi'
$Env:NODE_REPL_HISTORY = $ENV:HOMEDRIVE + $ENV:HOMEPATH + '\.config\node\node_repl_history'

function prompt {
    $p = $executionContext.SessionState.Path.CurrentLocation
    if ($p.Provider.Name -eq "FileSystem") {
        $e = [char]27
        $path = $p.ProviderPath -Replace "\\", "/"
        "$e]7;file://${env:COMPUTERNAME}/${path}$e\" + "PS $p> "
    } else {
        "PS $p> "
    }
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


