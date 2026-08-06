function Read-RuntimeState {

    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "Runtime State file not found: $Path"
    }

    Get-Content $Path -Raw -Encoding utf8 |
        ConvertFrom-Json
}

function Write-RuntimeState {

    param(
        [Parameter(Mandatory)]
        $State,

        [Parameter(Mandatory)]
        [string]$Path
    )

    $State.updatedAt = (Get-Date).ToString("o")

    $json = $State |
        ConvertTo-Json -Depth 10

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)

    [System.IO.File]::WriteAllText(
        (Resolve-Path (Split-Path $Path)).Path + "\" + (Split-Path $Path -Leaf),
        $json,
        $utf8NoBom
    )
}

function New-RuntimeStateFile {

    param(
        [Parameter(Mandatory)]
        [string]$Destination,

        [Parameter(Mandatory)]
        [string]$Template
    )

    Copy-Item `
        -Path $Template `
        -Destination $Destination `
        -Force

    Read-RuntimeState -Path $Destination
}