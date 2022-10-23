<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "0cf86f27-137b-43ee-a194-ec0207d85ce5",
  "FILENAME": "InvokePortainerRestMethod.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-23",
  "COMPANYNAME": [],
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function InvokePortainerRestMethod
{
    <#
    .DESCRIPTION
        .
    .PARAMETER Name
        Description
    .EXAMPLE
        InvokePortainerRestMethod
        Description of example
    #>

    [CmdletBinding()] # Enabled advanced function support
    param(
        [boolean]$AuthRequired,
        [string]$Method,
        [portainersession]$PortainerSession,
        [string]$RelativePath
    )

    if (-not $PortainerSession)
    {
        Write-Debug -Message 'InvokePortainerRestMethod; No PortainerSession passed as parameter'
        if ($script:PortainerSession)
        {
            Write-Debug -Message 'InvokePortainerRestMethod; PortainerSession found in script scope'
            $PortainerSession = $script:PortainerSession
        }
        else
        {
            Write-Error -Message 'No Portainer Session established, please call Connect-Portainer'
        }
    }

    if ($AuthRequired)
    {
        #TBD
    }
    else
    {
        Write-Debug -Message "InvokePortainerRestMethod; Calling [$($PortainerSession.ApiUri)$($RelativePath)] with method [$Method] [without auth]"
        Invoke-RestMethod -Method:$Method -Uri "$($PortainerSession.ApiUri)$($RelativePath)"
    }

}
#endregion


