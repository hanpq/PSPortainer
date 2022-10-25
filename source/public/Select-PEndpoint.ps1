<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "6e22beb1-0b30-4e81-87ee-67e10c3410f5",
  "FILENAME": "Select-PEndpoint.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-24",
  "COMPANYNAME": "GetPS",
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Select-PEndpoint
{
    <#
    .DESCRIPTION
        Configures the default endpoint to use
    .PARAMETER Endpoint
        Defines the endpoint name to select
    .PARAMETER Session
        Optionally define a portainer session object to use. This is useful when you are connected to more than one portainer instance.

        -Session $Session
    .EXAMPLE
        Select-PEndpoint -Endpoint 'prod'

        Set the default endpoint to use
    #>

    [CmdletBinding()]
    param(
        [Parameter()][string]$Endpoint,
        [Parameter()][PortainerSession]$Session = $null
    )

    if ($Session)
    {
        $Session.DefaultDockerEndpoint = $Endpoint
    }
    elseif ($script:PortainerSession)
    {
        $script:PortainerSession.DefaultDockerEndpoint = $Endpoint
    }
    else
    {
        Write-Warning 'No session found'
    }

}
#endregion


