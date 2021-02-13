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

    printf("[Build] %s %s\n", __DATE__, __TIME__);
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
