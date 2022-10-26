<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "995b4fdc-f68c-41a3-b9d3-73219c3086e3",
  "FILENAME": "Get-PContainer.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-23",
  "COMPANYNAME": "GetPS",
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>

function Get-PContainer
{
    <#
    .DESCRIPTION
        Retreives docker containers
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
        Get-PContainer

        Retreives all containers from the endpoint configured on the portainer session default docker endpoint setting.
    .EXAMPLE
        Get-PContainer -Id '<id>'

        Retreives a single container object with the specified Id
    .EXAMPLE
        Get-PContainer -Endpoint 'prod'

        Retreives all containers on the prod endpoint
    .EXAMPLE
        Get-PContainer -Session $Session

        Retreives all containers on the portainer instance defined
    #>

    [CmdletBinding(DefaultParameterSetName = 'list')]
    param(
        [Parameter()][string]$Endpoint,
        [Parameter(ParameterSetName = 'id', ValueFromPipeline)][object[]]$Id,
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
                InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/containers/$($PSItem.Id)/json" -PortainerSession:$Session | ForEach-Object { $PSItem.PSobject.TypeNames.Insert(0, 'PortainerContainer'); $_ }
            }
            elseif ($PSItem.GetType().Name -eq 'string')
            {
                InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/containers/$PSItem/json" -PortainerSession:$Session | ForEach-Object { $PSItem.PSobject.TypeNames.Insert(0, 'PortainerContainer'); $_ }
            }
            else
            {
                Write-Error -Message 'Cannot determine input object type' -ErrorAction Stop
            }
        }
    }
}
