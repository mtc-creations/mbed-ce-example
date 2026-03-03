######################################################################################################
### Blink application — LED toggle with serial output

set(APP_TARGET blink)

add_executable(${APP_TARGET} main.cpp)

######################################################################################################
### Link libraries block
#[[For more about this configuration visit wiki page MbedOS-configuration
https://github.com/mbed-ce/mbed-os/wiki/MbedOS-configuration#configuration-via-cmake-files]]

# Link Mbed OS core library. This is called mbed-os when using the Mbed RTOS, and mbed-baremetal when using
# the bare metal version. This if statement checks to see which is in use and links it.
# Important: The mbed-os and mbed-baremetal libraries are object libraries, so they should ONLY be
# linked to executables, not to other libraries. Libraries should link to `mbed-core-flags` instead.
if("MBED_CONF_TARGET_APPLICATION_PROFILE=bare-metal" IN_LIST MBED_CONFIG_DEFINITIONS)
    target_link_libraries(${APP_TARGET} mbed-baremetal)
else()
    target_link_libraries(${APP_TARGET} mbed-os)
endif()

### Link user libraries (if needed)
# target_link_libraries(${APP_TARGET} ex_lib1)

# This generates build rules to generate bin/hex files, and to flash the code if you have configured an
# upload method.
mbed_set_post_build(${APP_TARGET})
#[[ Note: if you wish to use a custom linker script instead of the default Mbed one for
   your target, you can do that with mbed_set_post_build(${APP_TARGET} path/to/linker_script.ld) ]]

### End of block
######################################################################################################
