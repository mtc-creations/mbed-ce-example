# Mbed CE Hello World
This project implements a basic hello world using Mbed OS Community Edition.  Use it as an example or a starting place for your own projects!

## How to set up this project:

1. Clone it to your machine.  Don't forget to use `--recursive` to clone the submodules: `git clone --recursive https://github.com/mbed-ce/mbed-ce-hello-world.git`
2. You may want to update the mbed-os submodule to the latest version, with `cd mbed-ce-hello-world/mbed-os && git fetch origin && git reset --hard origin/main`
3. Set up the GNU ARM toolchain (and other programs) on your machine using [the toolchain setup guide](https://mbed-ce.dev/getting-started/toolchain-install/).
4. Set up the CMake project for editing.  We have three ways to do this:
    - On the [command line](https://mbed-ce.dev/getting-started/ide_cli_setup/cli_setup/)
    - Using the [CLion IDE](https://mbed-ce.dev/getting-started/ide_cli_setup/clion_setup/)
    - Using the [VS Code IDE](https://mbed-ce.dev/getting-started/ide_cli_setup/vscode_setup/)
5. Build the `flash-HelloWorld` target to upload the code to a connected device.


### Adding a New Board

1. Create `cmake/presets/NewBoard.json` following the pattern in existing board files
2. Define one hidden preset with `MBED_TARGET` see [mbed supported targets](mbed-os/targets/targets.json5). Add `UPLOAD_METHOD`. See [upload methods](https://mbed-ce.dev/upload-methods/).
3. Add concrete presets that inherit `["NewBoard", "fw-debug"]` etc.
4. Add an include line in `CMakePresets.json`

### Adding a New Library

1. Create the library under `libs/` with its own `CMakeLists.txt`
2. The library must NOT depend on mbed-os or any hardware-specific headers
3. Use `add_library()` with public headers in `include/` and sources in `src/`
4. Add the library to `libs/CMakeLists.txt` via `add_subdirectory()`
5. For firmware, libraries link to `mbed-core-flags` (not `mbed-os`) if they need Mbed types
6. Unit tests live in `tests/` and are gated with `if(PC_TESTS)`
7. Desktop test dependencies (Catch2, fmt) are provided via FetchContent in `cmake/desktop.cmake` — do NOT add `find_package()` or `FetchContent` calls in individual library CMakeLists

### Adding a New Firmware Application

1. Create a folder under `apps/` (e.g. `apps/my_app/`)
2. Add a `CMakeLists.txt` with `add_executable()`, link `mbed-os` or `mbed-baremetal`, and call `mbed_set_post_build()`
3. Include the app from `cmake/firmware.cmake` via `add_subdirectory()`
