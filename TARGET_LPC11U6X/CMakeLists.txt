# Copyright (c) 2020 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

if(${MBED_TOOLCHAIN} STREQUAL "ARM")
    set(LINKER_FILE device/TOOLCHAIN_ARM_STD/TARGET_LPC11U68/LPC11U68.sct)
    set(STARTUP_FILE device/TOOLCHAIN_ARM_STD/TARGET_LPC11U68/startup_LPC11U6x.S)
elseif(${MBED_TOOLCHAIN} STREQUAL "GCC_ARM")
    set(LINKER_FILE device/TOOLCHAIN_GCC_ARM/TARGET_LPC11U68/LPC11U68.ld)
    set(STARTUP_FILE device/TOOLCHAIN_GCC_ARM/TARGET_LPC11U68/startup_LPC11U68.cpp)
endif()

set_property(
    GLOBAL PROPERTY
    MBED_TARGET_LINKER_FILE
        ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_FILE}
)

target_include_directories(mbed-core
    INTERFACE
        .
        device
)

target_sources(mbed-core
    INTERFACE
        analogin_api.c
        gpio_api.c
        gpio_irq_api.c
        i2c_api.c
        pinmap.c
        pwmout_api.c
        rtc_api.c
        serial_api.c
        sleep.c
        spi_api.c
        us_ticker.c
        device/system_LPC11U6x.c
        ${STARTUP_FILE}
)