$ErrorActionPreference = 'Stop';

$packageName= 'CiscoAgentDesktop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = "$(Join-Path -Path $toolsDir -ChildPath "CiscoAgentDesktop.msi")"
$compatibilityKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
$keyValue = "~ MSIAUTO"

if (!(Test-Path -Path $compatibilityKey)){
    
    New-Item -Name Layers -Path (Split-Path -Path $compatibilityKey -Parent)

}

if (!(Get-ItemProperty -Path $compatibilityKey).$fileLocation) {

    New-ItemProperty `
        -Path $compatibilityKey `
        -Name $fileLocation `
        -Value $keyValue `
        -PropertyType String |
        Out-Null

}

$packageArgs = @{
  packageName = $packageName
  unzipLocation = $toolsDir
  fileType = 'msi'
  file = $fileLocation
  softwareName  = 'Cisco Agent Desktop*'
  checksum      = '5E2BDF12E582B2E144F1454C3FFF33E2'
  checksumType  = 'md5'
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-ItemProperty `
    -Path $compatibilityKey `
    -Name $fileLocation |
    Out-Null