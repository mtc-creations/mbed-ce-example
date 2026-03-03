add_executable(${PROJECT_NAME}-tests)

target_sources(${PROJECT_NAME}-tests
    PRIVATE
        src/test.cpp
)

# Catch2 and fmt are provided via FetchContent in cmake/desktop.cmake

target_include_directories(${PROJECT_NAME}-tests
    PRIVATE
        src/
)

target_link_libraries(${PROJECT_NAME}-tests
    PRIVATE
        lib::${PROJECT_NAME}
        Catch2::Catch2WithMain
        fmt::fmt
)

target_compile_features(${PROJECT_NAME}-tests
    PUBLIC
        cxx_std_20
)

if(BUILD_TESTING)
    add_test(${PROJECT_NAME}-tests ${PROJECT_NAME}-tests)
endif()