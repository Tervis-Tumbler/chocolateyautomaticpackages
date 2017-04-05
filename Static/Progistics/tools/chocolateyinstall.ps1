$ErrorActionPreference = 'Stop';

$packageName= 'Progistics'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = "$(Join-Path -Path $toolsDir -ChildPath 'ConnectShipToolkitSetup-6.5.exe')"

$packageArgs = @{
  packageName = $packageName
  unzipLocation = $toolsDir
  fileType = 'EXE'
  file = $fileLocation
  softwareName  = 'ConnectShip Progistics*'
  checksum      = '2B4239B5E0987541DA1878A2E52A4F738C80E995F5556C17CDF5B932A6ADB02D'
  checksumType  = 'SHA256'
  silentArgs    = "/S /RESPONSE=$env:chocolateyPackageParameters /ACCEPTEULA"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs