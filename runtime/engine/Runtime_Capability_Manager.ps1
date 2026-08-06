function Get-CapabilityDefinition {

    param(
        [Parameter(Mandatory)]
        [string]$CapabilityId
    )

    $registryPath = Join-Path $PSScriptRoot "..\..\docs\capabilities\Capability_Registry.md"

    if (!(Test-Path $registryPath)) {
        throw "Capability Registry not found."
    }

    $content = Get-Content $registryPath -Raw

    if ($content -notmatch [regex]::Escape($CapabilityId)) {
        throw "Capability '$CapabilityId' not registered."
    }

    return @{
        Id = $CapabilityId
        Registered = $true
    }
}

function Initialize-Capability {

    param(
        [Parameter(Mandatory)]
        [string]$CapabilityId
    )

    return Get-CapabilityDefinition `
        -CapabilityId $CapabilityId
}