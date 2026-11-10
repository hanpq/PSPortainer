function Get-PContainer
{
    <#
    .DESCRIPTION
        Retreives docker containers from Portainer
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
        Get-PContainer -Id "<id>"

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
        $Session = Get-PSession -Session:$Session
        $EndpointID = ResolveEndpointID -Endpoint:$Endpoint -Session:$Session

        if ($PSCmdlet.ParameterSetName -eq 'list')
        {
            [array]$Id = InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/containers/json" -PortainerSession:$Session -Body @{all = $true } | Select-Object -ExpandProperty Id
        }
    }

    PROCESS
    {
        $Id | ForEach-Object {
            if ($PSItem.PSObject.TypeNames -contains 'PortainerContainer')
            {
                InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/containers/$($PSItem.Id)/json" -PortainerSession:$Session | ForEach-Object { $PSItem.PSobject.TypeNames.Insert(0, 'PortainerContainer'); $_ }
            }
            elseif ($PSItem.PSObject.TypeNames -contains 'PortainerStack')
            {
                $ResourceID = $PSItem.ResourceControl.ResourceID
                Get-PContainer -Endpoint:$Endpoint -Session:$Session | Where-Object { $_.Portainer.ResourceControl.ResourceID -eq $ResourceID }
            }
            elseif ($PSItem -is [string])
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
