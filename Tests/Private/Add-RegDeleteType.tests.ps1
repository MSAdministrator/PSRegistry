$here = Split-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Parent

$module = 'PSRegistry'

Describe -Tags "Unit" "Add-RegDeleteType" {

    It "returns a new system.runtimetype" {
        $reg = Add-RegDeleteType
        $reg.GetType().FullName | Should Be "System.RuntimeType"
    }

    It "should have declared method of RegDeleteKey" {
        $reg = Add-RegDeleteType
        $reg.DeclaredMethods.Name | Should Be "RegDeleteKey"
    }
}