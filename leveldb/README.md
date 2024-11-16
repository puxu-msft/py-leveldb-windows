# leveldb build environment

Make it easy to build leveldb on Windows, leveraging cmake and vcpkg.

Support both static-linked and dynamic-linked library.

## Usage

Prepared your cmake and vcpkg, or install them via scoop.

```ps1
scoop install cmake vcpkg
```

Get the source code of LevelDB.

```ps1
& git clone --single-branch --branch tags/v1.23 --depth 1 https://github.com/google/leveldb.git src
```

Build the DLL version, Release version.

```
$env:VCPKG_ROOT = "C:/opt/vcpkg"
./build.ps1 -DLL -Retail
```

Go `build\leveldb\Release` to find the binary.
