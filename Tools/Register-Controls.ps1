$ErrorActionPreference = 'Stop'
$compat = Split-Path -Parent $PSScriptRoot
$game = Split-Path -Parent $compat
$legacy = Join-Path $game 'Legacy'
$reg = Join-Path $env:WINDIR 'SysWOW64\regsvr32.exe'
$logDir = Join-Path $compat 'Logs'
if (-not (Test-Path -LiteralPath $logDir -PathType Container)) { $null = New-Item -ItemType Directory -Path $logDir }
$log = Join-Path $logDir 'Registration-Results.txt'
function Report([string]$message) {
    Write-Host $message
    Add-Content -LiteralPath $log -Value $message -Encoding UTF8
}
Set-Content -LiteralPath $log -Value ('Mordor II legacy COM registration - ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')) -Encoding UTF8
$admin = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $admin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Report 'ERROR: Right-click REGISTER-CONTROLS.cmd and Run as administrator.'
    exit 1
}
if (-not (Test-Path -LiteralPath $reg -PathType Leaf)) {
    Report 'ERROR: 32-bit regsvr32 not found. This kit requires Windows x64 with WOW64.'
    exit 1
}
$env:PATH = "$game;$legacy;" + $env:PATH
$targets = @((Join-Path $game 'MGRAPH32.DLL'))
foreach ($name in @('COMCTL32.OCX','COMDLG32.OCX','MSWINSCK.OCX','TABCTL32.OCX')) {
    $targets += (Join-Path $legacy $name)
}
Report ('Using 32-bit regsvr32: ' + $reg)
$bad = 0
foreach ($target in $targets) {
    if (-not (Test-Path -LiteralPath $target -PathType Leaf)) { Report ('MISSING: ' + $target); $bad++; continue }
    Report ('Registering: ' + $target)
    try {
        $arg = '/s "' + $target + '"'
        $proc = Start-Process -FilePath $reg -ArgumentList $arg -WorkingDirectory (Split-Path -Parent $target) -Wait -PassThru -ErrorAction Stop
        if ($null -ne $proc.ExitCode -and $proc.ExitCode -eq 0) { Report 'OK: exit 0' }
        else {
            Report ('FAILED: exit code ' + $proc.ExitCode)
            Report ('For a GUI error message, run as admin: ' + $reg + ' "' + $target + '"')
            $bad++
        }
    } catch { Report ('ERROR: ' + $_.Exception.Message); $bad++ }
}
Report 'THREED32.OCX intentionally not auto-registered.'
if ($bad -eq 0) { Report 'SUCCESS: All five registration commands exited 0. Game behavior not guaranteed.'; exit 0 }
Report ("Failed registrations: $bad")
exit 1
