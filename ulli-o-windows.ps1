
echo "ULLI-organic USB-less Linux Installer"

echo "Options:"

echo "1: Install Linux Mint 22.3"

echo "2: Install other ISO"

Do {

$option = Read-Host -Prompt 'Type 1 or 2 and hit Enter to select option'

}

Until ($option -eq '1' -or $option -eq '2' )

$PartInfo = Get-Partition -DriveLetter C
$DiskInfo = Get-Disk $PartInfo.DiskNumber
$ShrinkTo = $DiskInfo.Size - (7 * 1024 * 1024 * 1024)
Resize-Partition -DriveLetter C -Size $ShrinkTo
New-Partition -DiskNumber 0 -Size 100MB -DriveLetter V
New-Partition -DiskNumber 0 -UseMaximumSize -DriveLetter L
Format-Volume -DriveLetter V -FileSystem FAT32
Format-Volume -DriveLetter L -FileSystem FAT32

Import-Module BitsTransfer

if ( $option -eq 1 )
{
	
    Start-BitsTransfer -Source "https://pub.linuxmint.io/stable/22.3/linuxmint-22.3-cinnamon-64bit.iso" -Destination "C:\linuxmint.iso"
	
	$iso_location = "C:\linuxmint.iso"
	
}

if ( $option -eq 2 )
{
	
	Do {

		$file = Read-Host -Prompt 'Full path and name of ISO file (including .iso)'

	}

	Until ( [System.IO.File]::Exists($file) -eq "True" )
	
	$iso_location = $file
	
}

Start-BitsTransfer -Source "https://sourceforge.net/projects/refind/files/0.14.2/refind-bin-0.14.2.zip/download" -Destination "C:\refind.zip"

$mountResult = Mount-DiskImage -ImagePath $iso_location -PassThru

$driveLetter = ($mountResult | Get-Volume).DriveLetter + ":\"

robocopy $driveLetter "L:\" /E /ZB

Expand-Archive C:\refind.zip -DestinationPath V:\

bcdboot C:\Windows

bcdedit /copy "{bootmgr}" /d "Windows"

bcdedit /set "{bootmgr}" device partition=L:

bcdedit /set "{bootmgr}" path \EFI\boot\bootx64.efi

bcdedit /copy "{bootmgr}" /d "Linux"

bcdedit /set "{bootmgr}" device partition=V:

bcdedit /set "{bootmgr}" path refind-bin-0.14.2\refind\refind_x64.efi

bcdedit /set "{fwbootmgr}" default "{bootmgr}"

bcdedit /default "{fwbootmgr}"

Restart-Computer
