/* Build-only marker to give the linker a COFF object.
   No original game code or old OpenGL DLL code is included.
   All API entry points are PE export forwarders configured at link time. */
void mordor_forwarder_marker(void) {}
