BeforeAll {
    . (Resolve-Path -Path "$PSScriptRoot\..\..\source\public\Connect-Portainer.ps1")
}

Describe -Name "Connect-Portainer.ps1" -Fixture {
    BeforeAll {
    }
    Context -Name 'Parameters' {
        It -Name 'Dummy' {
            $True | should -BeTrue
        }
    }
}

