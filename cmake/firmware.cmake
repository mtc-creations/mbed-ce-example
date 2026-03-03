#
# Mbed CE Firmware Build
# Included from root CMakeLists.txt when BUILD_FIRMWARE=ON
#

#### Initialize Mbed OS build system. ####
######################################################################################################
### Block of including .json5 files. Files of this block must be included before the app.cmake

#[[ Set path of mbed_app.json (necessary at all times) ]]
set(MBED_APP_JSON_PATH mbed_app.json5)

###---------------------------------------------------------------------------------------------------
#[[ This part is dedicated for custom targets only! The settings below activate targets from
    custom_targets.json5 and upload method config. If custom targets are not used the lines below should be commented. ]]

#[[ Here set path for custom_targets.json5 (this is our default) ]]
#set(CUSTOM_TARGETS_JSON_PATH custom_targets/custom_targets.json5)

#[[ Here you can set path for custom upload config .cmake (optional example) ]]
#set(CUSTOM_UPLOAD_CFG_PATH ${CMAKE_SOURCE_DIR}/${MBED_TARGET}/${MBED_TARGET}.cmake)

#[[ Note: For custom target you need also an upload method and we have few options how you can do that
    - use the variable CUSTOM_UPLOAD_CFG_PATH above to set the location of your config file
    - use the default expected path for custom targets upload method config file:
      MY_PROJECT/custom_targets/upload_method_cfg
    - of course you can set upload method parameters directly via cmake in this file
   For more visit https://github.com/mbed-ce/mbed-os/wiki/Upload-Methods ]]

### End of block
######################################################################################################

### Include Mbed toolchain setup file
include(mbed-os/tools/cmake/mbed_toolchain_setup.cmake)

### Set up your project.
# The project name will be made available in the ${PROJECT_NAME} variable.
project(MbedCE-Template
        # VERSION 1.0.0
        LANGUAGES C CXX ASM)

### Include Mbed project setup file
include(mbed_project_setup)

######################################################################################################
### Block of including project folders

#[[ If using a custom target, the subdirectory containing the custom target must be included before
    the mbed-os subdir, otherwise the next line should be commented]]
#add_subdirectory(custom_targets)

###--------------------------------------------------------------------------------------------------
## Add mbed-os subdirectory (necessary everytime)
add_subdirectory(mbed-os)

###--------------------------------------------------------------------------------------------------
## Hardware-independent libraries
add_subdirectory(libs)

###--------------------------------------------------------------------------------------------------
## Hardware components
add_subdirectory(components)

###--------------------------------------------------------------------------------------------------
## Add application(s)
add_subdirectory(apps)

### End of block
######################################################################################################
