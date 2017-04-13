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
function Add-RegDeleteType
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param()

    Write-Verbose -Message 'Adding RegDeleteKey definition'
    
    try
    {
        $Definition = @"
[DllImport("advapi32.dll", SetLastError=true)]
public static extern int RegDeleteKey(int hKey, string lpSubKey);
"@

        $Reg = Add-Type -MemberDefinition $Definition -Name "RegDelete" -Namespace "Win32Functions" -PassThru
    }
    catch
    {
        Write-LogEntry -type Error -message 'Error attempting to add RegDeletekey type' -thisError $($Error[0] | Format-List -Force)
    }
    
    return $Reg
}