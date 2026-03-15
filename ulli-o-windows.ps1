
# Self Elevate Script to Administrator Mode
If (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Sleep 1
    $pwshexe = (Get-Command 'powershell.exe').Source
    Start-Process $pwshexe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f "%userprofile%\Downloads\ulli-organic\ulli-o-windows.ps1") -Verb RunAs
    }

$PartInfo = Get-Partition -DriveLetter C
$DiskInfo = Get-Disk $PartInfo.DiskNumber
$ShrinkTo = $DiskInfo.Size - (7 * 1024 * 1024 * 1024)
Resize-Partition -DriveLetter C -Size $ShrinkTo
New-Partition -DiskNumber 0 -UseMaximumSize -DriveLetter L
Format-Volume -DriveLetter L -FileSystem FAT32

Import-Module BitsTransfer
Start-BitsTransfer -Source "https://pub.linuxmint.io/stable/22.3/linuxmint-22.3-cinnamon-64bit.iso" -Destination "C:\linuxmint.iso" 

Mount-DiskImage -ImagePath "C:\linuxmint.iso"