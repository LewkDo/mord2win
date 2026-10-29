# Read-only 32-bit WinMM audio-device enumeration probe.
# The Windows API can crash the PowerShell test process if the OS audio subsystem is faulty.
$ErrorActionPreference = 'Stop'
Write-Host "Architecture (64-bit process): $([Environment]::Is64BitProcess)"
Write-Host "Windows version: $([Environment]::OSVersion.VersionString)"
$source = @'
using System;
using System.Runtime.InteropServices;
public static class MordorAudioProbe {
    [DllImport("winmm.dll", ExactSpelling=true, CallingConvention=CallingConvention.Winapi)]
    public static extern UInt32 waveOutGetNumDevs();
    [DllImport("winmm.dll", ExactSpelling=true, CallingConvention=CallingConvention.Winapi)]
    public static extern UInt32 midiOutGetNumDevs();
}
'@
Add-Type -TypeDefinition $source
Write-Host 'Calling waveOutGetNumDevs()...'
$n = [MordorAudioProbe]::waveOutGetNumDevs()
Write-Host "waveOutGetNumDevs: $n device(s)"
Write-Host 'Calling midiOutGetNumDevs()...'
$m = [MordorAudioProbe]::midiOutGetNumDevs()
Write-Host "midiOutGetNumDevs: $m device(s)"
Write-Host 'Probe completed without a crash.'
