set(APP_TARGET crash-report-test)

add_executable(${APP_TARGET} main.cpp)
if("MBED_CONF_TARGET_APPLICATION_PROFILE=bare-metal" IN_LIST MBED_CONFIG_DEFINITIONS)
    target_link_libraries(${APP_TARGET} mbed-baremetal)
else()
    target_link_libraries(${APP_TARGET} mbed-os)
endif()
mbed_set_post_build(${APP_TARGET})

