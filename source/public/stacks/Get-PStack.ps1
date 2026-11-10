function Get-PStack
{
    <#
    .DESCRIPTION
        Retreives stacks from Portainer
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
        [Parameter()]
        [string]
        $Endpoint,

        [Parameter(ParameterSetName = 'id', ValueFromPipeline)]
        [object[]]
        $Id,

        <#
        # TBD: Not implemented
        [Parameter()]
        [string]
        $SwarmID,
        #>

        [Parameter()]
        [PortainerSession]
        $Session = $null
    )

    BEGIN
    {
        $Session = Get-PSession -Session:$Session
        if ($Endpoint)
        {
            $EndpointID = ResolveEndpointID -Endpoint:$Endpoint -Session:$Session
        }

        if ($PSCmdlet.ParameterSetName -eq 'list')
        {
            # Add filter query if EndpointID is defined
            if ($EndpointID)
            {
                $FilterQuery = @{EndpointID = $EndpointID } | ConvertTo-Json
                [string[]]$Id = InvokePortainerRestMethod -Method Get -RelativePath "/stacks?filter=$FilterQuery" -PortainerSession:$Session | Select-Object -ExpandProperty Id
            }
            else
            {
                [string[]]$Id = InvokePortainerRestMethod -Method Get -RelativePath '/stacks' -PortainerSession:$Session | Select-Object -ExpandProperty Id
            }
        }
    }

    PROCESS
    {
        $Id | ForEach-Object {
            if ($PSItem.PSObject.TypeNames -contains 'PortainerStack')
            {
                $StackID = $PSItem.Id
            }
            elseif ($PSItem -is [string] -or $PSItem -is [int])
            {
                $StackID = $PSItem
            }
            else
            {
                Write-Error -Message 'Cannot determine input object type' -ErrorAction Stop
            }

            InvokePortainerRestMethod -Method Get -RelativePath "/stacks/$StackID" -PortainerSession:$Session | ForEach-Object { $PSItem.PSobject.TypeNames.Insert(0, 'PortainerStack'); $_ }
        }
    }
}
