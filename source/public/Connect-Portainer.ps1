<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "a81b1e93-5997-4aeb-b491-524b7a309862",
  "FILENAME": "Connect-Portainer.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-23",
  "COMPANYNAME": [],
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function Connect-Portainer
{
    <#
    .DESCRIPTION
        Powershell Module for interaction with Portainer API
    .PARAMETER Name
        Description
    .EXAMPLE
        Connect-Portainer
        Description of example
    #>

    [CmdletBinding()] # Enabled advanced function support
    param(
    )

    # Get moduleconfiguration
    try
    {
        $ModuleConfiguration = Get-ModuleConfiguration -ErrorAction Stop
        pslog -severity Verbose -Message 'Successfully retreived module configuration'
    }
    catch
    {
        pslog -severity Error -Message 'Failed to retreive module configuration'
        throw
    }

}
#endregion


