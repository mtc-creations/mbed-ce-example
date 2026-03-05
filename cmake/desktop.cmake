#
# Desktop Build
# Included from root CMakeLists.txt when BUILD_FIRMWARE=OFF
# Native compilation for unit testing hardware-independent libraries.
#

project(MbedCE-Template-Desktop
        LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

######################################################################################################
# Dependencies (via FetchContent — only needed for desktop tests, not firmware)

include(FetchContent)

FetchContent_Declare(
    Catch2
    GIT_REPOSITORY https://github.com/catchorg/Catch2.git
    GIT_TAG        v3.13.0
)

FetchContent_Declare(
    fmt
    GIT_REPOSITORY https://github.com/fmtlib/fmt.git
    GIT_TAG        12.1.0
)

FetchContent_MakeAvailable(Catch2 fmt)

# Make CTest and Catch2's test discovery available
include(CTest)
include(Catch)

######################################################################################################
# Enable test building in libraries
set(PC_TESTS ON)

# Add hardware-independent libraries (with their tests)
add_subdirectory(libs)
