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
function Add-RegUnLoadType
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param()

    Write-Verbose -Message 'Adding RegUnLoad definition'
    
    try
    {
        $Definition = @"
[DllImport("advapi32.dll", SetLastError=true)]
public static extern int RegUnLoadKey(int hKey,string lpSubKey);
"@

        $Reg = Add-Type -MemberDefinition $Definition -Name "RegUnload" -Namespace "Win32Functions" -PassThru
    }
    catch
    {
        Write-LogEntry -type Error -message 'Error attempting to add RegLoad type' -thisError $($Error[0] | Format-List -Force)
    }
    
    return $Reg
}