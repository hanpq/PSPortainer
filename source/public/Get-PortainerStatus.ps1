<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "8293c6f9-b146-4ce4-bccc-de87f9d6b27a",
  "FILENAME": "Get-PortainerStatus.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-23",
  "COMPANYNAME": "GetPS",
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Get-PortainerStatus
{
    <#
    .DESCRIPTION
        Get public status for portainer instance
    .EXAMPLE
        Get-PortainerStatus

        Get public status for portainer instance
    #>
    [CmdletBinding()]
    param()


    InvokePortainerRestMethod -AuthRequired:$false -Method Get -RelativePath '/status'

}
#endregion


