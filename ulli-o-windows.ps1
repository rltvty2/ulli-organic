
$PartInfo = Get-Partition -DriveLetter C
$DiskInfo = Get-Disk $PartInfo.DiskNumber
$ShrinkTo = $DiskInfo.Size - (7 * 1024 * 1024 * 1024)
Resize-Partition -DriveLetter C -Size $ShrinkTo
New-Partition -DiskNumber 0 -UseMaximumSize -DriveLetter L
Format-Volume -DriveLetter L -FileSystem FAT32

<#Import-Module BitsTransfer
Start-BitsTransfer -Source "https://pub.linuxmint.io/stable/22.3/linuxmint-22.3-cinnamon-64bit.iso" -Destination "C:\linuxmint.iso" 
#>

$mountResult = Mount-DiskImage -ImagePath "C:\linuxmint.iso" -PassThru

$driveLetter = ($mountResult | Get-Volume).DriveLetter + ":\"

robocopy $driveLetter "L:\" /E /ZB
