cmake_minimum_required(VERSION 3.10)

# Unfortunately, cmake doesn't support putting multiple targets in the same binary directory
add_subdirectory("src" "leveldb")
