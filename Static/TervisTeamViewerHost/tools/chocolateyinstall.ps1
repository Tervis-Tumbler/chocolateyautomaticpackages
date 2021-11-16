$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# Internal packages (organizations) or software that has redistribution rights (community repo)
# - Use `Install-ChocolateyInstallPackage` instead of `Install-ChocolateyPackage`
#   and put the binaries directly into the tools folder (we call it embedding)
$fileLocation = Join-Path $toolsDir 'TeamViewer_Host_Setup.exe'
# If embedding binaries increase total nupkg size to over 1GB, use share location or download from urls

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  file         = $fileLocation
  
  softwareName  = 'TeamViewer*'
  
  checksum      = '1D0BDA2364034D8F20082DFF5E17EA10CB0CA7B3099A8DCC5F8DB90B37FE6A21'
  checksumType  = 'sha256'
  checksum64    = '1D0BDA2364034D8F20082DFF5E17EA10CB0CA7B3099A8DCC5F8DB90B37FE6A21'
  checksumType64= 'sha256'
  
  silentArgs    = "/S /norestart"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs

  