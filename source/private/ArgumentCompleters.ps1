<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "c998f096-260b-49c5-b1b6-132017860875",
  "FILENAME": "ArgumentCompleters.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-24",
  "COMPANYNAME": [],
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function AC_Endpoints
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Parameter is automatically provided by powershell when argument completer is invoked regardless of weather it is used or not')]
    [OutputType([System.Management.Automation.CompletionResult])]
    param(
        [string] $CommandName,
        [string] $ParameterName,
        [string] $WordToComplete,
        [System.Management.Automation.Language.CommandAst] $CommandAst,
        [System.Collections.IDictionary] $FakeBoundParameters
    )

    $CompletionResults = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()

    Get-PEndpoint | ForEach-Object {
        $CompletionResults.Add(
            [System.Management.Automation.CompletionResult]::New(($_.Name))
        )
    }

    return $CompletionResults
}
Register-ArgumentCompleter -CommandName 'Get-PContainer' -Parameter 'Endpoint' -ScriptBlock $function:AC_Endpoints
#endregion


