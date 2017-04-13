function Mount-RegistryHive
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
        [ValidateScript(
            { $_.Exists }
           )]
        $NTUSER,
        
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

    $mountKey = New-Guid

    Try
    {
        $TokenPrivilege = Set-TokenPrivilege -Privilege "SeBackupPrivilege"
        $TokenPrivilege = Set-TokenPrivilege -Privilege "SeRestorePrivilege"

        $HKLM = 0x80000002
        $HKU  = 0x80000003

        $Reg = Add-RegLoadType

        switch ($KeyType)
        {
            'HKLM' { $Result = $Reg::RegLoadKey( $HKLM, $mountKey, $NTUSER ) }
            'HKU'  { $Result = $Reg::RegLoadKey( $HKU, $mountKey, $NTUSER )  }
        }

        $props = @{
            KeyType = $KeyType
            MountKey = $mountKey
        }

        $returnObject = New-Object -TypeName PSCustomObject -Property $props
        Add-ObjectDetail -InputObject $returnObject -TypeName 'PoshRegistry.Mount.Hive'
    }
    Catch
    {
        Write-LogEntry -Error 'Error attempting to mount registry' -ErrorRecord $Error[0]
    }
}