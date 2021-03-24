/* mbed Microcontroller Library
 * Copyright (c) 2019 ARM Limited
 * SPDX-License-Identifier: Apache-2.0
 */
#if MBED_BLINKY_EXAMPLE
#ifndef MBED_TEST_MODE

#include "mbed.h"

int main()
{
    // Initialise the digital pin LED1 as an output
    DigitalOut led(LED1);
    thread_sleep_for(500);

    printf("\n[Build] %s %s\n", __DATE__, __TIME__);

#if defined (__GNUC__)
#if defined (__ARMCC_VERSION)
    printf("Built with ARM compiler 6\n");
    printf("Arm compiler version %d\n", __ARMCC_VERSION);
#else
    printf("Built with GNU compiler\n");
    printf("Compatible GCC version %d.%d, %s\n", __GNUC__, __GNUC_MINOR__, __VERSION__);
#endif
#endif

#ifdef MBED_MAJOR_VERSION
    printf("Mbed OS version %d.%d.%d\n\n", MBED_MAJOR_VERSION, MBED_MINOR_VERSION, MBED_PATCH_VERSION);
#endif
    printf("hello, Mbed OS\n");
    printf("SystemCoreClock = %ld\n", SystemCoreClock);
    while (true) {
        led = !led;
        thread_sleep_for(500);
    }
}

#endif /* MBED_TEST_MODE */
#endif /* MBED_BLINKY_EXAMPLE */
