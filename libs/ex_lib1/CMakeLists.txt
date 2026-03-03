cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(ex_lib1
    VERSION 0.1
    LANGUAGES CXX
)
add_library(${PROJECT_NAME})
add_library(lib::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

target_sources(${PROJECT_NAME}
    PRIVATE
        # Public headers go into "include/ex_lib1/*"
        include/ex_lib1/ex_lib1.hpp
        # Source files and private headers go in "src/*"
        src/ex_lib1.cpp
)

target_compile_features(${PROJECT_NAME}
    PUBLIC
        cxx_std_20
)
target_include_directories(${PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_compile_definitions(${PROJECT_NAME}
    PRIVATE
        _CRT_SECURE_NO_WARNINGS # MSVC annoyances
)

# dependencies
# Add dependencies via FetchContent at the top-level CMakeLists.txt
# then link them here:
# target_link_libraries(${PROJECT_NAME}
#     PUBLIC
#         dependency::target
# )

########################################
# setup tests
if(PC_TESTS)
    add_subdirectory(tests)
endif()