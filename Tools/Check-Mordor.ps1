$ErrorActionPreference = 'Continue'
$game = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$bad = 0
Write-Host "Mordor II v0.992b - compatibility check for: $game"
$checks = @(
    @('Mordor II.exe','F5FD8A55BB2B71D74BB7C2E2C7147EAF19B4E6F0C49BC80CF4C2A136710BA382'),
    @('Data\M2ObjectsI.MDR','11B3267A71E79C9FD6B4C70233AFDFEC9072A742A7ACE1CD567CA5DD2F8C8C60'),
    @('opengl.dll','08470BD700B5551D079961C43DB5EE235606A1356347CCC9E5C3F02155E21C59')
)
foreach ($check in $checks) {
    $f = Join-Path $game $check[0]
    if (-not (Test-Path -LiteralPath $f -PathType Leaf)) { Write-Host "MISSING: $($check[0])" -ForegroundColor Red; $bad++; continue }
    if ((Get-FileHash -LiteralPath $f -Algorithm SHA256).Hash.ToUpperInvariant() -eq $check[1]) {
        Write-Host "OK: $($check[0])" -ForegroundColor Green
    } else { Write-Host "UNEXPECTED HASH: $($check[0])" -ForegroundColor Red; $bad++ }
}
foreach ($name in @('MDV.dll','MGRAPH32.DLL','DWSW32.DLL','MSVBVM50.DLL')) {
    if (Test-Path -LiteralPath (Join-Path $game $name) -PathType Leaf) { Write-Host "FOUND: $name" }
    else { Write-Host "MISSING: $name" -ForegroundColor Red; $bad++ }
}
foreach ($name in @('COMCTL32.OCX','COMDLG32.OCX','MSWINSCK.OCX','TABCTL32.OCX')) {
    if (Test-Path -LiteralPath (Join-Path (Join-Path $game 'Legacy') $name) -PathType Leaf) { Write-Host "FOUND: Legacy\$name" }
    else { Write-Host "MISSING: Legacy\$name" -ForegroundColor Red; $bad++ }
}
$aud = Join-Path $game 'DWSW32.DLL'
if (Test-Path -LiteralPath $aud -PathType Leaf) {
    $h = (Get-FileHash -LiteralPath $aud -Algorithm SHA256).Hash.ToUpperInvariant()
    if ($h -eq 'DC1CA679C8445A13907CAA2D1FC421A30E640E03BE1CC8C9D4948903BBD85519') {
        Write-Host 'Audio: Original sound DLL (matches tested build)' -ForegroundColor Green
    } elseif ($h -eq 'B725624499BDDFFEA1205DD74C58D1E6D3779307C67F37E6A5E2EA5C3130A108') {
        Write-Host 'Audio: Experimental silent bypass found; replace with YOUR original DLL for audio' -ForegroundColor Yellow
    } else { Write-Host "Audio DLL hash not recognized: $h" -ForegroundColor Yellow }
}
$log = Join-Path $game 'MordorCompat\Logs\Registration-Results.txt'
if (Test-Path -LiteralPath $log) { Write-Host 'COM registration log exists; inspect status in MordorCompat\Logs.' }
else { Write-Host 'No COM registration log: run MordorCompat\REGISTER-CONTROLS.cmd as admin.' -ForegroundColor Yellow }
Write-Host "Check completed with $bad missing / invalid required item(s)."
if ($bad -gt 0) { exit 1 } else { exit 0 }
