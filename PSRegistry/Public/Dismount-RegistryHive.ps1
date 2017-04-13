function Dismount-RegistryHive
{
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 0
        )]
        [System.Guid]
        [ValidateNotNullOrEmpty()]
        $MountKey,

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

    Try
    {
        Write-Verbose -Message 'Setting priveleges on registry'
        $TokenPrivilege = Set-TokenPrivilege -Privilege "SeBackupPrivilege"
        $TokenPrivilege = Set-TokenPrivilege -Privilege "SeRestorePrivilege"

        $HKLM = 0x80000002
        $HKU  = 0x80000003

        $Reg = Add-RegUnLoadType

        $Result = $Reg::RegUnLoadKey( $HKU, $MountKey )

        Write-Verbose -Message "RegUnLoadKey Result is $Result"

        switch ($KeyType)
        {
            'HKLM' { $Result = $Reg::RegUnLoadKey( $HKLM, $MountKey) }
            'HKU'  { $Result = $Reg::RegUnLoadKey( $HKU, $MountKey ) }
        }
    }
    Catch
    {
        Write-LogEntry -Error 'Error attempting to unmount registry' -ErrorRecord $Error[0]
    }

    $global:mountedHive = $null
}