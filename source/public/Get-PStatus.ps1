<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "8293c6f9-b146-4ce4-bccc-de87f9d6b27a",
  "FILENAME": "Get-PStatus.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-23",
  "COMPANYNAME": "GetPS",
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Get-PStatus
{
    <#
    .DESCRIPTION
        Get public status for portainer instance
    .PARAMETER Session
        Optionally define a portainer session object to use. This is useful when you are connected to more than one portainer instance.

        -Session $Session
    .EXAMPLE
        Get-PStatus

        Get public status for portainer instance
    #>
    [CmdletBinding()]
    param(
        [Parameter()][PortainerSession]$Session = $null
    )

    InvokePortainerRestMethod -NoAuth -Method Get -RelativePath '/status' -PortainerSession:$Session

}
#endregion


