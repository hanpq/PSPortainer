class PortainerContainerProcess
{
    [string]$UserID
    [int]$ProcessID
    [int]$ParentProcessID
    [int]$C
    [string]$STIME
    [string]$Terminal
    [timespan]$TIME
    [string]$Command

    PortainerContainerProcess ()
    {
        $this.UserID = ''
        $this.ProcessID = 0
        $this.ParentProcessID = 0
        $this.C = 0
        $this.STime = ''
        $this.Terminal = ''
        $this.Time = New-TimeSpan
        $this.Command = ''
    }

    PortainerContainerProcess ([string[]]$Object)
    {
        $this.UserID = $Object[0]
        $this.ProcessID = $Object[1]
        $this.ParentProcessID = $Object[2]
        $this.C = $Object[3]
        $this.STime = $Object[4]
        $this.Terminal = $Object[5]
        $this.Time = [timespan]::Parse($Object[6])
        $this.Command = $Object[7]
    }

    [string] ToString ()
    {
        return "ProcessID: $($this.ProcessID)"
    }
}
