BeforeAll {
    . (Resolve-Path -Path "$PSScriptRoot\..\..\source\public\Portainer\Connect-Portainer.ps1")
}

Describe -Name 'Connect-Portainer.ps1' -Fixture {
    BeforeAll {
    }
    Context -Name 'Parameters' {
        It -Name 'Dummy' {
            $True | Should -BeTrue
        }
    }
}

