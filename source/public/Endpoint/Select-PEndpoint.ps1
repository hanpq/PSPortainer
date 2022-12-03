function Select-PEndpoint
{
    <#
    .DESCRIPTION
        Configures the default endpoint to use
    .PARAMETER Endpoint
        Defines the endpoint name to select
    .PARAMETER Session
        Optionally define a portainer session object to use. This is useful when you are connected to more than one portainer instance.

        -Session $Session
    .EXAMPLE
        Select-PEndpoint -Endpoint 'prod'

        Set the default endpoint to use
    #>

    [CmdletBinding()]
    param(
        [Parameter()][string]$Endpoint,
        [Parameter()][PortainerSession]$Session = $null
    )

    if ($Session)
    {
        $Session.DefaultDockerEndpoint = $Endpoint
    }
    elseif ($script:PortainerSession)
    {
        $script:PortainerSession.DefaultDockerEndpoint = $Endpoint
    }
    else
    {
        Write-Warning 'No session found'
    }

}
