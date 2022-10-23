@{
    Rules = @{
        PSUseCompatibleCommands = @{
            # Turns the rule on
            Enable         = $true

            # Lists the PowerShell platforms we want to check compatibility with
            TargetProfiles = @(
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework.json', # Windows Server 2019, Windows Powershell 5.1
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework.json' # Windows 10, Windows Powershell 5.1
            )
        }
        PSUseCompatibleSyntax   = @{
            # This turns the rule on (setting it to false will turn it off)
            Enable         = $true

            # List the targeted versions of PowerShell here
            TargetVersions = @(
                '5.1'
            )
        }
    }

    <#
    ExcludeRules = @(
        'PSAvoidUsingWriteHost', 
        'PSUseBOMForUnicodeEncodedFile', 
        'PSUseDeclaredVarsMoreThanAssignments', 
        'PSUseShouldProcessForStateChangingFunctions', 
        'PSUseSingularNouns', 
        'PSAvoidTrailingWhitespace',
        'PSUseOutputTypeCorrectly',
        'PSReviewUnusedParameter',
        'PSUseCmdletCorrectly'
    )
    #>
}
