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
function Add-RegOpenKeyExType
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param()

    Write-Verbose -Message 'Adding RegOpenKeyEx definition'
    
    try
    {
        $Definition = @"
[DllImport("advapi32.dll", SetLastError=true)]
public static extern int RegOpenKeyEx(int hKey, string lpSubKey, int ulOptions, string samDesired, out intPtr phkResult);
"@

        $Reg = Add-Type -MemberDefinition $Definition -Name "RegKeyOpen" -Namespace "Win32Functions" -PassThru
    }
    catch
    {
        Write-LogEntry -type Error -message 'Error attempting to add RegDeleteValue type' -thisError $($Error[0] | Format-List -Force)
    }
    
    return $Reg
}