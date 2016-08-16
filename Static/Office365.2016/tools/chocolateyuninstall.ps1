$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$uninstallConfigFileLocation = $(Join-Path $toolsDir 'uninstall.xml')
$deploymentTool = $(Join-Path $toolsDir 'setup.exe')
$silentArgs = "/configure $uninstallConfigFileLocation"
$installerType = 'EXE'
$packageName = 'Office365.2016'

Uninstall-ChocolateyPackage -PackageName $packageName `
                            -FileType $installerType `
                            -SilentArgs "$silentArgs" `
                            -File "$deploymentTool"