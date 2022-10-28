<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "32e718aa-b4cf-4a35-bd12-36853ed90e7b",
  "FILENAME": "Restart-PContainer.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-28",
  "COMPANYNAME": [],
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Restart-PContainer
{
    <#
    .DESCRIPTION
        Restart container
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

    [CmdletBinding(SupportsShouldProcess)] # Enabled advanced function support
    param(
        [Parameter()][string]$Endpoint,
        [Parameter(ValueFromPipeline)][object[]]$Id,
        [Parameter()][PortainerSession]$Session = $null
    )

    BEGIN
    {
        # Resolve the PortainerSession to use
        $Session = Get-PSession -Session:$Session

        # Resolve Endpoint
        $EndpointName = GetNonNullOrEmptyFromList -Array @($Endpoint, $Session.DefaultDockerEndpoint) -AskIfNoneIsFound -PropertyName 'EndpointName'
        Write-Debug "GetPContainer; Endpoint $EndpointName select"

        $EndpointId = Get-PEndpoint -SearchString $EndpointName | Select-Object -ExpandProperty Id

        if ($EndpointId)
        {
            if ($PSCmdlet.ParameterSetName -eq 'list')
            {
                [array]$Id = InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/containers/json" -PortainerSession:$Session -Body @{all = $true } | Select-Object -ExpandProperty Id
            }
        }
        else
        {
            Write-Warning -Message 'No endpoint found'
            break
        }
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

            if ($PSCmdlet.ShouldProcess($ContainerID, 'Restart'))
            {
                try
                {
                    InvokePortainerRestMethod -Method POST -RelativePath "/endpoints/$EndpointId/docker/containers/$ContainerID/restart" -PortainerSession:$Session
                }
                catch
                {
                    if ($_.Exception.Message -like '*404*')
                    {
                        Write-Error -Message "No container with id <$ContainerID> could be found"
                    }
                    else
                    {
                        Write-Error -Message "Failed to restart container with id <$ContainerID> with error: $_"
                    }
                }
            }
        }
    }
}
#endregion


