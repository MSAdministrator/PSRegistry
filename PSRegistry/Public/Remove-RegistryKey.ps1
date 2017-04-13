<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Remove-RegistryKey -KeyType HKLM -KeyPath 'SOFTWARE\Test\Path'
.EXAMPLE
   Another example of how to use this cmdlet
#>
Function Remove-RegistryKey
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
        [System.String]$KeyPath
    )

    Try
    {
        Write-Verbose -Message 'Setting token privileges'

        $TokenPrivilege = Set-TokenPrivilege -Privilege "SeBackupPrivilege"
        $TokenPrivilege = Set-TokenPrivilege -Privilege "SeRestorePrivilege"

        $HKLM = 0x80000002
        $HKU  = 0x80000003

        Write-Verbose -Message 'Adding custom type RegDelete'

        $Reg = Add-RegDeleteType
        
        Write-Verbose -Message 'Calling RegDeleteKey'

        switch ($KeyType)
        {
            'HKLM' { $Result = $Reg::RegDeleteKey( $HKLM, $KeyPath ) }
            'HKU'  { $Result = $Reg::RegDeleteKey( $HKU, $KeyPath )  }
        }

        $props = @{
            KeyType = $KeyType
            KeyPath = $KeyPath
        }

        $returnObject = New-Object -TypeName PSCustomObject -Property $props

        return $returnObject
    }
    Catch
    {
        $_ | Format-List -Force
        Write-LogEntry -type Error -message 'Error attempting to mount registry' -thisError $($Error[0] | Format-List -Force)
    }
}