#
# Mbed CE Hello World Project
#
# Use CMake presets to select build configuration:
#   Firmware presets  — cross-compile for STM32 via Mbed CE (see cmake/firmware.cmake)
#   desktop-tests     — native build for unit testing libs  (see cmake/desktop.cmake)
#
cmake_minimum_required(VERSION 3.23)
cmake_policy(VERSION 3.23)

option(BUILD_FIRMWARE "Build embedded firmware with Mbed CE (OFF = desktop test build)" ON)

if(BUILD_FIRMWARE)
    include(cmake/firmware.cmake)
    # project() is called inside firmware.cmake after toolchain setup
else()
    # project() must be a literal call in the top-level CMakeLists.txt or we get errors
    project(MbedCE-Template-Desktop LANGUAGES C CXX)
    include(cmake/desktop.cmake)
endif()

