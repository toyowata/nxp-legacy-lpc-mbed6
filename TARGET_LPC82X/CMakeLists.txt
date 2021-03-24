# Copyright (c) 2020 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

if(${MBED_TOOLCHAIN} STREQUAL "ARM")
    set(LINKER_FILE device/TOOLCHAIN_ARM_STD/LPC824.sct)
    set(STARTUP_FILE device/TOOLCHAIN_ARM_STD/startup_LPC8xx.S)
elseif(${MBED_TOOLCHAIN} STREQUAL "GCC_ARM")
    set(LINKER_FILE device/TOOLCHAIN_GCC_ARM/LPC824.ld)
    set(STARTUP_FILE device/TOOLCHAIN_GCC_ARM/startup_LPC824.S)
endif()

if("LPC824" IN_LIST MBED_TARGET_LABELS)
    set(PINNAME TARGET_LPC824)
endif()
if("SSCI824" IN_LIST MBED_TARGET_LABELS)
    set(PINNAME TARGET_SSCI824)
endif()

target_include_directories(mbed-core
    INTERFACE
        ${PINNAME}
        .
        device
)

target_sources(mbed-core
    INTERFACE
        ${STARTUP_FILE}
        device/system_LPC8xx.c
        analogin_api.c
        gpio_api.c
        gpio_irq_api.c
        i2c_api.c
        pinmap.c
        pwmout_api.c
        serial_api.c
        sleep.c
        spi_api.c
        us_ticker.c
)

target_link_libraries(mbed-core INTERFACE mbed-cmsis-cortex-m)

add_library(mbed-lpc82x INTERFACE)

target_link_libraries(mbed-lpc82x INTERFACE mbed-core)

add_library(mbed-lpc824 INTERFACE)
add_library(mbed-ssci824 INTERFACE)

mbed_set_linker_script(mbed-lpc824 ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_FILE})
mbed_set_linker_script(mbed-ssci824 ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_FILE})
