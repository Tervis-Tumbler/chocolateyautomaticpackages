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
  
  checksum      = 'F00CCDEF4FF609D04CCD5ABDA2F78A8C5CE637A730BA3B1E7553A9B27FBA66DC'
  checksumType  = 'sha256'
  checksum64    = 'F00CCDEF4FF609D04CCD5ABDA2F78A8C5CE637A730BA3B1E7553A9B27FBA66DC'
  checksumType64= 'sha256'
  
  silentArgs    = "/S /norestart"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs

  