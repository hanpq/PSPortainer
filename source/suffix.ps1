# The content of this file will be appended to the top of the psm1 module file. This is useful for custom procesedures after all module functions are loaded.

#
#   Argument completers
#

$AC_Endpoints = [scriptblock] {
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
Register-ArgumentCompleter -CommandName 'Get-PContainer' -Parameter 'Endpoint' -ScriptBlock $AC_Endpoints
Register-ArgumentCompleter -CommandName 'Select-PEndpoint' -Parameter 'Endpoint' -ScriptBlock $AC_Endpoints
