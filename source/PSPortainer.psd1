#
# Module manifest for module 'PSPortainer'
#
# Generated by: Hannes Palmquist
#
# Generated  on: 2022-11-09
#

@{
    RootModule           = 'PSPortainer.psm1'
    ModuleVersion        = '0.0.1'
    CompatiblePSEditions = @('Desktop', 'Core')
    PowerShellVersion    = '5.1'
    GUID                 = '343344de-6ce2-4aa4-847c-7737b0dd4f8c'
    Author               = 'Hannes Palmquist'
    CompanyName          = 'GetPS'
    Copyright            = '(c) Hannes Palmquist. All rights reserved.'
    Description          = 'Powershell Module for interaction with Portainer API'
    RequiredModules      = @()
    FunctionsToExport    = '*'
    CmdletsToExport      = '*'
    VariablesToExport    = '*'
    AliasesToExport      = '*'
    FormatsToProcess     = @('.\include\PortainerContainer.Format.ps1xml', '.\include\PortainerContainerProcess.Format.ps1xml')
    PrivateData          = @{
        PSData = @{
            Prerelease               = ''
            Tags                     = @('PSEdition_Desktop', 'PSEdition_Core', 'Windows', 'Linux', 'MacOS')
            LicenseUri               = 'https://github.com/hanpq/PSPortainer/blob/main/LICENSE'
            ProjectUri               = 'https://getps.dev/modules/PSPortainer/usage_getstarted'
            IconUri                  = ''
            ReleaseNotes             = ''
            RequireLicenseAcceptance = $false
        }
    }
}
