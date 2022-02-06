/* mbed Microcontroller Library
 * Copyright (c) 2019 ARM Limited
 * SPDX-License-Identifier: Apache-2.0
 */
#if MBED_BLINKY_EXAMPLE
#ifndef MBED_TEST_MODE

#include "mbed.h"

#define ROM_TEST    0

#if (ROM_TEST == 1)
const char array_0[1024 * 1] = {"zero"};
const char array_1[1024 * 2] = {"one"};
const char array_2[1024 * 4] = {"two"};
const char array_3[1024 * 8] = {"three"};
const char array_4[1024 *16] = {"four"};
const char array_5[1024 *32] = {"five"};
const char array_6[1024 *64] = {"six"};
#endif

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

#if (ROM_TEST == 1)
    printf("\n[ROM test result]\n");
    printf("0x%08X-0x%08X: %5d: %s\n", (unsigned int)array_0, (unsigned int)(array_0 + sizeof(array_0)), sizeof(array_0), array_0);
    printf("0x%08X-0x%08X: %5d: %s\n", (unsigned int)array_1, (unsigned int)(array_1 + sizeof(array_1)), sizeof(array_1), array_1);
    printf("0x%08X-0x%08X: %5d: %s\n", (unsigned int)array_2, (unsigned int)(array_2 + sizeof(array_2)), sizeof(array_2), array_2);
    printf("0x%08X-0x%08X: %5d: %s\n", (unsigned int)array_3, (unsigned int)(array_3 + sizeof(array_3)), sizeof(array_3), array_3);
    printf("0x%08X-0x%08X: %5d: %s\n", (unsigned int)array_4, (unsigned int)(array_4 + sizeof(array_4)), sizeof(array_4), array_4);
//    printf("0x%08X-0x%08X: %5d: %s\n", (unsigned int)array_5, (unsigned int)(array_5 + sizeof(array_5)), sizeof(array_5), array_5);
//    printf("0x%08X-0x%08X: %5d: %s\n", (unsigned int)array_6, (unsigned int)(array_6 + sizeof(array_6)), sizeof(array_6), array_6);
#endif

    while (true) {
        led = !led;
        thread_sleep_for(500);
    }
}

#endif /* MBED_TEST_MODE */
#endif /* MBED_BLINKY_EXAMPLE */
