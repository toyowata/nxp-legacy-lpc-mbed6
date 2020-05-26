/* mbed Microcontroller Library
 * Copyright (c) 2019 ARM Limited
 * SPDX-License-Identifier: Apache-2.0
 */
#ifdef MBED_BLINKY_EXAMPLE
#ifndef MBED_TEST_MODE

#include "mbed.h"

// Blinking rate in milliseconds
#define BLINKING_RATE_MS     500

int main()
{
    // Initialise the digital pin LED1 as an output
    DigitalOut led(LED1);

    printf("hello, Mbed OS 6\n");
    while (true) {
        led = !led;
        thread_sleep_for(BLINKING_RATE_MS);
    }
}

#endif /* MBED_TEST_MODE */
#endif /* MBED_BLINKY_EXAMPLE */
