$here = Split-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Parent

$module = 'PSRegistry'

Describe -Tags "Unit" "Add-RegCreateType" {

    It "returns a new system.runtimetype" {
        $reg = Add-RegCreateType
        $reg.GetType().FullName | Should Be "System.RuntimeType"
    }

    It "should have declared method of RegCreateKey" {
        $reg = Add-RegCreateType
        $reg.DeclaredMethods.Name | Should Be "RegCreateKey"
    }
}