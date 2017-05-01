$ErrorActionPreference = 'Stop'

$packageName = "SQLAnywhere12"
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = "http://d5d4ifzqzkhwt.cloudfront.net/sqla12client/SQLA1201_Client.exe"

$downloadArgs = @{
    packageName = $packageName
    fileFullPath = "$toolsDir\SA12.exe"
    url = $url
    checksum = "B4288B1ACB939B30BEAA61323666A280A31E8F32D7147A556804425E8106DAED"
    checksumType = "SHA256"
}

$packageArgs = @{
    packageName = $packageName
    file = "$toolsDir\SA12\setup.exe"
    fileType = 'EXE'
    silentArgs = '/S "/v /qn SA32=1 SA64=1"'
}

Get-ChocolateyWebFile @downloadArgs
Get-ChocolateyUnzip -FileFullPath "$toolsDir\SA12.exe" -Destination "$toolsDir\SA12\"
Install-ChocolateyInstallPackage @packageArgs