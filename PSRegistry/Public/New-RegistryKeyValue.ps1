function New-RegistryKeyValue
{
    [CmdletBinding()]
    param(
        
        #Registry Key type can be HKLM or HKU
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 0
        )] 
        [ValidateSet(
            'HKLM',
            'HKU'
        )]
        [string]$KeyType,

        # KeyPath that you want to remove
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 1
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]$KeyPath,

        # Key value type you want to create
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 2
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]$KeyValueType,

        # Key name you want to create
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 3
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]$KeyValueName,

        # Key data you want to create
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 4
        )]
        [ValidateNotNullOrEmpty()]
        [System.String]$KeyValueData
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