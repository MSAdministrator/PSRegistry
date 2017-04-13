# PSRegistry
A PowerShell Module that replaces the reg commands using the WIN_API

## Importing

Download the repository and unzip the downloaded zip.  You may need to unblock the file for windows to trust the module.

Run `Import-Module PSRegistry` if you placed the module in your $ENV:ModulePath

If not, then please run `Import-Module -Path C:\path\to\extracted\file\PSRegistry.psm1`

## Current Functionality

- Mount Local Registry Hive
- Dismount Local Registry Hive
- Create a new local Registry Key
- Remove an existing local Registry Key
- Mount a remote computers Registry hive (needs to be tested)

## Testing

This code has Pester unit tests for the Module itself as well as each Public and Private function.  To run these tests, you must have Pester installed and either run them individually or run them while open in Windows PowerShell ISE console.

## To-Do

This module will continue to grow and will eventually contain functions for each of the following .NET classes: https://msdn.microsoft.com/en-us/library/windows/desktop/ms724875(v=vs.85).aspx

Also, the PSSake, Build and deploy scripts need to be finished.
