# Troubleshooting / known issues

### "Error loading the Maze Object Index Data!"

Ensure `Data\M2ObjectsI.MDR` exists directly under the game folder, is 1,412,854 bytes, and is uncorrupted. The Windows 11 case study had that file missing after extraction, despite its being present in the original installed-game ZIP. Re-extract it from **your legitimate installation**; it is not bundled in this patch.

### `winmmbase.dll` crash / 0xC0000005 / `waveOutGetNumDevs()`

On the successful test computer, Bluetooth headphones were off. Windows reported `waveOutGetNumDevs: 0 device(s)` and the old sound DLL crashed at startup. After the headphones were turned on, `waveOutGetNumDevs: 1 device(s)` and the original audio code worked, with sound effects and MIDI. Ensure an audio output device is powered on, enabled, and selected in Windows **before** launching the game. Run `MordorCompat\PROBE-AUDIO.cmd` to see the 32-bit Windows multimedia device counts. An alternative system/driver problem may also cause the same exception; zero devices is not conclusive proof of a root cause.

### ActiveX control error / COM class not registered

Run `MordorCompat\REGISTER-CONTROLS.cmd` **as administrator**, after copying the legacy files. The tool uses the **32-bit** regsvr32 and waits for completion. It logs actual results to `MordorCompat\Logs\Registration-Results.txt`. Blank exit codes from older scripts were a reporting bug. Registration can cause system-wide effects; VM backup recommended.

### The screen is black / 3D rendering doesn't work

Check that `opengl.dll` in the *game directory* matches the shim. `MordorCompat\CHECK-MORDOR.cmd` validates it. Keep the OpenGL DLL local to the game, **not** in Windows system folders. This build depends on the GPU driver's implementation of OpenGL provided by Windows. If you have a different legacy `opengl.dll`, the installer asks permission and backs it up before replacing it.

### Game doesn't start / old setup program doesn't run

Install the original game in a Windows 7 VM (32-bit may be easiest), and copy the **entire** installed folder to Windows 11 x64. Then collect original runtime dependencies from that same VM using the helper. The kit expects v0.992b; it rejects mismatched executables rather than patching unknown builds.

### First-run graphics options / game settings registry

The successful test machine had the following 32-bit registry-view values at one point in testing under `HKLM\Software\VB Designs\Mordor II`: `Limited=True`, `GLDetailLevel=4`, `GLMazeSpeed=250`, `NotFirstTime=True` (all REG_SZ). We have **not established** whether they are necessary for other systems. This public kit deliberately does not write them. Don't copy registry settings unless the normal setup is failing and you've backed up the relevant keys.

### Sound stays off after reinstall

This public kit does **not** include or install the experimental silent sound DLL. If you are migrating from an earlier testing ZIP, replace `DWSW32.DLL` with your unmodified original. `CHECK-MORDOR.cmd` detects the exact tested original and the earlier five-byte silent-patched version by SHA-256.

### Works on one PC but not another

Record Windows version, file check results, registration log, audio probe counts, and any Event Viewer application error. Do not publicly post personal saved games, private logs, email addresses, registry exports, or minidumps without checking for sensitive information first.
