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
function Add-RegDeleteKeyType
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param()

    Write-Verbose -Message 'Adding RegDeleteValue definition'
    
    try
    {
        $Definition = @"
[DllImport("advapi32.dll", SetLastError=true)]
public static extern int RegDeleteKeyEx(int hKey, string lpValueName, string samDesired, int Reserved);
"@

        $Reg = Add-Type -MemberDefinition $Definition -Name "RegDeleteKey" -Namespace "Win32Functions" -PassThru
    }
    catch
    {
        Write-LogEntry -type Error -message 'Error attempting to add RegDeleteValue type' -thisError $($Error[0] | Format-List -Force)
    }
    
    return $Reg
}