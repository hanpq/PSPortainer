<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "eeec7c25-cb3b-43bd-ae6c-e5f5637ee91e",
  "FILENAME": "PortainerContainerProcess.class.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-23",
  "COMPANYNAME": "GetPS",
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
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
}
