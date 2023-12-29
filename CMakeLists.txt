cmake_minimum_required(VERSION 3.25)
project(mimgui_svg_lib VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)

if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    # MSVC-only flags
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
elseif (MSVC)
    # Both MSVC and MSVC-like command-line interface compilers (Clang-cl)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32 /EHsc")
endif ()

add_library(${PROJECT_NAME} SHARED library.cpp)
add_compile_definitions(MIMGUI_SVG_VERSION="${CMAKE_PROJECT_VERSION}")

#find_package(lunasvg REQUIRED)

target_include_directories(${PROJECT_NAME} PRIVATE "${LUNASVG_INCLUDE_DIR}")
target_link_libraries(${PROJECT_NAME} PRIVATE "${LUNASVG_LIBRARIES}")
