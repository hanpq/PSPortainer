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
