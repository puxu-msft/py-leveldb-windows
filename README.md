# py-leveldb-win

The [upstream project][happynear] targets Python 2 and Python 3.6. This fork changes as follows:

1. Remove Python 2 support. Fix Python 3.7+ compatibility issues.
2. Remove specific Python 3 version dependency: `python3_x.dll`.
3. Add LevelDB 1.23 symbol exports `leveldb_1.23.def` and use it by default.
4. Reorganize msbuild `.vcxproj` to make it easier to change dependencies.
5. Support vcpkg if you don't want to build LevelDB manually. So far, only static version is there.

[happynear]: https://github.com/happynear/py-leveldb-windows

Tested on Windows 11 24H2. VS 2022 17.12.0 with MSVC v143 v14.42-17.12. Python 3.12.7. LevelDB 1.23 with Snappy 1.2.1.

Also tested both static-linked and dynamic-linked LevelDB.

## Usage

Prepare

1. VS 2022 IDE or Build Tools installed with MSVC v143 version.
2. Python 3 binaries, no matter installed or extracted from zip.
3. LevelDB and Snappy binaries, no matter built by yourself or from vcpkg.
4. `Install-Module -Scope CurrentUser VSSetup`

Edit `./msbuild/leveldb_ext.vcxproj`, check such as `VcpkgRoot` `LevelDBPath` `PythonPath`.

Run in PowerShell:

```ps1
./msbuild.ps1 ./msbuild/ -ReleaseBuild
```

Output at `./msbuild/bin/x64_Release/leveldb_ext.pyd`.

To use it,

1. Copy `.pyd` into your Python `site-packages` directory or `$env:PYTHONPATH` directory.
2. According to your configuration, also copy `leveldb.dll` `snappy.dll` to the same directory as `.pyd`.

Here a test script to verify the installation.

```ps1
& python ./tests/test_leveldb.py
```
