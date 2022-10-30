<#PSScriptInfo
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
    .PARAMETER Session
        Optionally define a portainer session object to use. This is useful when you are connected to more than one portainer instance.

        -Session $Session
    .EXAMPLE
        Get-PSession

        Returns the PortainerSession, if none is specified, it tries to retreive the default
    #>

    [CmdletBinding()]
    param(
        [Parameter()][PortainerSession]$Session = $null
    )

    if ($Session)
    {
        Write-Debug -Message 'Get-PSession; PortainerSession was passed as parameter'
        return $Session
    }
    elseif ($script:PortainerSession)
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


