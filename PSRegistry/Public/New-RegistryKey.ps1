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
Function New-RegistryKey
{
    [CmdletBinding(
        SupportsShouldProcess=$true
        )]
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
        [ValidateScript({ if ($_ -match '^H\w{2,3}\:\\'){$false}else{$true}}
            )]
        [System.String]$KeyPath
    )

    Try
    {

        Write-Verbose -Message 'Setting token privileges'
        If ($PSCmdlet.ShouldProcess(“Set token privelege on process successfully“)) 
        {
            $TokenPrivilege = Set-TokenPrivilege -Privilege "SeBackupPrivilege"
            $TokenPrivilege = Set-TokenPrivilege -Privilege "SeRestorePrivilege"
        }

        $HKLM = 0x80000002
        $HKU  = 0x80000003

        Write-Verbose -Message 'Adding custom type RegCreate'

        #creating empty return value for method
        $hKey = ''

        If ($PSCmdlet.ShouldProcess(“Add RegCreate type definition successfully“)) 
        {
            $Reg = Add-RegCreateType
        }

        Write-Verbose -Message 'Calling RegCreateKey'

        If ($PSCmdlet.ShouldProcess(“Creating new registry key succesful“)) 
        {
            switch ($KeyType)
            {
                'HKLM' { $Result = $Reg::RegCreateKey( $HKLM, $KeyPath, $hKey ) }
                'HKU'  { $Result = $Reg::RegCreateKey( $HKU, $KeyPath, $hKey )  }
            }

            $props = @{
                KeyType = $KeyType
                KeyPath = $KeyPath
            }

            $returnObject = New-Object -TypeName PSCustomObject -Property $props

            return $returnObject
        }
    }
    Catch
    {
        $_ | Format-List -Force
        Write-LogEntry -type Error -message 'Error attempting to mount registry' -thisError $($Error[0] | Format-List -Force)
    }
}