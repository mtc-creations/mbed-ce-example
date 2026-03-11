# Mbed CE Template Project

A dual-target C++23 project: cross-compiled **firmware** for STM32 microcontrollers via [Mbed CE](https://github.com/mbed-ce/mbed-os), and a native **desktop** build for unit-testing hardware-independent libraries with [Catch2](https://github.com/catchorg/Catch2).

# How it works (in VS Code anyway)

## Embedded Targets

In VS Code, you can switch between targets using the integrated CMake preset support; other IDEs (e.g., Visual Studio and CLion) provide similar functionality.

<img width="443" height="423" alt="VS Code CMake preset selection showing embedded board targets" src="https://github.com/user-attachments/assets/420a5cc7-1b8c-4cf9-8202-438f87a041a0" />

### Debugging
Mbed CE uses CMake to generate the required VS Code launch.json files for debugging, based on the currently selected target and upload method. Clicking the play button will build the project, start the GDB server, and flash the firmware to the connected board. Most upload methods will then breakpoint in main once the target boots the firmware. Boards and upload methods can be changed in the CMake presets.

<img width="497" height="127" alt="VS Code Run and Debug view with Cortex-M debug configuration and play button" src="https://github.com/user-attachments/assets/1065e0fc-19ed-4e26-aae6-e6d2d694bd98" />

### Flashing
Mbed CE also generates VS Code tasks.json to allow you to build or flash the device without starting a debug session, right within the IDE.

<img width="369" height="419" alt="VS Code Tasks view showing build and flash tasks for STM32 firmware" src="https://github.com/user-attachments/assets/0afc09c2-c4a2-4c04-8f9a-7b475e932b2d" />


## Desktop Targets

By switching your CMake preset to desktop, you can run unit tests without any hardware connected using the VS Code testing window (MSVC, Clang, or GCC — thanks to Catch2 support).
<img width="963" height="577" alt="VS Code Testing window running Catch2 unit tests for the desktop target" src="https://github.com/user-attachments/assets/38b3d0aa-07b5-4b69-9c40-1e6639a31b63" />


---

# Architecture Overview

The project is split into two mutually exclusive build modes controlled by a single CMake option (`BUILD_FIRMWARE`). A given build directory is always one or the other.

| Build mode | Compiler | Purpose | Entry point |
|---|---|---|---|
| **Firmware** (`BUILD_FIRMWARE=ON`) | ARM GNU Toolchain (`arm-none-eabi-gcc`) | Cross-compile for STM32 targets | `cmake/firmware.cmake` |
| **Desktop** (`BUILD_FIRMWARE=OFF`) | Native host compiler (MSVC on Windows) | Unit-test `libs/` on the PC | `cmake/desktop.cmake` |

The root `CMakeLists.txt` delegates to the appropriate file:

```cmake
if(BUILD_FIRMWARE)
    include(cmake/firmware.cmake)   # toolchain + mbed-os + apps
else()
    project(MbedCE-Template-Desktop LANGUAGES C CXX)
    include(cmake/desktop.cmake)    # FetchContent for Catch2/fmt + libs
endif()
```

### Cross-Compilation (Firmware)

Firmware builds use the Mbed CE toolchain file which must be included **before** `project()`. This is handled automatically by `cmake/firmware.cmake`. The ARM toolchain, target board, and upload method are all selected through **CMake presets** (see below). The build produces `.bin`/`.hex` files ready to flash via ST-LINK.

### Desktop / Unit-Test Build

The desktop build compiles only the `libs/` tree using the host compiler (GCC, Clang, MSVC). Test dependencies (Catch2 v3 and fmt) are pulled in via `FetchContent` inside `cmake/desktop.cmake` — individual libraries must **not** add their own `FetchContent` or `find_package` calls for these.

---

## Project Layout

```
CMakeLists.txt              Root — routes to firmware.cmake or desktop.cmake
CMakePresets.json           Includes per-board and desktop preset files
mbed_app.json5              Mbed OS application-level configuration
cmake/
    firmware.cmake          Firmware build (ARM cross-compilation, Mbed CE)
    desktop.cmake           Desktop build (native compiler, Catch2, fmt)
    presets/
        firmware-base.json  Hidden base preset + fw-debug / fw-release
        Nucleo64_F446RE.json  Board-specific presets (inherits firmware-base)
        Nucleo32_L432KC.json  Another board
        desktop.json        Desktop test configure / build / test presets
apps/                       Firmware applications (one subfolder per app)
    blink/                  LED blink example
    crash-report-test/      Crash-report demonstration
libs/                       Hardware-independent libraries (built in BOTH modes)
    ex_lib1/                Example library with Catch2 unit tests
components/                 Hardware-dependent components (firmware only)
mbed-os/                    Mbed CE RTOS (Git submodule — do NOT modify)
```

### Key directories

| Directory | Firmware build | Desktop build | May depend on Mbed OS |
|---|---|---|---|
| `apps/` | Yes | — | Yes (links `mbed-os` / `mbed-baremetal`) |
| `libs/` | Yes | Yes | No — must be hardware-independent |
| `components/` | Yes | — | Yes |
| `mbed-os/` | Yes | — | N/A |

---

# Getting Started

1. **Clone** (with submodules):
   ```bash
   git clone --recursive https://github.com/mtc-creations/mbed-ce-example.git
   ```
2. Optionally **update Mbed OS**:
   ```bash
   cd mbed-ce-example/mbed-os && git fetch origin && git reset --hard origin/main
   ```
3. **Install the ARM toolchain** following the [toolchain setup guide](https://mbed-ce.dev/getting-started/toolchain-install/).
4. **Configure** using one of the provided CMake presets (see [Presets](#cmake-presets) below)
5. **Build & flash** (firmware): build the `flash-blink` target to upload code to a connected board. In VS Code, debugging can be started by clicking the green play button under the "Run and Debug" menu.
6. **Run tests** (desktop):
   ```bash
   cmake --preset desktop-tests
   cmake --build --preset desktop-tests
   ctest --preset desktop-tests
   ```

---

# CMake Presets

All presets live under `cmake/presets/` and are aggregated by `CMakePresets.json`.

| Preset | Type | Description |
|---|---|---|
| `desktop-tests` | Configure / Build / Test | Native debug build, runs Catch2 tests |
| `N64_F446RE-Debug` | Configure / Build | Firmware debug for NUCLEO_F446RE |
| `N64_F446RE-Release` | Configure / Build | Firmware release for NUCLEO_F446RE |
| `N32_L432KC-Debug` | Configure / Build | Firmware debug for NUCLEO_L432KC |
| `N32_L432KC-Release` | Configure / Build | Firmware release for NUCLEO_L432KC |

---

## Unit Testing (`libs/`)

Libraries in `libs/` are hardware-independent and compile on **both** the ARM firmware toolchain and the native desktop compiler. Each library can optionally include a `tests/` directory containing Catch2 unit tests that run on your PC.

### How it works

1. `cmake/desktop.cmake` sets `PC_TESTS=ON` and fetches Catch2 + fmt via `FetchContent`.
2. Each library checks `if(PC_TESTS)` and conditionally adds its `tests/` subdirectory.
3. Test executables link to `Catch2::Catch2WithMain` (no custom `main()` needed) and optionally `fmt::fmt`.
4. `ctest --preset desktop-tests` discovers and runs all test executables.

### Example: `libs/ex_lib1`

```
libs/ex_lib1/
    CMakeLists.txt          Library target + conditional test inclusion
    include/ex_lib1/        Public headers (consumed via BUILD_INTERFACE)
        ex_lib1.hpp
    src/                    Implementation files
        ex_lib1.cpp
    tests/
        CMakeLists.txt      Test executable linking Catch2 + the library
        src/
            test.cpp        Catch2 TEST_CASE definitions
```

The library's `CMakeLists.txt` defines the library target, sets `cxx_std_23` as a public compile feature, and gates tests behind `PC_TESTS`:

```cmake
add_library(${PROJECT_NAME})
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_23)

# ... sources, include dirs, etc.

if(PC_TESTS)
    add_subdirectory(tests)
endif()
```

The test `CMakeLists.txt` creates an executable and links Catch2 + the library:

```cmake
add_executable(${PROJECT_NAME}-tests)
target_sources(${PROJECT_NAME}-tests PRIVATE src/test.cpp)
target_link_libraries(${PROJECT_NAME}-tests
    PRIVATE lib::${PROJECT_NAME} Catch2::Catch2WithMain fmt::fmt)
```

---

# How-To Guides

### Adding a New Library

1. Create `libs/my_lib/` with the standard layout:
   ```
   libs/my_lib/
       CMakeLists.txt
       include/my_lib/
           my_lib.hpp
       src/
           my_lib.cpp
       tests/
           CMakeLists.txt
           src/
               test.cpp
   ```
2. In `libs/my_lib/CMakeLists.txt`:
   - Call `add_library()` and `add_library(lib::my_lib ALIAS my_lib)`.
   - Set `target_compile_features(my_lib PUBLIC cxx_std_23)`.
   - Expose headers via `target_include_directories` with `BUILD_INTERFACE`.
   - Gate tests: `if(PC_TESTS) add_subdirectory(tests) endif()`.
3. Register it in `libs/CMakeLists.txt`:
   ```cmake
   add_subdirectory(my_lib)
   ```
4. **Do NOT** add `FetchContent` or `find_package` for Catch2/fmt — these are provided globally by `cmake/desktop.cmake`.
5. The library must **not** depend on `mbed-os` or any hardware-specific headers. If it needs Mbed types in a firmware build, link `mbed-core-flags` (never `mbed-os`).

### Adding a New Firmware Application

1. Create `apps/my_app/` with a `CMakeLists.txt` and `main.cpp`.
2. In the `CMakeLists.txt`:
   ```cmake
   set(APP_TARGET my_app)
   add_executable(${APP_TARGET} main.cpp)

   # Link Mbed OS (RTOS or bare-metal)
   if("MBED_CONF_TARGET_APPLICATION_PROFILE=bare-metal" IN_LIST MBED_CONFIG_DEFINITIONS)
       target_link_libraries(${APP_TARGET} mbed-baremetal)
   else()
       target_link_libraries(${APP_TARGET} mbed-os)
   endif()

   # Link any libs/ libraries you need
   target_link_libraries(${APP_TARGET} ex_lib1)

   mbed_set_post_build(${APP_TARGET})
   ```
3. Register it in `apps/CMakeLists.txt`:
   ```cmake
   add_subdirectory(my_app)
   ```
4. `main()` **must** contain an infinite loop — returning from it halts the processor.

### Adding a New Board

1. Create `cmake/presets/NewBoard.json` following the existing board files.
2. Define a hidden preset with `MBED_TARGET` (see [supported targets](mbed-os/targets/targets.json5)) and `UPLOAD_METHOD` (see [upload methods](https://mbed-ce.dev/upload-methods/)).
3. Add concrete presets that inherit from both the board preset and `fw-debug` / `fw-release`.
4. Include the new file in `CMakePresets.json`:
   ```json
   "include": [
       "cmake/presets/desktop.json",
       "cmake/presets/NewBoard.json"
   ]
   ```
