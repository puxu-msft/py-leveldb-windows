# LevelDB Build Environment

Make it easy to build LevelDB on Windows, leveraging cmake and vcpkg.

Support to build both static-linked and dynamic-linked library.

## Usage

Prepared your [CMake](https://cmake.org/) and [vcpkg](https://github.com/microsoft/vcpkg), or install them via [scoop](https://scoop.sh/).

```ps1
scoop install cmake vcpkg
```

CMake is the build system which is used by LevelDB.

Vcpkg is a C++ package manager which we use to, get rid of the manual work, fetch and build the dependencies of LevelDB \(e.g. Snappy and zlib\).

Get the source code of [LevelDB](https://github.com/google/leveldb) via [git](https://git-scm.com/).

```ps1
& git clone --single-branch --branch tags/v1.23 --depth 1 https://github.com/google/leveldb.git src
```

Build the DLL version, Release version.

```
$env:VCPKG_ROOT = "path/to/vcpkg"
./build.ps1 -DLL -ReleaseBuild
```

Go `build\leveldb\Release` to find the binary.
