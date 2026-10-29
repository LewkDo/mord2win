# For use only on a VM where the user has legitimately installed the game.
# Does not modify the source VM installation.
$ErrorActionPreference = 'Continue'
$out = Join-Path $PSScriptRoot '..\Mordor-Runtimes'
if (-not (Test-Path -LiteralPath $out -PathType Container)) { $null = New-Item -ItemType Directory -Path $out }
$gameCandidates = @('C:\Program Files\Mordor II','C:\Program Files (x86)\Mordor II')
$dirs = @($PSScriptRoot, $env:WINDIR, (Join-Path $env:WINDIR 'System32'))
$dirs += (Join-Path $env:WINDIR 'SysWOW64')
$dirs += $gameCandidates
$names = @('DWSW32.DLL','MSVBVM50.DLL','COMCTL32.OCX','COMDLG32.OCX','MSWINSCK.OCX','TABCTL32.OCX','THREED32.OCX')
$fail = 0
Write-Host "Copying game dependencies to: $out"
foreach ($name in $names) {
    $src = $null
    foreach ($dir in $dirs) {
        $candidate = Join-Path $dir $name
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { $src = $candidate; break }
    }
    if ($null -eq $src) { Write-Host "NOT FOUND: $name" -ForegroundColor Yellow; $fail++; continue }
    Copy-Item -LiteralPath $src -Destination (Join-Path $out $name) -Force
    Write-Host "Collected $name"
}
Write-Host 'Move this Mordor-Runtimes folder to the Windows 11 PC next to INSTALL-COMPAT.cmd.'
Write-Host 'Collected files are for personal use; do NOT upload/distribute these DLLs or OCXs.'
if ($fail -gt 0) { Write-Host "$fail file(s) not found. See README for manual options."; exit 1 }
exit 0
