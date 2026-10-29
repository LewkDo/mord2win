param(
    [string]$GameDir,
    [string]$RuntimeDir
)
$ErrorActionPreference = 'Stop'
$kit = Split-Path -Parent $PSScriptRoot
$expectedExe = 'F5FD8A55BB2B71D74BB7C2E2C7147EAF19B4E6F0C49BC80CF4C2A136710BA382'
$expectedShim = '08470BD700B5551D079961C43DB5EE235606A1356347CCC9E5C3F02155E21C59'
$expectedIndex = '11B3267A71E79C9FD6B4C70233AFDFEC9072A742A7ACE1CD567CA5DD2F8C8C60'

function H([string]$path) { (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToUpperInvariant() }
function Expected([string]$folder, [string]$name) {
    $p = Join-Path $folder $name
    if (-not (Test-Path -LiteralPath $p -PathType Leaf)) { throw "Required game file missing: $p" }
    return $p
}
if ([string]::IsNullOrWhiteSpace($GameDir)) {
    $GameDir = Read-Host 'Full directory containing Mordor II.exe (example: C:\Games\Mordor II)'
}
$GameDir = $GameDir.Trim().Trim('"')
if (-not (Test-Path -LiteralPath $GameDir -PathType Container)) { throw "Game directory does not exist: $GameDir" }
$GameDir = (Resolve-Path -LiteralPath $GameDir).ProviderPath
$exe = Expected $GameDir 'Mordor II.exe'
$exeHash = H $exe
if ($exeHash -ne $expectedExe) {
    throw "Unrecognized game EXE. This release supports ONLY Mordor II v0.992b with SHA256 $expectedExe; found $exeHash. No files changed."
}
$null = Expected $GameDir 'MDV.dll'
$null = Expected $GameDir 'MGRAPH32.DLL'
$index = Expected $GameDir 'Data\M2ObjectsI.MDR'
if ((H $index) -ne $expectedIndex) { throw 'Maze index file hash differs from the tested v0.992b release. No files changed.' }
$shim = Join-Path $kit 'bin\opengl.dll'
if ((H $shim) -ne $expectedShim) { throw 'Compatibility DLL failed SHA256 verification. No files changed.' }

Write-Host "Verified exact supported build at: $GameDir" -ForegroundColor Green
Write-Host 'This kit does not include or download the game, Visual Basic, OCX, or sound runtime files.'
$targetShim = Join-Path $GameDir 'opengl.dll'
if (Test-Path -LiteralPath $targetShim -PathType Leaf) {
    if ((H $targetShim) -eq $expectedShim) {
        Write-Host 'OpenGL shim already installed: unchanged.'
    } else {
        Write-Warning 'A DIFFERENT opengl.dll is already in the game directory.'
        $choice = Read-Host 'Back up and replace it with this kit? Type YES to proceed'
        if ($choice -cne 'YES') { throw 'User declined replacing existing opengl.dll; no OpenGL change made.' }
        $suffix = Get-Date -Format 'yyyyMMdd-HHmmss'
        $backup = Join-Path $GameDir ('opengl.dll.before-mordor-compat-' + $suffix + '.bak')
        Copy-Item -LiteralPath $targetShim -Destination $backup -ErrorAction Stop
        Copy-Item -LiteralPath $shim -Destination $targetShim -Force -ErrorAction Stop
        Write-Host "Previous DLL backed up to $backup"
    }
} else {
    Copy-Item -LiteralPath $shim -Destination $targetShim -ErrorAction Stop
}
if ((H $targetShim) -ne $expectedShim) { throw 'Failed to verify installed compatibility DLL.' }

# Optional user-owned runtime files, collected from the user's installation / VM.
# Never overwrite user-installed binaries. The registration step is separate and explicit.
if ([string]::IsNullOrWhiteSpace($RuntimeDir)) {
    $default = Join-Path $kit 'Mordor-Runtimes'
    if (Test-Path -LiteralPath $default -PathType Container) { $RuntimeDir = $default }
}
if (-not [string]::IsNullOrWhiteSpace($RuntimeDir)) {
    $RuntimeDir = $RuntimeDir.Trim().Trim('"')
    if (-not (Test-Path -LiteralPath $RuntimeDir -PathType Container)) { throw "Runtime directory not found: $RuntimeDir" }
    $legacy = Join-Path $GameDir 'Legacy'
    if (-not (Test-Path -LiteralPath $legacy -PathType Container)) { $null = New-Item -ItemType Directory -Path $legacy }
    foreach ($name in @('DWSW32.DLL','MSVBVM50.DLL','COMCTL32.OCX','COMDLG32.OCX','MSWINSCK.OCX','TABCTL32.OCX','THREED32.OCX')) {
        $src = Join-Path $RuntimeDir $name
        if (-not (Test-Path -LiteralPath $src -PathType Leaf)) { Write-Warning "Not supplied: $name"; continue }
        $destination = if ($name.EndsWith('.OCX')) { Join-Path $legacy $name } else { Join-Path $GameDir $name }
        if (Test-Path -LiteralPath $destination -PathType Leaf) {
            if ((H $src) -ne (H $destination)) { Write-Warning "Existing runtime preserved (not replaced): $destination" }
        } else {
            Copy-Item -LiteralPath $src -Destination $destination -ErrorAction Stop
            Write-Host "Copied user-provided $name"
        }
    }
}
$compat = Join-Path $GameDir 'MordorCompat'
if (-not (Test-Path -LiteralPath $compat -PathType Container)) { $null = New-Item -ItemType Directory -Path $compat }
$compatTools = Join-Path $compat 'Tools'
if (-not (Test-Path -LiteralPath $compatTools -PathType Container)) { $null = New-Item -ItemType Directory -Path $compatTools }
foreach ($name in @('Register-Controls.ps1','Check-Mordor.ps1','Probe-WinMM.ps1')) {
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot $name) -Destination (Join-Path $compatTools $name) -Force
}
foreach ($name in @('REGISTER-CONTROLS.cmd','CHECK-MORDOR.cmd','PROBE-AUDIO.cmd')) {
    Copy-Item -LiteralPath (Join-Path $kit $name) -Destination (Join-Path $compat $name) -Force
}
Copy-Item -LiteralPath (Join-Path $kit 'PLAY-MORDOR-WIN11.cmd') -Destination (Join-Path $GameDir 'PLAY-MORDOR-WIN11.cmd') -Force
Write-Host ''
Write-Host 'Compatibility setup complete (no administrator changes made).' -ForegroundColor Green
Write-Host ('1. Check files: ' + (Join-Path $compat 'CHECK-MORDOR.cmd'))
Write-Host ('2. Register controls AS ADMIN: ' + (Join-Path $compat 'REGISTER-CONTROLS.cmd'))
Write-Host ('3. Run game normally: ' + (Join-Path $GameDir 'PLAY-MORDOR-WIN11.cmd'))
Write-Host 'Connect and enable an audio output device BEFORE launching the game.'
Write-Host 'Close the game before changing your default audio device.'
