# Copyright (c) 2020 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

if(${MBED_TOOLCHAIN} STREQUAL "ARM")
    set(LINKER_FILE device/TOOLCHAIN_ARM_STD/LPC11U35.sct)
    set(STARTUP_FILE device/TOOLCHAIN_ARM_STD/startup_LPC11xx.S)
elseif(${MBED_TOOLCHAIN} STREQUAL "GCC_ARM")
    set(LINKER_FILE device/TOOLCHAIN_GCC_ARM/LPC11U35.ld)
    set(STARTUP_FILE device/TOOLCHAIN_GCC_ARM/startup_LPC11xx.S)
endif()

if("AIRIO_BASE" IN_LIST MBED_TARGET_LABELS)
    set(PINNAME TARGET_AIRIO_BASE)
endif()
if("AE_LPC11U35_MB" IN_LIST MBED_TARGET_LABELS)
    set(PINNAME TARGET_MCU_LPC11U35/TARGET_AE_LPC11U35_MB)
endif()
if("LPC11U35_501" IN_LIST MBED_TARGET_LABELS)
    set(PINNAME TARGET_MCU_LPC11U35/TARGET_LPC11U35_501)
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
        ${PINNAME}
)

target_sources(mbed-core
    INTERFACE
        analogin_api.c
        gpio_api.c
        gpio_irq_api.c
        i2c_api.c
        PeripheralPins.c
        pinmap.c
        port_api.c
        pwmout_api.c
        serial_api.c
        sleep.c
        spi_api.c
        us_ticker.c
        USBHAL_LPC11U.cpp
        device/system_LPC11Uxx.c
        device/cmsis_nvic.c
        ${STARTUP_FILE}
)