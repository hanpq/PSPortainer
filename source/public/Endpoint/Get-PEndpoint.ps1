﻿function Get-PEndpoint
{
    <#
    .DESCRIPTION
        Retreives available endpoints
    .PARAMETER SearchString
        Defines a searchstring to use for filtering endpoints
    .PARAMETER Id
        Defines the Id of the endpoint to retreive.
    .PARAMETER Session
        Optionally define a portainer session object to use. This is useful when you are connected to more than one portainer instance.

        -Session $Session
    .EXAMPLE
        Get-PEndpoint -SearchString 'local'

        Retreives all endpoints containing the word local
    #>

    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [Parameter(ParameterSetName = 'Search')][string]$SearchString,
        [Parameter(ParameterSetname = 'Id')][int]$Id,
        [Parameter()][PortainerSession]$Session = $null

        # Does not work for some reason, regardless of input to the API parameter name, all endpoints are returned...
        #[Parameter(ParameterSetName = 'Name')][string]$Name
    )

    switch ($PSCmdlet.ParameterSetName)
    {
        'List'
        {
            InvokePortainerRestMethod -Method Get -RelativePath '/endpoints' -PortainerSession:$Session
        }
        'Search'
        {
            InvokePortainerRestMethod -Method Get -RelativePath '/endpoints' -Body @{search = $SearchString } -PortainerSession:$Session
        }
        'Id'
        {
            InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$Id" -PortainerSession:$Session
        }
        <#
        'Name'
        {
            InvokePortainerRestMethod -Method Get -RelativePath '/endpoints' -Body @{name = $Name } -PortainerSession:$Session
        }
        #>
    }

}
