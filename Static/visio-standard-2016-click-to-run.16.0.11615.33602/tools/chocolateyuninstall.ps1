$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$uninstallConfigFileLocation = $(Join-Path $toolsDir 'uninstall.xml')
$deploymentTool = $(Join-Path $toolsDir 'setup.exe')
$silentArgs = "/configure $uninstallConfigFileLocation"
$installerType = 'EXE'
$packageName = 'visio-standard-2016-click-to-run'

Uninstall-ChocolateyPackage -PackageName $packageName `
                            -FileType $installerType `
                            -SilentArgs "$silentArgs" `
                            -File "$deploymentTool"