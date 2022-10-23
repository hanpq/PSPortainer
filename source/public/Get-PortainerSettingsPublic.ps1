<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "996ce218-a4b8-42ed-9e92-58f2c379685e",
  "FILENAME": "Get-PortainerSettingsPublic.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-23",
  "COMPANYNAME": "GetPS",
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Get-PortainerSettingsPublic
{
    <#
    .DESCRIPTION
        Retreives Portainer Public Settings
    .EXAMPLE
        Get-PortainerSettingsPublic

        Retreives Portainer Public Settings
    #>

    [CmdletBinding()]
    param()

    InvokePortainerRestMethod -AuthRequired:$false -Method Get -RelativePath '/settings/public'

}
#endregion


