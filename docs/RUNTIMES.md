# Recovering original runtime files from YOUR installation

This kit does not bundle Visual Basic 5 runtimes, ActiveX/OCX files, or the proprietary sound DLL. To collect these from a legitimate working Windows 7 (or XP) VM installation:

1. On the VM, copy the `MordorII-Win11-Compat-v0.1.0` kit onto the VM desktop.
2. Run `COLLECT-RUNTIMES.cmd` from the kit directory. It checks the kit directory, Windows, Windows\System32, Windows\SysWOW64, and the common Program Files\Mordor II folders. It copies the seven named files to a new folder, `Mordor-Runtimes`, next to the collector. Copy this *folder* from VM to the Windows 11 machine, next to `INSTALL-COMPAT.cmd`.
3. The installer copies `DWSW32.DLL` and `MSVBVM50.DLL` into the game directory; it copies the four standard OCXs (and optional `THREED32.OCX`) into a `Legacy` subfolder.
4. After that, use the separate admin-only registration step from the main README.

Expected files:

- `DWSW32.DLL` — original game sound support library. **No silent bypass by default**.
- `MSVBVM50.DLL` — Microsoft Visual Basic 5 runtime.
- `COMCTL32.OCX` — VB controls.
- `COMDLG32.OCX` — VB file/dialog controls.
- `MSWINSCK.OCX` — VB networking controls.
- `TABCTL32.OCX` — VB tab controls.
- `THREED32.OCX` — optional old 3D controls (not auto-registered).

`MGRAPH32.DLL` is already in your legitimate *game installation* and is registered during setup. You need a complete game folder, not only its main EXE.

Do **not** share the `Mordor-Runtimes` folder as part of a public GitHub release. Do not download untrusted copies from random DLL-download sites. The release is intentionally a **compatibility-only patch**.
