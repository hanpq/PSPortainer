function New-PContainer
{
    <#
    .DESCRIPTION
        Create a new container in portainer
    .PARAMETER Endpoint
        Defines the portainer endpoint to use when retreiving containers. If not specified the portainer sessions default docker endpoint value is used.

        Use Get-PSession to see what endpoint is selected

        Use Select-PEndpoint to change the default docker endpoint in the portainer session.

        -Endpoint 'local'
    .PARAMETER Name
        Assign the specified name to the container.
    .PARAMETER Platform
        Platform in the format os[/arch[/variant]] used for image lookup.

        When specified, the daemon checks if the requested image is present
        in the local image cache with the given OS and Architecture, and
        otherwise returns a 404 status.

        If the option is not set, the host's native OS and Architecture are
        used to look up the image in the image cache. However, if no platform
        is passed and the given image does exist in the local image cache,
        but its OS or architecture does not match, the container is created
        with the available image, and a warning is added to the Warnings
        field in the response, for example;
    .PARAMETER Hostname
        The hostname to use for the container, as a valid RFC 1123 hostname.
    .PARAMETER DomainName
        The domain name to use for the container.
    .PARAMETER User
        The user that commands are run as inside the container.
    .PARAMETER AttachStdin
        Whether to attach to stdin.
    .PARAMETER AttachStdout
        Whether to attach to stdout.
    .PARAMETER AttachStderr
        Whether to attach to stderr.
    .PARAMETER ExposedPorts
        Defines exposed ports for the container. Accepts a string array where
        each string should be in the following form @("<port>/<tcp|udp|sctp>","<port>/<tcp|udp|sctp>")
    .PARAMETER Tty
        Attach standard streams to a TTY, including stdin if it is not closed.
    .PARAMETER OpenStdin
        Open stdin for the container
    .PARAMETER StdinOnce
        Close stdin after one attached client disconnects
    .PARAMETER Env
        A list of environment variables specified as a string array in the
        following form @("<name>=<value>","<name>=<value>"). A variable
        without = is removed from the environment, rather than to have an empty value.
    .PARAMETER Cmd
        Command to run specified as a string or an array of strings.
    .PARAMETER HealthCheck
        Defines a hashtable with the configuration items of healthcheck object. Use the
        function New-PContainerHealthCheckObject to generate the hashtable.
    .PARAMETER ArgsEscaped
        Command is already escaped (Windows only)
    .PARAMETER Image
        The name (or reference) of the image to use when creating the container, or which was used when the container was created.
    .PARAMETER Volumes
        An object mapping mount point paths inside the container to empty objects. Accepts a string array in the form @('/volumes/data','/volumes/config')
    .PARAMETER WorkingDir
        The working directory for commands to run in.
    .PARAMETER Entrypoint
        The entry point for the container as a string or an array of strings.

        If the array consists of exactly one empty string ([""]) then the entry point
        is reset to system default (i.e., the entry point used by docker when there
        is no ENTRYPOINT instruction in the Dockerfile).
    .PARAMETER NetworkDisabled
        Disable networking for the container.
    .PARAMETER MacAddress
        MAC address of the container.
    .PARAMETER OnBuild
        ONBUILD metadata that were defined in the image's Dockerfile.
    .PARAMETER Labels
        Hashtable of labels. @{<label>=<value>;<label>=<value>}
    .PARAMETER StopSignal
        Signal to stop a container as a string or unsigned integer.
    .PARAMETER StopTimeout
        Timeout to stop a container in seconds. Default is 10.
    .PARAMETER Shell
        Shell for when RUN, CMD, and ENTRYPOINT uses a shell.
    .PARAMETER HostConfig
        A container's resources (cgroups config, ulimits, etc). Accepts a hashtable.
        Use the function New-PContainerHostConfig to generate the hashtable.
    .PARAMETER NetworkConfig
        NetworkingConfig represents the container's networking configuration for
        each of its interfaces. It is used for the networking configs specified
        in the docker create and docker network connect commands. Use the
        function New-PContainerNetworkConfig to generate the hashtable.
    .PARAMETER Session
        Optionally define a portainer session object to use. This is useful when you are connected to more than one portainer instance.

        -Session $Session
    .EXAMPLE
        New-PContainer
        Description of example
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False positive')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()]
        [string]
        $Endpoint,

        [Parameter(Mandatory)]
        [string]
        [ValidatePattern('/?[a-zA-Z0-9][a-zA-Z0-9_.-]+')]
        $Name,

        [Parameter()]
        [string]
        $Platform = '',

        [Parameter()]
        [string]
        $Hostname,

        [Parameter()]
        [string]
        $DomainName,

        [Parameter()]
        [string]
        $User,

        [Parameter()]
        [boolean]
        $AttachStdin = $false,

        [Parameter()]
        [boolean]
        $AttachStdout = $true,

        [Parameter()]
        [boolean]
        $AttachStderr = $true,

        [Parameter()]
        [string[]]
        $ExposedPorts,

        [Parameter()]
        [boolean]
        $Tty = $false,

        [Parameter()]
        [boolean]
        $OpenStdin = $false,

        [Parameter()]
        [boolean]
        $StdinOnce = $false,

        [Parameter()]
        [string[]]
        $Env,

        [Parameter()]
        [string[]]
        $Cmd,

        [Parameter()]
        [hashtable]
        $HealthCheck,

        [Parameter()]
        [boolean]
        $ArgsEscaped = $false,

        [Parameter()]
        [string]
        $Image,

        [Parameter()]
        [string[]]
        $Volumes,

        [Parameter()]
        [string]
        $WorkingDir,

        [Parameter()]
        [string[]]
        $Entrypoint,

        [Parameter()]
        [boolean]
        $NetworkDisabled = $false,

        [Parameter()]
        [string]
        $MacAddress,

        [Parameter()]
        [string[]]
        $OnBuild,

        [Parameter()]
        [hashtable]
        $Labels,

        [Parameter()]
        [string]
        $StopSignal,

        [Parameter()]
        [int]
        $StopTimeout,

        [Parameter()]
        [string[]]
        $Shell,

        [Parameter()]
        [hashtable]
        $HostConfig,

        [Parameter()]
        [hashtable]
        $NetworkConfig,

        [Parameter()]
        [PortainerSession]
        $Session = $null
    )

    $Session = Get-PSession -Session:$Session
    $EndpointID = ResolveEndpointID -Endpoint:$Endpoint -Session:$Session

    $Configuration = @{}

    $AsIsIfValueProperties = @('Hostname', 'Domainname', 'User', 'ArgsEscaped', 'Image', 'WorkingDir', 'MacAddress', 'StopSignal', 'StopTimeout', 'Labels', 'HostConfig', 'NetworkConfig', 'HealthCheck')
    $AsIsAlwaysProperties = @('AttachStdin', 'AttachStdout', 'AttachStderr', 'NetworkDisabled')
    $ValueArrayProperties = @('Tty', 'OpenStdin', 'StdinOnce', 'Volumes')
    $StringArrayProperties = @('Env', 'Cmd', 'Entrypoint', 'OnBuild', 'Shell')

    foreach ($Property in $AsIsIfValueProperties)
    {
        if (Get-Variable -Name $Property -ValueOnly)
        {
            $Configuration.$Property = Get-Variable -Name $Property -ValueOnly
        }
    }

    foreach ($Property in $AsIsAlwaysProperties)
    {
        if (Get-Variable -Name $Property -ValueOnly)
        {
            $Configuration.$Property = Get-Variable -Name $Property -ValueOnly
        }
    }

    foreach ($Property in $ValueArrayProperties)
    {
        if (Get-Variable -Name $Property -ValueOnly)
        {
            $Configuration.$Property = @{}
            foreach ($Item in (Get-Variable -Name $Property -ValueOnly))
            {
                $Configuration.$Property.$Item = @{}
            }
        }
    }

    foreach ($Property in $StringArrayProperties)
    {
        if (Get-Variable -Name $Property -ValueOnly)
        {
            $Configuration.$Property = [string[]](Get-Variable -Name $Property -ValueOnly)
        }
    }

    if ($PSCmdlet.ShouldProcess($Name, 'Create container'))
    {
        try
        {
            $CreatedContainer = InvokePortainerRestMethod -Method POST -RelativePath "/endpoints/$EndpointId/docker/containers/create?name=$Name&platform=$Platform" -Body $Configuration -PortainerSession:$Session
            Get-PContainer -Id $CreatedContainer.Id
        }
        catch
        {
            Write-Error -Message "Could not create container, bad parameter: $_"
        }
    }
}
