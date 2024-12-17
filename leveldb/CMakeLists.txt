cmake_minimum_required(VERSION 3.10)

set(LEVELDB_BUILD_TESTS OFF)

# Unfortunately, cmake doesn't support putting multiple targets in the same binary directory
add_subdirectory("src" "leveldb")
