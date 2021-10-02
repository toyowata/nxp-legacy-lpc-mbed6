# Copyright (c) 2020 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

add_library(mbed-lpc11uxx INTERFACE)
add_library(mbed-airio-base INTERFACE)
add_library(mbed-ae-lpc11u35-mb INTERFACE)
add_library(mbed-lpc11u35-501 INTERFACE)

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

target_include_directories(mbed-core
    INTERFACE
        ${PINNAME}
        .
        device
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

target_link_libraries(mbed-core INTERFACE mbed-cmsis-cortex-m)
target_link_libraries(mbed-lpc11uxx INTERFACE mbed-core)

mbed_set_linker_script(mbed-lpc11uxx ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_FILE})
mbed_set_linker_script(mbed-airio-base  ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_FILE})
mbed_set_linker_script(mbed-ae-lpc11u35-mb ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_FILE})
mbed_set_linker_script(mbed-lpc11u35-501 ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_FILE})
