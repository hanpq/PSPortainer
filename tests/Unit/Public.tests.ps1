BeforeDiscovery {
    $RootItem = Get-Item $PSScriptRoot
    while ($RootItem.GetDirectories().Name -notcontains 'source')
    {
        $RootItem = $RootItem.Parent
    }
    $ProjectPath = $RootItem.FullName
    $ProjectName = (Get-ChildItem $ProjectPath\*\*.psd1 | Where-Object {
        ($_.Directory.Name -eq 'source') -and
            $(try
                {
                    Test-ModuleManifest $_.FullName -ErrorAction Stop
                }
                catch
                {
                    $false
                })
        }
    ).BaseName

    Import-Module $ProjectName -Force
}

InModuleScope $ProjectName {
    Describe 'Connect-Portainer' {
        Context -Name 'When no parameters are specified' {
            It -Name 'Should throw' {
                { Connect-Portainer } | Should -Throw
            }
        }
    }

    Describe 'Disconnect-Portainer' {
    }

    Describe 'enums' {}

    Describe 'Get-PContainer' {}

    Describe 'Get-PContainerProcess' {}
    Describe 'Get-PContainerStatistic' {}
    Describe 'Get-PCustomTemplate' {}
    Describe 'Get-PEndpoint' {}
    Describe 'Get-PImage' {}
    Describe 'Get-PSession' {}
    Describe 'Get-PSettingsPublic' {}
    Describe 'Get-PStack' {}
    Describe 'Get-PStatus' {}
    Describe 'New-PContainer' {}
    Describe 'Rename-PContainer' {}
    Describe 'Resize-PContainerTTY' {}
    Describe 'Restart-PContainer' {}
    Describe 'Resume-PContainer' {}
    Describe 'Select-PEndpoint' {}
    Describe 'Start-PContainer' {}
    Describe 'Stop-PContainer' {}
    Describe 'Suspend-PContainer' {}
    Describe 'Wait-PContainer' {}
}
