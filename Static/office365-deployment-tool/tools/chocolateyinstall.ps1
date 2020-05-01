$ErrorActionPreference = 'Stop';

$packageName = 'office365-deployment-tool'
$packageVersion = "16.0.12624.20320"

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_12624-20320.exe' # download url
$installConfigFileLocation = $(Join-Path $toolsDir 'install.xml')
$uninstallConfigFileLocation = $(Join-Path $toolsDir 'uninstall.xml')
$ignoreExtractFile = "officedeploymenttool.exe.ignore"
$ignoreSetupFile = "setup.exe.ignore"
$checksum = "AE1CFCA801D21559032ECC5F44912B17735D85A8A568258E1A717A14C7738973"

# Package paramater defaults
$arch = 32
$sharedMachine = 0
$logPath = "%TEMP%"
$lang = "MatchOS"
$product = "O365ProPlusRetail"
$updateChannel = "Broad"

$params = Get-PackageParameters

if ($params.'64bit') {$arch = 64}
if ($params.Shared) {$sharedMachine = 1}
if ($params.Language) {$lang = $params.Language}
if ($params.LogPath) {$logPath = $params.LogPath}
if ($params.VolumeLicense) {$product = "ProPlus2019Volume"; $updateChannel = "PerpetualVL2019"}
if ($params.Project) {$product = "ProjectStd2019Volume"; $updateChannel = "PerpetualVL2019"}

Write-Host @"
Installing $product $arch-bit on the $updateChannel update channel
Logging to $logPath
"@

function Get-PreInstalledOfficeVersionArch () {
    $installedVersion = $null
    $installedArch = $null
    
    $installedOffice32 = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | `
        ForEach-Object { Get-ItemProperty $_.PSPath } | `
        Where-Object { $_ -match "Microsoft Office*" }

    $installedOffice64 = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | `
        ForEach-Object { Get-ItemProperty $_.PSPath } | `
        Where-Object { $_ -match "Microsoft Office*" }

    if ($installedOffice32) {
        $installedArch = 32
        [int]$installedVersion = $installedOffice32.DisplayVersion.Split(".")[0]
    } elseif ($installedOffice64) {
        $installedArch = 32
        [int]$installedVersion = $installedOffice64.DisplayVersion.Split(".")[0]
    }

    $officeVersionArch = @{"Version" = $installedVersion; "Architecture" = $installedArch}

    return $officeVersionArch
}

$PreinstalledOfficeVersionArch = Get-PreInstalledOfficeVersionArch

if ($PreinstalledOfficeVersionArch.Version -ne $null) {
    if ($PreinstalledOfficeVersionArch.Version -eq $packageVersion.Split(".")[0]) {
        Write-Error "This version of Office is already installed. Please uninstall prior installations to continue."
    } 
    if ($PreinstalledOfficeVersionArch.Architecture -ne $arch) {
        Write-Error "$($PreinstalledOfficeVersionArch.Architecture)-bit Office previously installed. `
        Cannot install Office $arch-bit without removing Office $($PreinstalledOfficeVersionArch.Architecture)-bit first."
    }
}

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
