$ErrorActionPreference = 'Stop';

$packageName = 'project-standard-clicktorun'
$packageVersion = "16.0.12827.20268"

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_12827-20268.exe' # download url
$installConfigFileLocation = $(Join-Path $toolsDir 'install.xml')
$uninstallConfigFileLocation = $(Join-Path $toolsDir 'uninstall.xml')
$ignoreExtractFile = "officedeploymenttool.exe.ignore"
$ignoreSetupFile = "setup.exe.ignore"
$checksum = "142F201295459271DD0DA2CC07A8A36DFB99E78782014C3663C69573BB57D5D4"

# Package paramater defaults
$arch = 32
$sharedMachine = 0
$logPath = "%TEMP%"
$lang = "MatchOS"
$product = "ProjectStd2019Volume"
# $updateChannel = "Broad"
$updateChannel = "PerpetualVL2019"

$params = Get-PackageParameters

if ($params.'64bit') {$arch = 64}

Write-Host @"
Installing $product $arch-bit on the $updateChannel update channel
Logging to $logPath
"@

$installConfigData = @"
<Configuration>
  <Add OfficeClientEdition="$arch" Channel="$updateChannel">
    <Product ID="$product">
      <Language ID="$lang" />
    </Product>
  </Add>  
  <Display Level="None" AcceptEULA="TRUE" />  
  <Logging Level="Standard" Path="$logPath" /> 
  <Property Name="SharedComputerLicensing" Value="$sharedMachine" />  
</Configuration>
"@

$uninstallConfigData = @"
<Configuration>
  <Remove>
    <Product ID="$product">
      <Language ID="$lang" />
    </Product>
  </Remove>
  <Display Level="None" AcceptEULA="TRUE" />  
  <Logging Level="Standard" Path="$logPath" /> 
  <Property Name="FORCEAPPSHUTDOWN" Value="True" />
</Configuration>
"@

$installConfigData | Out-File $installConfigFileLocation
$uninstallConfigData | Out-File $uninstallConfigFileLocation

New-Item -Path $toolsDir -Name $ignoreSetupFile -ItemType File
New-Item -Path $toolsDir -Name $ignoreExtractFile -ItemType File

$extractPackage = Get-ChocolateyWebFile -PackageName $packageName -FileFullPath "$toolsDir\officedeploymenttool.exe" -Url $url -Checksum $checksum -ChecksumType SHA256

$statements = "/extract:$toolsDir /quiet /norestart"

$setupPackageArgs = @{
  packageName = $packageName
  fileType = 'EXE'
  file = $(Join-Path $toolsDir "setup.exe")
  silentArgs = "/configure $installconfigFileLocation"
}

Start-ChocolateyProcessAsAdmin -Statements "$statements" -ExeToRun $extractPackage

Install-ChocolateyInstallPackage @setupPackageArgs
