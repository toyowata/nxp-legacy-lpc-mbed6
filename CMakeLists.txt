# Copyright (c) 2020 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required(VERSION 3.19.0 FATAL_ERROR)

set(MBED_PATH ${CMAKE_CURRENT_SOURCE_DIR}/mbed-os CACHE INTERNAL "")
set(MBED_CONFIG_PATH ${CMAKE_CURRENT_SOURCE_DIR}/.mbedbuild CACHE INTERNAL "")
set(APP_TARGET nxp-legacy-lpc-mbed6)

include(${MBED_PATH}/tools/cmake/app.cmake)

add_subdirectory(${MBED_PATH})

if("LPC11UXX" IN_LIST MBED_TARGET_LABELS)
    add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/TARGET_LPC11UXX)
endif()
if("LPC15XX" IN_LIST MBED_TARGET_LABELS)
    add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/TARGET_LPC15XX)
endif()
if("LPC82X" IN_LIST MBED_TARGET_LABELS)
    add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/TARGET_LPC82X)
endif()
if("LPC1769" IN_LIST MBED_TARGET_LABELS)
    add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/TARGET_LPC1769)
endif()

add_executable(${APP_TARGET})

mbed_configure_app_target(${APP_TARGET})

mbed_set_mbed_target_linker_script(${APP_TARGET})

project(${APP_TARGET})

target_sources(${APP_TARGET}
    PRIVATE
        main.cpp
)

target_link_libraries(${APP_TARGET}
    PRIVATE
        mbed-os
)

mbed_set_post_build(${APP_TARGET})

option(VERBOSE_BUILD "Have a verbose build process")
if(VERBOSE_BUILD)
    set(CMAKE_VERBOSE_MAKEFILE ON)
endif()