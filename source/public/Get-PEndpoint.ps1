<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "82e7ab5b-b8c1-464c-8ce9-8593f8949caf",
  "FILENAME": "Get-PEndpoint.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-24",
  "COMPANYNAME": "\"GetPS\"",
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Get-PEndpoint
{
    <#
    .DESCRIPTION
        Retreive endpoints
    .PARAMETER Name
        Description
    .EXAMPLE
        Get-PEndpoint
        Description of example
    #>

    [CmdletBinding(DefaultParameterSetName = 'List')] # Enabled advanced function support
    param(
        [Parameter(ParameterSetName = 'Search')][string]$SearchString,
        [Parameter(ParameterSetname = 'Id')][int]$Id

        # Does not work for some reason, regardless of input to the API parameter name, all endpoints are returned...
        #[Parameter(ParameterSetName = 'Name')][string]$Name
    )

    switch ($PSCmdlet.ParameterSetName)
    {
        'List'
        {
            InvokePortainerRestMethod -Method Get -RelativePath '/endpoints'
        }
        'Search'
        {
            InvokePortainerRestMethod -Method Get -RelativePath '/endpoints' -Body @{search = $SearchString }
        }
        'Id'
        {
            InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$Id"
        }
        <#
        'Name'
        {
            InvokePortainerRestMethod -Method Get -RelativePath '/endpoints' -Body @{name = $Name }
        }
        #>
    }

}
#endregion


