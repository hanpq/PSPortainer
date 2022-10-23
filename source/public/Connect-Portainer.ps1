<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "a81b1e93-5997-4aeb-b491-524b7a309862",
  "FILENAME": "Connect-Portainer.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-23",
  "COMPANYNAME": "GetPS",
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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'AccessToken')]

    [CmdletBinding()] # Enabled advanced function support
    param(
        [Parameter(Mandatory)][string]$BaseURL,
        [Parameter(ParameterSetName = 'AccessToken')][string]$AccessToken
    )

    switch ($PSCmdlet.ParameterSetName)
    {
        'AccessToken'
        {
            $AccessTokenSS = ConvertTo-SecureString -String $AccessToken -AsPlainText -Force
            Remove-Variable -Name AccessToken
            $script:PortainerSession = [PortainerSession]::New($BaseURL, $AccessTokenSS)
        }
    }
}
#endregion


