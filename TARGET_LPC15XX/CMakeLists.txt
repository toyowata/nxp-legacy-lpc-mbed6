# Copyright (c) 2020 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

if(${MBED_TOOLCHAIN} STREQUAL "ARM")
    set(LINKER_FILE device/TOOLCHAIN_ARM_STD/LPC15xx.sct)
    set(STARTUP_FILE device/TOOLCHAIN_ARM_STD/startup_LPC15xx.S)
elseif(${MBED_TOOLCHAIN} STREQUAL "GCC_ARM")
    set(LINKER_FILE device/TOOLCHAIN_GCC_ARM/LPC1549.ld)
    set(STARTUP_FILE device/TOOLCHAIN_GCC_ARM/startup_LPC15xx.S)
endif()

target_include_directories(mbed-core
    INTERFACE
        .
        device
)

target_sources(mbed-core
    INTERFACE
        analogin_api.c
        analogout_api.c
        can_api.c
        gpio_api.c
        gpio_irq_api.c
        i2c_api.c
        pinmap.c
        pwmout_api.c
        rtc_api.c
        serial_api.c
        spi_api.c
        us_ticker.c
        device/system_LPC15xx.c
        ${STARTUP_FILE}
)

target_link_libraries(mbed-core INTERFACE mbed-cmsis-cortex-m)

add_library(mbed-lpc15xx INTERFACE)

target_link_libraries(mbed-lpc15xx INTERFACE mbed-core)

add_library(mbed-lpc1549 INTERFACE)

mbed_set_linker_script(mbed-lpc1549 ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_FILE})

