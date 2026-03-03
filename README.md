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
