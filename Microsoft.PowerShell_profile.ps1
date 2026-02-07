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
