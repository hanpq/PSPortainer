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
        Connect to a Portainer instance
    .PARAMETER BaseURL
        Defines the base URL to the portainer instance

        -BaseURL 'https://portainer.contoso.com'
    .PARAMETER AccessToken
        Connects to portainer using a access token. This AccessToken can be generated from the Portainer Web GUI.

        -AccessToken 'ptr_ABoR54bB1NUc4aNY0F2PhppP1tVDu2Husr3vEbPUsw5'
    .PARAMETER Credential
        Connect to portainer using username and password. Parameter accepts a PSCredentials object

        -Credential (Get-Credential)
    .PARAMETER PassThru
        This parameter will cause the function to return a PortainerSession object that can be stored in a variable and referensed with the -Session parameter on most cmdlets.

        -PassThru
    .EXAMPLE
        Connect-Portainer -BaseURL 'https://portainer.contoso.com' -AccessToken 'ptr_ABoR54bB1NUc4aNY0F2PhppP1tVDu2Husr3vEbPUsw5='

        Connect using access token
    .EXAMPLE
        Connect-Portainer -BaseURL 'https://portainer.contoso.com' -Credentials (Get-Credential)

        Connect using username and password
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'AccessToken')]

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$BaseURL,
        [Parameter(ParameterSetName = 'AccessToken')][string]$AccessToken,
        [Parameter(ParameterSetName = 'Credentials')][pscredential]$Credential,
        [switch]$PassThru
    )

    switch ($PSCmdlet.ParameterSetName)
    {
        'AccessToken'
        {
            $AccessTokenSS = ConvertTo-SecureString -String $AccessToken -AsPlainText -Force
            Remove-Variable -Name AccessToken
            $script:PortainerSession = [PortainerSession]::New($BaseURL, $AccessTokenSS)
        }
        'Credentials'
        {
            $script:PortainerSession = [PortainerSession]::New($BaseURL, $Credential)
        }
    }

    if ($Passthru)
    {
        return $script:PortainerSession
    }
}
