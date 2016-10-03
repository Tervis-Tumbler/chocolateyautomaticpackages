$ErrorActionPreference = 'Stop';

$packageName= 'CiscoJabber'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = "$(Join-Path -Path $toolsDir -ChildPath "CiscoJabberSetup.msi")"

$packageArgs = @{
  packageName = $packageName
  unzipLocation = $toolsDir
  fileType = 'msi'
  file = $fileLocation

  softwareName  = 'Cisco Jabber*'

  checksum      = 'E6B79BDBC013F10160FB192E9632D0E2'
  checksumType  = 'md5'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs