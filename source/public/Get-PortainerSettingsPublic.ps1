<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "996ce218-a4b8-42ed-9e92-58f2c379685e",
  "FILENAME": "Get-PSettingsPublic.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-23",
  "COMPANYNAME": "GetPS",
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Get-PSettingsPublic
{
    <#
    .DESCRIPTION
        Retreives Portainer Public Settings
    .EXAMPLE
        Get-PSettingsPublic

        Retreives Portainer Public Settings
    #>

    [CmdletBinding()]
    param()

    InvokePortainerRestMethod -AuthRequired:$false -Method Get -RelativePath '/settings/public'

}
#endregion


