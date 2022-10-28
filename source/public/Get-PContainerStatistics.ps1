<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "affcc338-63ee-4808-aaf4-3e6afc562eb0",
  "FILENAME": "Get-PContainerStatistics.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-27",
  "COMPANYNAME": [],
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Get-PContainerStatistics
{
    <#
    .DESCRIPTION
        Retreives container statistics
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
        Get-PContainer -Id '<id>' | Get-PContainerStatistics

    #>

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
            if ($PSItem.PSObject.TypeNames -contains 'PortainerContainer' -and $PSItem.GetType().Name -eq 'PSCustomObject')
            {
                InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/containers/$($PSItem.Id)/stats" -PortainerSession:$Session -Body @{'stream' = $false; 'one-shot' = $true }
            }
            elseif ($PSItem.GetType().Name -eq 'string')
            {
                InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/containers/$PSItem/stats" -PortainerSession:$Session -Body @{'stream' = $false; 'one-shot' = $true }
            }
            else
            {
                Write-Error -Message 'Cannot determine input object type' -ErrorAction Stop
            }
        }
    }
}
#endregion


