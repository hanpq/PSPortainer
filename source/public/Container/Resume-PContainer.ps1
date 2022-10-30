<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "a25cd92a-ef1d-495d-a555-7ece51f720eb",
  "FILENAME": "Resume-PContainer.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-30",
  "COMPANYNAME": [],
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Resume-PContainer
{
    <#
    .DESCRIPTION
        Resumes a container
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
    .EXAMPLE
        Restart-PContainer
        Description of example
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()][string]$Endpoint,
        [Parameter(ValueFromPipeline)][object[]]$Id,
        [Parameter()][PortainerSession]$Session = $null
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

            if ($PSCmdlet.ShouldProcess($ContainerID, 'Resume'))
            {
                try
                {
                    InvokePortainerRestMethod -Method POST -RelativePath "/endpoints/$EndpointId/docker/containers/$ContainerID/unpause" -PortainerSession:$Session
                }
                catch
                {
                    if ($_.Exception.Message -like '*404*')
                    {
                        Write-Error -Message "No container with id <$ContainerID> could be found"
                    }
                    else
                    {
                        Write-Error -Message "Failed to resume container with id <$ContainerID> with error: $_"
                    }
                }
            }
        }
    }
}
