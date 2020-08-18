Import-Module (Join-Path $PSScriptRoot "ScriptSupport") -DisableNameChecking -Global
#Creates volumes folders in the host
Confirm-VolumeFoldersExist -Path "C:\containers"
