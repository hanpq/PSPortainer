BeforeAll {
    . (Resolve-Path -Path "$PSScriptRoot\..\..\source\public\Portainer\Connect-Portainer.ps1")
}

Describe -Name 'Connect-Portainer.ps1' -Fixture {
    BeforeAll {
    }
    Context -Name 'When no parameters are specified' {
        It -Name 'Should throw' {
            { Connect-Portainer } | Should -Throw
        }
    }
}

