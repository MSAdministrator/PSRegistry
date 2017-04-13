<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Mount-RemoteRegistryHive
{
    [CmdletBinding()]
    param(
        
        # Location of NTUSER.dat file
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 0
        )]
        [System.IO.FileInfo]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("\\\\\w+\\\w+")]
        [ValidateScript(
             { if (Test-Path $_) {$true}else{throw 'Please provide a remote computer that you can reach'}}
           )]
        $Computer,
        
        #Registry Key type can be HKLM or HKU
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 1
        )] 
        [ValidateSet(
            'HKLM',
            'HKU'
        )]
        [string]$KeyType
    )

    Write-Verbose -Message 'Creating new GUID for mountpoint'

   # $mountKey = New-Guid

    Try
    {
        $TokenPrivilege = Set-TokenPrivilege -Privilege "SeBackupPrivilege"
        $TokenPrivilege = Set-TokenPrivilege -Privilege "SeRestorePrivilege"

        $HKLM = 0x80000002
        $HKU  = 0x80000003

        #creating empty return value for method
        $phkResult = ''

        $Reg = Add-RemoteRegLoadType

        switch ($KeyType)
        {
            'HKLM' { $Result = $Reg::RegLoadKey( $Computer, $HKLM, $phkResult ) }
            'HKU'  { $Result = $Reg::RegLoadKey( $Computer, $HKU, $phkResult )  }
        }

        $props = @{
            KeyType = $KeyType
            MountKey = $mountKey
        }

        $returnObject = New-Object -TypeName PSCustomObject -Property $props

        return $returnObject
    }
    Catch
    {
        Write-LogEntry -type Error -message 'Error attempting to mount registry' -thisError $($Error[0] | Format-List -Force)
    }
}