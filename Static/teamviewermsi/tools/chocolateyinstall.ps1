$ErrorActionPreference = 'Stop';

$packageName= 'teamviewermsi'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = "\\fs1\DisasterRecovery\Programs\Teamviewer\Teamviewer 9 Full\TeamViewer-idcg83r3f6.msi"

$packageArgs = @{
  packageName = $packageName
  unzipLocation = $toolsDir
  fileType = 'msi'
  file = $fileLocation
  softwareName  = 'Teamviewer 9'
  checksum      = 'd5d5dc26c4b931023ae8d79a4936a417'
  checksumType  = 'md5'
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs
