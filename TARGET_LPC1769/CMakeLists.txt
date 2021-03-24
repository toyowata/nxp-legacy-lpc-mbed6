# Copyright (c) 2020 ARM Limited. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

if(${MBED_TOOLCHAIN} STREQUAL "ARM")
    set(LINKER_FILE ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/device/TOOLCHAIN_ARM_STD/LPC1768.sct)
    set(STARTUP_FILE ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/device/TOOLCHAIN_ARM_STD/startup_LPC17xx.S)
elseif(${MBED_TOOLCHAIN} STREQUAL "GCC_ARM")
    set(LINKER_FILE ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/device/TOOLCHAIN_GCC_ARM/LPC1768.ld)
    set(STARTUP_FILE ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/device/TOOLCHAIN_GCC_ARM/startup_LPC17xx.S)
endif()

target_include_directories(mbed-core
    INTERFACE
        .
        device
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/device
)

target_sources(mbed-core
    INTERFACE
        clock_init.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/analogin_api.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/analogout_api.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/gpio_api.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/gpio_irq_api.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/i2c_api.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/pinmap.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/port_api.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/pwmout_api.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/reset_reason.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/rtc_api.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/serial_api.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/sleep.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/spi_api.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/us_ticker.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/watchdog_api.c
        ../mbed-os/targets/TARGET_NXP/TARGET_LPC176X/device/system_LPC17xx.c
        ${STARTUP_FILE}
)

target_link_libraries(mbed-core INTERFACE mbed-cmsis-cortex-m)

add_library(mbed-lpc1769 INTERFACE)

target_link_libraries(mbed-lpc1769 INTERFACE mbed-core)

mbed_set_linker_script(mbed-lpc1769 ${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_FILE})
