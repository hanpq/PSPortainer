<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "2b51d232-02ef-490b-8ab1-4856de857152",
  "FILENAME": "Disconnect-Portainer.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-24",
  "COMPANYNAME": "GetPS",
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Disconnect-Portainer
{
    <#
    .DESCRIPTION
        Disconnect and cleanup session configuration
    .PARAMETER Session
        Defines a PortainerSession object that will be disconnected and cleaned up.
    .EXAMPLE
        Disconnect-Portainer

        Disconnect from the default portainer session
    .EXAMPLE
        Disconnect-Portainer -Session $Session

        Disconnect the specified session
    #>

    [CmdletBinding()]
    param(
        [Parameter()][PortainerSession]$Session = $null
    )

    InvokePortainerRestMethod -Method Post -RelativePath '/auth/logout' -PortainerSession:$Session

    # Remove PortainerSession variable
    if ($Session)
    {
        if ($script:PortainerSession.SessionID -eq $Session.SessionID)
        {
            Remove-Variable PortainerSession -Scope Script
        }
    }
    else
    {
        Remove-Variable PortainerSession -Scope Script
    }

}
