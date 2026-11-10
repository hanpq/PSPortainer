function Get-PImage
{
    <#
    .DESCRIPTION
        Retreives docker images from Portainer
    .PARAMETER Endpoint
        Defines the portainer endpoint to use when retreiving containers. If not specified the portainer sessions default docker endpoint value is used.

        Use Get-PSession to see what endpoint is selected

        Use Select-PEndpoint to change the default docker endpoint in the portainer session.

        -Endpoint 'local'
    .PARAMETER Id
        Defines the id of the image to retreive.

        -Id '<Id>'
    .PARAMETER Session
        Optionally define a portainer session object to use. This is useful when you are connected to more than one portainer instance.

        -Session $Session
    .EXAMPLE
        Get-PImage

        Retreives all images from the endpoint configured on the portainer session default docker endpoint setting.
    .EXAMPLE
        Get-PImage -Id "<id>"

        Retreives a single image object with the specified Id
    .EXAMPLE
        Get-PImage -Endpoint 'prod'

        Retreives all images on the prod endpoint
    .EXAMPLE
        Get-PImage -Session $Session

        Retreives all images on the portainer instance defined
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
            [array]$Id = InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/images/json" -PortainerSession:$Session -Body @{all = $true } | Select-Object -ExpandProperty Id
        }
    }

    PROCESS
    {
        $Id | ForEach-Object {
            if ($PSItem.PSObject.TypeNames -contains 'PortainerImage')
            {
                InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/images/$($PSItem.Id)/json" -PortainerSession:$Session | ForEach-Object { $PSItem.PSobject.TypeNames.Insert(0, 'PortainerImage'); $_ }
            }
            elseif ($PSItem -is [string])
            {
                InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/images/$PSItem/json" -PortainerSession:$Session | ForEach-Object { $PSItem.PSobject.TypeNames.Insert(0, 'PortainerImage'); $_ }
            }
            else
            {
                Write-Error -Message 'Cannot determine input object type' -ErrorAction Stop
            }

        }
    }
}
