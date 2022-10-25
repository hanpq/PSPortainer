﻿<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "9a38dcb2-9a2b-45fc-b938-b36e5a96e4d4",
  "FILENAME": "Get-PortainerSession.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-24",
  "COMPANYNAME": "GetPS",
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Get-PSession
{
    <#
    .DESCRIPTION
        Displays the Portainer Session object.
    .EXAMPLE
        Get-PSession
        Description of example
    #>

    [CmdletBinding()]
    param(
    )

    if ($script:PortainerSession)
    {
        Write-Debug -Message 'Get-PSession; PortainerSession found in script scope'
        return $script:PortainerSession
    }
    else
    {
        Write-Error -Message 'No Portainer Session established, please call Connect-Portainer'
    }
}
#endregion


