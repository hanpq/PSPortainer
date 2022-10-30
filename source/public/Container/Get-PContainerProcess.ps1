<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "8e1ee3eb-e9b1-459e-a631-a9c9d1be4ce6",
  "FILENAME": "Get-PContainerProcess.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-25",
  "COMPANYNAME": [],
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Get-PContainerProcess
{
    <#
    .DESCRIPTION
        Get processes running inside the container
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
        Get-PContainer -Id '<id>' | Get-PContainerProcess

        Retreives the running processes in the specified container
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Session', Justification = 'False positive')]
    [CmdletBinding()] # Enabled advanced function support
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

        if (-not $EndpointId)
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

            InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/containers/$ContainerID/top" -PortainerSession:$Session | Select-Object -expand processes | ForEach-Object { [PortainerContainerProcess]::New($PSItem) }
        }
    }
}

