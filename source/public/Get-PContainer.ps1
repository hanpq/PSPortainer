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

    [CmdletBinding()] # Enabled advanced function support
    param(
    )

    InvokePortainerRestMethod -AuthRequired:$true -Method Get -RelativePath '/endpoints/1/docker/containers/json' | ForEach-Object { $_ }

}
#endregion


