<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "6e22beb1-0b30-4e81-87ee-67e10c3410f5",
  "FILENAME": "Select-PEndpoint.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-24",
  "COMPANYNAME": [],
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Select-PEndpoint
{
    <#
    .DESCRIPTION
        .
    .PARAMETER Name
        Description
    .EXAMPLE
        Select-PEndpoint
        Description of example
    #>

    [CmdletBinding()] # Enabled advanced function support
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


