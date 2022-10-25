﻿<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "2b51d232-02ef-490b-8ab1-4856de857152",
  "FILENAME": "Disconnect-Portainer.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-24",
  "COMPANYNAME": [],
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Disconnect-Portainer
{
    <#
    .DESCRIPTION
        .
    .PARAMETER Name
        Description
    .EXAMPLE
        Disconnect-Portainer
        Description of example
    #>

    [CmdletBinding()] # Enabled advanced function support
    param(
        [Parameter()][PortainerSession]$Session = $null
    )

    InvokePortainerRestMethod -Method Post -RelativePath '/auth/logout' -PortainerSession:$Session
    if ($Session)
    {
        if ($script:PortainerSession.SessionID -eq $Session.SessionID)
        {
            $script:PortainerSession = $null
        }
    }

}
#endregion

