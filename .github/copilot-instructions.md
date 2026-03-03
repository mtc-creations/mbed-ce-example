---
applyTo: "**"
---

## Project Overview

This is a dual-target embedded/desktop C++ project:

- **Firmware**: Cross-compiled for STM32 microcontrollers using [Mbed CE](https://github.com/mbed-ce/mbed-os) RTOS
- **Desktop**: Native Windows build for unit testing hardware-independent libraries using Catch2

The target hardware is STM32 Nucleo development boards (e.g. NUCLEO_F446RE, NUCLEO_L432KC). The project uses C++20.

## Project Structure

```
CMakeLists.txt              # Root — routes to firmware or desktop via BUILD_FIRMWARE flag
CMakePresets.json           # Includes per-board and desktop preset files
cmake/
    firmware.cmake          # Mbed CE firmware build (cross-compilation, ARM toolchain)
    desktop.cmake           # Desktop build (native compiler, FetchContent for Catch2/fmt)
    presets/
        firmware-base.json  # Hidden base preset + fw-debug/fw-release build types
        Nucleo64_F446RE.json # Board-specific presets (inherits firmware-base)
        Nucleo32_L432KC.json # Another board
        desktop.json        # Desktop test configure/build/test presets
apps/
    blink/                  # Firmware application (LED blink example)
        CMakeLists.txt
        main.cpp
libs/                       # Hardware-independent libraries (compile in both builds)
    CMakeLists.txt
    ex_lib1/                # Example library with Catch2 tests
components/                 # Hardware-dependent components (firmware only)
mbed-os/                    # Mbed CE RTOS (submodule — do not modify)
mbed_app.json5              # Mbed OS application configuration
```

## Build System Architecture

### Two Build Modes

The root `CMakeLists.txt` uses `BUILD_FIRMWARE` (ON/OFF) to include either `cmake/firmware.cmake` or `cmake/desktop.cmake`. These are mutually exclusive — a single build directory is always one or the other.

## Mbed CE Rules

- **Do not modify anything under `mbed-os/`** — it is a Git submodule
- Mbed CE auto-generates `.vscode/tasks.json` and `.vscode/launch.json` when configuring a firmware preset — these files will be overwritten and should not be manually edited
- `mbed_app.json5` configures Mbed OS features and is read during CMake configure
- The Mbed toolchain setup (`mbed_toolchain_setup.cmake`) must be included BEFORE `project()` — this is handled in `cmake/firmware.cmake`
- `mbed-os` and `mbed-baremetal` are object libraries — only link them to executables, never to other libraries. Libraries should link to `mbed-core-flags` instead
- Upload method is configured per-board in the CMake presets (currently `STM32CUBE` for all boards)

## STM32 / Embedded Rules

- The target MCUs are ARM Cortex-M based (STM32F4, STM32L4 families)
- Cross-compilation uses the ARM GNU Toolchain (`arm-none-eabi-gcc`)
- Debugging uses ST-LINK GDB server via the `cortex-debug` VS Code extension
- Firmware `main()` must contain an infinite loop — returning from main halts the processor
- Be mindful of RAM/flash constraints when suggesting code for firmware targets
- Avoid dynamic memory allocation (heap) in firmware when possible — prefer stack allocation and static buffers
- Use `printf()` for serial output (retargeted to UART by Mbed OS)
- Mbed OS provides `ThisThread::sleep_for()` for delays — never use busy-wait loops
- Use Mbed HAL drivers (`DigitalOut`, `AnalogIn`, `I2C`, `SPI`, etc.) rather than direct register access

## C++ Standards and Practices

- The project uses C++20
- Desktop builds target MSVC on Windows
- Firmware builds use ARM GCC (which has a different set of supported C++ features)
- Avoid exceptions in firmware code (Mbed CE typically compiles with `-fno-exceptions`)
- Use `constexpr` and `const` aggressively
- Libraries in `libs/` must remain hardware-independent with no OS or platform dependencies
