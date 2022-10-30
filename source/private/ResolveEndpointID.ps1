<#PSScriptInfo
    .VERSION 1.0.0
    .GUID bc240721-1c04-45de-bc7b-3945f6220f0b
    .FILENAME ResolveEndpointID.ps1
    .AUTHOR Hannes Palmquist
    .CREATEDDATE 2022-10-30
    .COMPANYNAME GetPS
    .COPYRIGHT (c) 2022, Hannes Palmquist, All Rights Reserved
#>
function ResolveEndpointID
{
    <#
    .DESCRIPTION
        Determines the source of endpoint and returns the endpoint ID
    .PARAMETER Endpoint
        Defines the portainer endpoint to use when retreiving containers. If not specified the portainer sessions default docker endpoint value is used.

        Use Get-PSession to see what endpoint is selected

        Use Select-PEndpoint to change the default docker endpoint in the portainer session.

        -Endpoint 'local'
    .PARAMETER Session
        Optionally define a portainer session object to use. This is useful when you are connected to more than one portainer instance.

        -Session $Session
    .EXAMPLE
        ResolveEndpointID
    #>

    [CmdletBinding()]
    param(
        [Parameter()][AllowNull()][AllowEmptyString()][string]$Endpoint,
        [Parameter()][PortainerSession]$Session = $null
    )

    $EndpointName = GetNonNullOrEmptyFromList -Array @($Endpoint, $Session.DefaultDockerEndpoint) -AskIfNoneIsFound -PropertyName 'EndpointName'
    Write-Debug "ResolveEndpointID; Endpoint $EndpointName select"

    $EndpointId = Get-PEndpoint -SearchString $EndpointName | Select-Object -ExpandProperty Id

    if ($EndpointId)
    {
        return $EndpointID
    }
    else
    {
        throw 'No endpoint found'
    }
}
