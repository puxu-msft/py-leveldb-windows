param(
    # for cmake
    [switch]$DLL,
    [switch]$FreshGen,

    # for cmake --build
    [switch]$BuildOnly,
    [switch]$ReleaseBuild
)

$ErrorActionPreference = "Stop"
trap { throw $_ }

function cmake_gen {
    param(
        [switch]$FreshRetry
    )

    $preset = if ($DLL) { "dll" } else { "lib" }

    $exeArgs = @(
        "--preset=$preset"
        ".."
    )

    if ($FreshRetry) {
        $exeArgs += "--fresh"
    }

    & cmake @exeArgs
    if ((1 -eq $LASTEXITCODE) -and (-not $FreshRetry)) {
        Write-Host "Retrying with --fresh"
        return cmake_gen -FreshRetry
    }
    if (0 -ne $LASTEXITCODE) {
        throw "cmake exited with code $LASTEXITCODE"
    }
}

function cmake_build {
    $config = if ($ReleaseBuild) { "Release" } else { "Debug" }

    $exeArgs = @(
        "--build"
        "."
        "--config=$config"
    )

    & cmake @exeArgs
    if (0 -ne $LASTEXITCODE) {
        throw "cmake --build exited with code $LASTEXITCODE"
    }
}

function main {
    mkdir build -ErrorAction SilentlyContinue
    cd build -ErrorAction Stop

    if (-not $BuildOnly) {
        cmake_gen -FreshRetry:$FreshGen
    }

    cmake_build
}

pushd $PSScriptRoot
try {
    main
}
finally {
    popd
}
