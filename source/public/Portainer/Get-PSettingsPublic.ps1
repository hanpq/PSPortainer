function Get-PSettingsPublic
{
    <#
    .DESCRIPTION
        Retreives Portainer Public Settings
    .PARAMETER Session
        Optionally define a portainer session object to use. This is useful when you are connected to more than one portainer instance.

        -Session $Session
    .EXAMPLE
        Get-PSettingsPublic

        Retreives Portainer Public Settings
    #>

    [CmdletBinding()]
    param(
        [Parameter()][PortainerSession]$Session = $null
    )

    InvokePortainerRestMethod -NoAuth -Method Get -RelativePath '/settings/public' -PortainerSession:$Session

}
#endregion
