# Release notes — v0.1.0 Preview (2026-10-29)

**Scope:** Windows 11 x64 compatibility helper for Mordor II: Darkness Awakening v0.992b, not a 64-bit port. Validated with user feedback on one Windows 11 system.

## Observed working after troubleshooting

- v0.992b game starts; saved character loads; 3D dungeon renders; sound and MIDI music play.
- Main game EXE, assets, and sound engine can remain unmodified.
- 32-bit OpenGL forwarder resolves the renderer's 46 legacy imports.
- Original VB5 runtime and 32-bit ActiveX controls need to be available and some registered.
- A powered-off audio output device correlated with a crash in the original sound detection; enabling the device resolved it for this test.

## This release includes

- `bin/opengl.dll` shim and corresponding source/export mapping.
- User-owned runtime collector, installation / launch / ActiveX registration / health check / audio probe scripts.
- Hash checks to avoid applying against unrelated EXEs and data.
- Guide and security/redistribution limitations.

## Explicitly excluded

- Game program and game content, runtime DLLs/OCXs, saves, DRM changes, proprietary patches.
- The experimental silent-audio bypass, which is *not needed* for the successful configuration.

## Known limits

Only one Windows 11 machine reported successful gameplay. The new scripts/package have been statically checked but have not yet been runtime-tested on a separate clean Windows install. Treat this as a **preview**, and report reproducibility results before changing the release status to stable.
