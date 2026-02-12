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
    $path = 'C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvarsall.bat'
    if (-not (Test-Path $path)) { throw "vcvarsall not found: $path" }

    # Run vcvarsall in cmd.exe and capture the environment it sets, then import into PowerShell
    cmd /c "`"$path`" amd64 & set" | ForEach-Object {
        if ($_ -match '^(.*?)=(.*)$') {
            $name  = $matches[1]
            $value = $matches[2]
            Set-Item -Force -Path "Env:$name" -Value $value
        }
    }
}

