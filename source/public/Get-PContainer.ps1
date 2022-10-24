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
        Retreives containers
    .PARAMETER Name
        Description
    .EXAMPLE
        Get-PContainer
        Description of example
    #>

    [CmdletBinding(DefaultParameterSetName = 'list')]
    param(
        [Parameter()][string]$Endpoint,
        [Parameter(ParameterSetName = 'id')][string]$Id,
        [Parameter()][PortainerSession]$Session = $null
    )

    # Resolve Endpoint
    if ([string]::IsNullOrEmpty($Endpoint))
    {
        Write-Debug 'GetPContainer; No Endpoint specified as parameter'
        if ($null -ne $script:PortainerSession)
        {
            Write-Debug 'GetPContainer; PortainerSession found in script scope'
            if ($script:PortainerSession.DefaultDockerEndpoint)
            {
                $Endpoint = $script:PortainerSession.DefaultDockerEndpoint
                Write-Debug "GetPContainer; DefaultDockerEndpoint is defined: $Endpoint"
            }
            else
            {
                $Endpoint = Read-Host -Prompt 'EndpointId'
            }
        }
        else
        {
            $Endpoint = Read-Host -Prompt 'EndpointId'
        }
    }
    $EndpointId = Get-PEndpoint -SearchString $Endpoint | Select-Object -ExpandProperty Id

    if ($EndpointId)
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            'list'
            {
                InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/containers/json" -PortainerSession:$Session -Body @{all = $true } | ForEach-Object {
                    Get-PContainer -Id $PSItem.Id | ForEach-Object {
                        $PSItem.PSobject.TypeNames.Insert(0, 'PSPortainer.Container')
                        $_
                    }
                }
            }
            'id'
            {
                InvokePortainerRestMethod -Method Get -RelativePath "/endpoints/$EndpointId/docker/containers/$Id/json" -PortainerSession:$Session | ForEach-Object { $PSItem.PSobject.TypeNames.Insert(0, 'PSPortainer.Container'); $_ }
            }
        }
    }
    else
    {
        Write-Warning -Message 'No endpoint found'
    }

}
#endregion
