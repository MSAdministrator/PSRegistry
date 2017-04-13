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
function New-Guid
{
    [CmdletBinding(
        SupportsShouldProcess=$true
        )]
    [Alias()]
    [OutputType([int])]
    Param()

    Begin
    {
        Write-Verbose -Message 'Generating a new GUID'
    }
    Process
    {
        try
        {
            If ($PSCmdlet.ShouldProcess(“Creation of new GUID successful“)) 
            { 
                $NewGuid = [System.Guid]::NewGuid().ToString()

                return $NewGuid
            }
        }
        catch
        {
            Write-LogEntry -type Error -message 'Unable to generate a new GUID' -thisError $($_ | Format-List -Force)
        }
    }
    End
    {
    }
}