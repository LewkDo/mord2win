# Mordor II: Darkness Awakening v0.992b — Windows 11 Compatibility Kit

**Community release candidate v0.1.0 (2026-10-29). Unofficial.**

Makes an *already installed* copy of the original Mordor II v0.992b demo usable on modern **Windows 11 x64** without modifying the original game's EXE. The tested configuration launched, loaded a saved character, entered the OpenGL 3D dungeon, and played audio and MIDI music on **one** Windows 11 system. Other hardware/Windows builds have **not** been verified; this is not a native 64-bit port.

## What's in here

- An original 32-bit `opengl.dll` **export-forwarder**, mapping 46 old OpenGL/Win32 API names to modern Windows `opengl32.dll` / `gdi32.dll`. This is a 4,096-byte compatibility DLL, not the copyrighted game renderer.
- Installation, launch, integrity-check, ActiveX registration and audio-check scripts.
- The corresponding shim `.def` export map, minimal C source and build notes.
- A helper to collect runtime files from **your own** working Windows 7 installation.

**Not included:** the game EXE, any maze/data/graphics, saved games, `DWSW32.DLL`, `MSVBVM50.DLL`, `.OCX` files, Windows system DLLs, or other proprietary game assets. 

## Obtain game files legally

Mordor II is still listed by the rightsholder. Original playable beta and updated-installer information: https://www.decklinsdemise.com/mordor2.htm . The original installer may not run correctly on current Windows. Use your own legitimate installation/media and, if necessary, install in a Windows 7 VM and copy the **complete** game folder.

This kit supports the exact **v0.992b** executable only:
`Mordor II.exe` SHA-256 `F5FD8A55BB2B71D74BB7C2E2C7147EAF19B4E6F0C49BC80CF4C2A136710BA382`.

## Quick installation (Windows 11 x64)

1. **Back up** your existing saves and whole game directory. Use a fresh directory, e.g. `C:\Games\Mordor II`, containing your complete game installation. This includes `Data\M2ObjectsI.MDR` (1,412,854 bytes); skipping this file causes "Error loading the Maze Object Index Data!".
2. If you installed on a Windows 7 VM, run **`COLLECT-RUNTIMES.cmd` in this kit on the VM** to collect legacy support files. Copy its `Mordor-Runtimes` directory next to `INSTALL-COMPAT.cmd` on Windows 11. The collector does not grab game files or make registry changes. If you already have all seven files, collection is unnecessary. See `docs/RUNTIMES.md`.
3. On Windows 11, double-click `INSTALL-COMPAT.cmd`. Enter the full folder containing `Mordor II.exe`. Or run `INSTALL-COMPAT.cmd -GameDir "C:\Games\Mordor II"`. The installer verifies hashes, copies only the compatibility DLL and helper scripts, and optionally copies **your** collected runtimes. **No administrator rights needed for this step**.
4. Run `C:\Games\Mordor II\MordorCompat\CHECK-MORDOR.cmd` to check required files.
5. Right-click `C:\Games\Mordor II\MordorCompat\REGISTER-CONTROLS.cmd` and choose **Run as administrator**. This registers the 32-bit game graphics library and four older 32-bit ActiveX controls using **`%WINDIR%\SysWOW64\regsvr32.exe`**. It changes system COM registration (backup/snapshot recommended), but does not replace Windows system DLLs. Check `MordorCompat\Logs\Registration-Results.txt`.
6. **Power on/connect your headphones, speakers, or audio interface before launching.** Verify Windows Sound output is enabled. Then start `C:\Games\Mordor II\PLAY-MORDOR-WIN11.cmd` normally (not as admin). Test menu, character, dungeon, sound effects and music.

## Audio caveat — important

On our tested Windows 11 system, `waveOutGetNumDevs()` returned **zero** while wireless headphones were turned off. Starting the original `DWSW32.DLL` in that condition caused a `0xC0000005` crash inside `winmmbase.dll`. With headphones connected, Windows reported **one wave output device**, and the **unmodified original sound DLL worked**, including audio and music. This correlation doesn't prove that every similar crash has the same cause.

**This release does NOT ship or enable the experimental 5-byte silent-audio patch.** Use your legitimate, original `DWSW32.DLL`. Run `MordorCompat\PROBE-AUDIO.cmd` if in doubt; it checks the 32-bit WinMM device counts and may itself crash if the Windows audio subsystem is broken.

## Important limits / safety

- Only one PC configuration was user-tested. This compatibility **release package and its installer scripts have not been run on a Windows machine here**. Treat this as v0.1.0 preview.
- A legacy 32-bit VB5 executable, OCX controls and graphics library are **old and not security-audited**. Use a disposable VM first, particularly if you're obtaining game files from an untrusted source.
- COM registration writes to the **machine-wide** 32-bit registry view and can impact other applications. Registration is **not automatically invoked** by the installer. Do not register unknown DLLs. No automatic uninstaller of global COM registrations is provided; unregistering controls shared with other applications can break those applications.
- Don't drop old DLLs into Windows `System32` or `SysWOW64`. Place game-specific files in the game directory or `Legacy` as shown.
- Keep saved games backed up before upgrading or experimenting.
- The engine requires 32-bit Windows compatibility (WOW64) even on 64-bit Windows; this kit cannot run on Windows ARM if 32-bit x86 app emulation is unavailable.

## Troubleshooting

See `docs/TROUBLESHOOTING.md`, especially for a missing maze-index file, ActiveX registration, a `winmmbase.dll` crash, or graphics failures. `MordorCompat\CHECK-MORDOR.cmd` reports missing files and checks specific hashes. The OpenGL shim is a *local* DLL and can be removed to revert; the installation script backs up a different existing `opengl.dll` before replacing it (after asking).

## Rights and license

The scripts and original shim source/binary in this patch are distributed under the **MIT License** (`LICENSE`). This license covers **only the work in this compatibility kit**, not Mordor II, its assets, Microsoft VB runtimes/OCXs, or third-party drivers. Names are used for compatibility identification. Unofficial fan project; not associated with or endorsed by the game rights holder or Microsoft. Game and runtime redistribution require authorization from the respective copyright owners.
