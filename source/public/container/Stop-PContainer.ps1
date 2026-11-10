function Stop-PContainer
{
    <#
    .DESCRIPTION
        Stop a container in portainer
    .PARAMETER Endpoint
        Defines the portainer endpoint to use when retreiving containers. If not specified the portainer sessions default docker endpoint value is used.

        Use Get-PSession to see what endpoint is selected

        Use Select-PEndpoint to change the default docker endpoint in the portainer session.

        -Endpoint 'local'
    .PARAMETER Id
        Defines the id of the container to retreive.

        -Id '<Id>'
    .PARAMETER Session
        Optionally define a portainer session object to use. This is useful when you are connected to more than one portainer instance.

        -Session $Session
    .PARAMETER Kill
        Defines that the container should be stopped with the kill command rather than a graceful shutdown
    .EXAMPLE
        Stop-PContainer
        Description of example
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Kill', Justification = 'False positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()][string]$Endpoint,
        [Parameter(ValueFromPipeline)][object[]]$Id,
        [Parameter()][PortainerSession]$Session = $null,
        [Parameter()][switch]$Kill
    )

    BEGIN
    {
        $Session = Get-PSession -Session:$Session
        $EndpointID = ResolveEndpointID -Endpoint:$Endpoint -Session:$Session
    }

    PROCESS
    {
        $Id | ForEach-Object {
            if ($PSItem.PSObject.TypeNames -contains 'PortainerContainer')
            {
                $ContainerID = $PSItem.Id
            }
            elseif ($PSItem.GetType().Name -eq 'string')
            {
                $ContainerID = $PSItem
            }
            else
            {
                Write-Error -Message 'Cannot determine input object type' -ErrorAction Stop
            }

            if ($PSCmdlet.ShouldProcess($ContainerID, 'Stop'))
            {
                if ($Kill)
                {
                    try
                    {
                        InvokePortainerRestMethod -Method POST -RelativePath "/endpoints/$EndpointId/docker/containers/$ContainerID/kill" -PortainerSession:$Session -Body @{signal = 'SIGKILL' }
                    }
                    catch
                    {
                        if ($_.Exception.Message -like '*409*')
                        {
                            Write-Warning -Message "Container <$ContainerID> is already stopped"
                        }
                        elseif ($_.Exception.Message -like '*404*')
                        {
                            Write-Error -Message "No container with id <$ContainerID> could be found"
                        }
                        else
                        {
                            Write-Error -Message "Failed to stop container with id <$ContainerID> with error: $_"
                        }
                    }

                }
                else
                {
                    try
                    {
                        InvokePortainerRestMethod -Method POST -RelativePath "/endpoints/$EndpointId/docker/containers/$ContainerID/stop" -PortainerSession:$Session
                    }
                    catch
                    {
                        if ($_.Exception.Message -like '*304 (Not Modified)*')
                        {
                            Write-Warning -Message "Container <$ContainerID> is already stopped"
                        }
                        elseif ($_.Exception.Message -like '*404*')
                        {
                            Write-Error -Message "No container with id <$ContainerID> could be found"
                        }
                        else
                        {
                            Write-Error -Message "Failed to stop container with id <$ContainerID> with error: $_"
                        }
                    }
                }
            }
        }
    }
}
#endregion
