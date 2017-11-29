$ErrorActionPreference = 'Stop';

$packageName= 'teamviewer12msi'
$packageVersion = "12.0.88438"
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = "$toolsDir\TeamViewer-idcg83r3f6.msi"

$packageArgs = @{
  packageName = $packageName
  unzipLocation = $toolsDir
  fileType = 'msi'
  file = $fileLocation
  softwareName  = 'Teamviewer 12'
  checksum      = '0A60DC5207CF666F9B9BB2DCEC9F8E526F60338018EEF743FA4E86FA517CFD8F'
  checksumType  = 'sha256'
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs
