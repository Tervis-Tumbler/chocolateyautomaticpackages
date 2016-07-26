choco update chocolateypackageupdater -y

Set-Location -Path C:\tools\ChocolateyPackageUpdater\

Move-Item -Path .\chocopkgup.exe.config -Destination .\chocopkgup.exe.config.bak -Force

$ChocoPkgUpConfig = @"
<?xml version="1.0"?>
<configuration>
  <appSettings>
    <add key="PackagesFolder" value="C:\GitHub\chocolateyautomaticpackages"/>
    <add key="TokenReplaceFileSearchPattern" value="*.txt|*.nuspec|*.ps1|*.config"/>
    <add key="PS1FileToExecute" value="ChocoPkgUp.ps1"/>
  </appSettings>
  <startup>
    <supportedRuntime version="v4.0" sku=".NETFramework,Version=v4.0"/>
  </startup>
</configuration>
"@

$ChocoPkgUpConfig | Out-File chocopkgup.exe.config
