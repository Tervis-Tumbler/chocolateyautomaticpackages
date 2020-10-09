$ErrorActionPreference = 'Stop'

$PackageName = 'visio-standard-2016-click-to-run'
$url       = 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_11615-33602.exe'
$checksum  = '32E7B305E26680C8F40795723190AEBC4C7BF28B50E1DAB2462B56BE2B59CEAD'
$PackageVersion  = "16.0.11615.33602"

$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installConfigFileLocation = $(Join-Path $toolsDir 'install.xml')
$uninstallConfigFileLocation = $(Join-Path $toolsDir 'uninstall.xml')
$ignoreExtractFile = "officedeploymenttool.exe.ignore"
$ignoreSetupFile = "setup.exe.ignore"

# Argument defaults
$arch = 32
$logPath = "%TEMP%"
$lang = "en-us"

$arguments = @{}

$packageParameters = $env:chocolateyPackageParameters

if ($packageParameters) {
    $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z0-9]+))"
    $option_name = 'option'
    $value_name = 'value'

    if ($packageParameters -match $match_pattern ){
        $results = $packageParameters | Select-String $match_pattern -AllMatches
        $results.matches | % {
            $arguments.Add(
                $_.Groups[$option_name].Value.Trim(),
                $_.Groups[$value_name].Value.Trim())
        }
    }
    else
    {
        Throw "Package Parameters were found but were invalid (REGEX Failure)"
    }

    if ($arguments.ContainsKey("64bit")) {
        Write-Host "Installing 64-bit version."
        $arch = 64
    } else {
        Write-Host "Installing 32-bit version."
    }
    
    if ($arguments.ContainsKey("Language")) {
        Write-Host "Installing language variant $($arguments['Language'])."
        $lang = $arguments["Language"]
    }

    if ($arguments.ContainsKey("LogPath")) {
        Write-Host "Installation log in directory $($arguments['LogPath'])"
        $logPath = $arguments["LogPath"]
    }

} else {
    Write-Debug "No Package Parameters Passed in"
    Write-Host "Installing 32-bit version."
    Write-Host "Installing language variant en-us."
    Write-Host "Installation log in directory %TEMP%"
}

$installConfigData = @"
<Configuration>
  <Add OfficeClientEdition="$arch">
    <Product ID="VisioStdXVolume" PIDKEY="NY48V-PPYYH-3F4PX-XJRKJ-W4423">
      <Language ID="$lang" />
    </Product>
  </Add>  
  <Display Level="None" AcceptEULA="TRUE" />  
  <Logging Level="Standard" Path="$logPath" /> 
  <Property Name="FORCEAPPSHUTDOWN" Value="True" />
</Configuration>
"@

$uninstallConfigData = @"
<Configuration>
  <Remove>
    <Product ID="VisioStdXVolume">
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

New-Item -Path $toolsDir -Name $ignoreSetupFile -ItemType File -Force
New-Item -Path $toolsDir -Name $ignoreExtractFile -ItemType File -Force

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

