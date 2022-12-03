function Resize-PContainerTTY
{
    <#
    .DESCRIPTION
        Resizes the TTY for a container
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
    .PARAMETER Height
        Defines the height of the TTY session
    .PARAMETER Width
        Defines the width of the TTY session
    .EXAMPLE
        Resize-PContainerTTY
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Height', Justification = 'False positive')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Width', Justification = 'False positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()][string]$Endpoint,
        [Parameter(ValueFromPipeline)][object[]]$Id,
        [Parameter()][PortainerSession]$Session = $null,
        [Parameter()][int]$Height,
        [Parameter()][int]$Width
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

            if ($PSCmdlet.ShouldProcess($ContainerID, 'Resize TTY'))
            {
                try
                {
                    InvokePortainerRestMethod -Method POST -RelativePath "/endpoints/$EndpointId/docker/containers/$ContainerID/resize" -PortainerSession:$Session -Body @{h = $Height; w = $Width }
                }
                catch
                {
                    if ($_.Exception.Message -like '*404*')
                    {
                        Write-Error -Message "No container with id <$ContainerID> could be found"
                    }
                    else
                    {
                        Write-Error -Message "Failed to resize container TTY with id <$ContainerID> with error: $_"
                    }
                }
            }
        }

    }
}
